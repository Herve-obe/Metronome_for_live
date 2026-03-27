import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/audio/metronome_engine.dart';

final themeColorProvider = StateProvider<Color>((ref) => const Color(0xFF00D4FF));
final availableColors = [
  const Color(0xFF00FF55), // Vert néon
  const Color(0xFF00D4FF), // Cyan
  const Color(0xFFFF0055), // Rose néon
  const Color(0xFFFFCC00), // Jaune
  const Color(0xFFAA00FF), // Violet
];

class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key});

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen> {
  double _lastAngle = 0.0;
  double _jogAccumulator = 0.0;
  double _wheelAngle = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(metronomeEngineProvider).init();
    });
  }

  void _onPanStart(DragStartDetails details) {
    final center = const Offset(170, 170);
    final offset = details.localPosition - center;
    _lastAngle = offset.direction;
  }

  void _onPanUpdate(DragUpdateDetails details, int currentBpm, MetronomeEngine engine) {
    final center = const Offset(170, 170);
    final offset = details.localPosition - center;
    final angle = offset.direction;

    double angleDiff = angle - _lastAngle;
    if (angleDiff > pi) angleDiff -= 2 * pi;
    if (angleDiff < -pi) angleDiff += 2 * pi;

    _lastAngle = angle;
    setState(() {
      _wheelAngle += angleDiff;
    });
    _jogAccumulator += angleDiff;

    // Sensibilité de la roulette : 0.08 radian pour 1 BPM
    const double threshold = 0.08;

    if (_jogAccumulator.abs() > threshold) {
      int steps = (_jogAccumulator / threshold).truncate();
      _jogAccumulator -= steps * threshold;
      
      int newBpm = currentBpm + steps;
      if (newBpm < 40) newBpm = 40;
      if (newBpm > 320) newBpm = 320;
      engine.setBpm(newBpm);
    }
  }

  void _showSettingsMenu(BuildContext context, Color currentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couleur du thème", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableColors.map((color) => GestureDetector(
                  onTap: () {
                    ref.read(themeColorProvider.notifier).state = color;
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: currentColor == color ? 4 : 0),
                      boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 2)],
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

  void _showCrescendoDialog(BuildContext context, MetronomeEngine engine, int currentBpm) {
    final targetCtrl = TextEditingController(text: (currentBpm + 20).toString());
    final stepCtrl = TextEditingController(text: '5');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Programmer un Crescendo', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "BPM d'arrivée (actuel: $currentBpm)",
                labelStyle: const TextStyle(color: Colors.white54),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: stepCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Incrément (+X BPM par mesure)",
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler", style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () {
            final target = int.tryParse(targetCtrl.text) ?? currentBpm + 20;
            final step = int.tryParse(stepCtrl.text) ?? 5;
            engine.enableCrescendo(
              targetBpm: target,
              step: step,
              intervalBeats: ref.read(metronomeSignatureNumeratorProvider)
            );
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Crescendo programmé vers $target BPM ! Lancez la lecture !')));
          }, child: const Text("Activer", style: TextStyle(color: Colors.blueAccent))),
        ],
      )
    );
  }

  Widget _buildBpmButton(String label, VoidCallback onPressed, Color color) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color, width: 2),
          boxShadow: [
             BoxShadow(
               color: color.withValues(alpha: 0.2),
               blurRadius: 10,
               spreadRadius: 2,
             )
          ]
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(metronomePlayingProvider);
    final isFlashing = ref.watch(metronomeFlashProvider);
    final beat = ref.watch(metronomeBeatProvider);
    final subTick = ref.watch(metronomeSubTickProvider);
    final bpm = ref.watch(metronomeBpmProvider);
    final numerator = ref.watch(metronomeSignatureNumeratorProvider);
    final denominator = ref.watch(metronomeSignatureDenominatorProvider);
    final subdivision = ref.watch(metronomeSubdivisionProvider);
    final themeColor = ref.watch(themeColorProvider);
    final engine = ref.read(metronomeEngineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Fond encore plus profond
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_left, color: Colors.white, size: 24),
                    label: const Text("PRÉCÉDENT", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const Text(
                    "CONTRÔLE DIRECT", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Text("SUIVANT", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_right, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white54),
                        onPressed: () => _showSettingsMenu(context, themeColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            
            const Spacer(),

            // --- CORPS CENTRAL AVEC BOUTONS RAPIDES ET JOG WHEEL ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Colonne de boutons -
                Column(
                  children: [
                    _buildBpmButton('/ 2', () => engine.setBpm((bpm / 2).round()), themeColor),
                    const SizedBox(height: 20),
                    _buildBpmButton('- 5', () => engine.setBpm(bpm - 5), themeColor),
                    const SizedBox(height: 20),
                    _buildBpmButton('- 1', () => engine.setBpm(bpm - 1), themeColor),
                  ],
                ),
                
                const SizedBox(width: 20),

                // Cercle central avec Jog Wheel
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: (details) => _onPanUpdate(details, bpm, engine),
                  onDoubleTap: () async {
                    final newBpmStr = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController(text: bpm.toString());
                        return AlertDialog(
                          backgroundColor: const Color(0xFF222222),
                          title: const Text('Entrer le BPM', style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, color: Colors.white),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            ),
                            onSubmitted: (val) => Navigator.of(context).pop(val),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Annuler', style: TextStyle(color: Colors.white54))),
                            TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: Text('OK', style: TextStyle(color: themeColor))),
                          ],
                        );
                      },
                    );
                    if (newBpmStr != null) {
                      final selectedBpm = int.tryParse(newBpmStr);
                      if (selectedBpm != null) engine.setBpm(selectedBpm);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // La roue externe (Jog wheel visible)
                      Transform.rotate(
                        angle: _wheelAngle,
                        child: Container(
                          width: 340,
                          height: 340,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: themeColor.withValues(alpha: 0.3), width: 3),
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 14, height: 14,
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                            ),
                          ),
                        ),
                      ),
                      // Le cercle pulsant
                      AnimatedContainer(
                        duration: Duration(milliseconds: isFlashing ? 0 : 80), 
                        width: 310, 
                        height: 310,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeColor,
                            width: isFlashing && subTick == 1 ? (beat == 1 ? 24 : 10) : 4,
                          ),
                          boxShadow: isFlashing && isPlaying 
                          ? [
                            BoxShadow(
                              color: themeColor.withValues(alpha: subTick == 1 ? (beat == 1 ? 1.0 : 0.6) : 0.2),
                              blurRadius: subTick == 1 ? (beat == 1 ? 100 : 50) : 20,
                              spreadRadius: subTick == 1 ? (beat == 1 ? 40 : 10) : 2,
                            ),
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.2),
                              blurRadius: 150,
                              spreadRadius: 60,
                            )
                          ] : [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.05),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PULSE",
                              style: TextStyle(color: themeColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$bpm',
                              style: const TextStyle(
                                fontSize: 100, 
                                color: Colors.white, 
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Colonne de boutons +
                Column(
                  children: [
                    _buildBpmButton('x 2', () => engine.setBpm(bpm * 2), themeColor),
                    const SizedBox(height: 20),
                    _buildBpmButton('+ 5', () => engine.setBpm(bpm + 5), themeColor),
                    const SizedBox(height: 20),
                    _buildBpmButton('+ 1', () => engine.setBpm(bpm + 1), themeColor),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // --- OPTIONS RAPIDES ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: themeColor,
                      side: BorderSide(color: themeColor.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: engine.tapTempo,
                    icon: const Icon(Icons.touch_app, size: 20),
                    label: const Text('TAP'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: themeColor,
                      side: BorderSide(color: themeColor.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () => _showCrescendoDialog(context, engine, bpm),
                    child: const Text('CRESC.'),
                  ),
                  Row(
                    children: [
                      DropdownButton<int>(
                        value: numerator,
                        dropdownColor: const Color(0xFF222222),
                        iconEnabledColor: themeColor,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        underline: Container(height: 1, color: themeColor.withValues(alpha: 0.5)),
                        items: List.generate(16, (i) => i + 1).map((val) => DropdownMenuItem(value: val, child: Text('$val'))).toList(),
                        onChanged: (val) {
                          if (val != null) engine.setSignature(val, denominator);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text('/', style: TextStyle(color: Colors.white54, fontSize: 16)),
                      ),
                      DropdownButton<int>(
                        value: denominator,
                        dropdownColor: const Color(0xFF222222),
                        iconEnabledColor: themeColor,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        underline: Container(height: 1, color: themeColor.withValues(alpha: 0.5)),
                        items: [2, 4, 8, 16].map((val) => DropdownMenuItem(value: val, child: Text('$val'))).toList(),
                        onChanged: (val) {
                          if (val != null) engine.setSignature(numerator, val);
                        },
                      ),
                    ],
                  ),
                  DropdownButton<int>(
                    value: subdivision,
                    dropdownColor: const Color(0xFF222222),
                    iconEnabledColor: themeColor,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    underline: Container(height: 1, color: themeColor.withValues(alpha: 0.5)),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Noires')),
                      DropdownMenuItem(value: 2, child: Text('Croches')),
                      DropdownMenuItem(value: 3, child: Text('Triolets')),
                      DropdownMenuItem(value: 4, child: Text('Doubles')),
                    ],
                    onChanged: (val) {
                      if (val != null) engine.setSubdivision(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- BARRE DE MESURE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text("Mesure $numerator/$denominator", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(isPlaying ? "Mesure courante (Beat $beat)" : "En pause", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- BOUTON PLAY/STOP ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: InkWell(
                onTap: () {
                  if (isPlaying) {
                    engine.stop();
                  } else {
                    engine.start();
                  }
                },
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: [
                        themeColor.withValues(alpha: 0.3),
                        themeColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(color: themeColor.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(isPlaying ? Icons.stop : Icons.play_arrow, color: Colors.white, size: 30),
                         const SizedBox(width: 12),
                         const Text("PLAY / STOP", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
