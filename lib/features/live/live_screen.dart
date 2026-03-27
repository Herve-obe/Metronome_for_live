import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/audio/metronome_engine.dart';

final themeColorProvider = StateProvider<Color>((ref) => const Color(0xFF00FF55));
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(metronomeEngineProvider).init();
    });
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

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(metronomePlayingProvider);
    final isFlashing = ref.watch(metronomeFlashProvider);
    final beat = ref.watch(metronomeBeatProvider);
    final subTick = ref.watch(metronomeSubTickProvider);
    final bpm = ref.watch(metronomeBpmProvider);
    final numerator = ref.watch(metronomeSignatureNumeratorProvider);
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
                    "TOUR 2026 - PARIS", 
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

            // --- CERCLE CENTRAL ---
            AnimatedContainer(
              // Décélération très rapide (80ms) pour que l'effet visuel soit ultra bref
              duration: Duration(milliseconds: isFlashing ? 0 : 80), 
              width: 340, 
              height: 340,
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
                    "BLOC 2: REFRAIN",
                    style: TextStyle(color: themeColor, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
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
                    child: Text(
                      '$bpm',
                      style: const TextStyle(
                        fontSize: 110, 
                        color: Colors.white, 
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
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
                    onPressed: () {
                      engine.enableCrescendo(
                        targetBpm: bpm + 20, 
                        step: 5, 
                        intervalBeats: numerator, // Toutes les X mesures
                      );
                    },
                    child: const Text('CRESC.'),
                  ),
                  DropdownButton<int>(
                    value: numerator,
                    dropdownColor: const Color(0xFF222222),
                    iconEnabledColor: themeColor,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    underline: Container(height: 1, color: themeColor.withValues(alpha: 0.5)),
                    items: [1, 2, 3, 4, 5, 6, 7, 8, 9].map((val) => DropdownMenuItem(value: val, child: Text('$val / 4'))).toList(),
                    onChanged: (val) {
                      if (val != null) engine.setSignature(val);
                    },
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
                  const Text("Mesure 4/8", style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                  if (isPlaying) engine.stop(); else engine.start();
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
