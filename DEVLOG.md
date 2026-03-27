# Journal de développement — Metronome for Live

> Ce fichier est la **source de vérité** pour reprendre le développement sur n'importe quelle machine.  
> Mis à jour le : 27 mars 2026

---

## 💻 Environnement de développement (poste actuel)

> ⚠️ **À lire en priorité au démarrage d'une nouvelle session** pour reconfigurer l'environnement si nécessaire.

| Outil | Version | Emplacement | Statut |
|---|---|---|---|
| **Git** | 2.53.0 | Dans le PATH système | ✅ OK |
| **Flutter SDK** | 3.41.5 (stable) | `E:\flutter` | ✅ OK |
| **Dart** | Inclus dans Flutter | `E:\flutter\bin` | ✅ OK |
| **Android Studio** | Panda 2 (Jellyfish+) | Chemin par défaut | ✅ Installé |
| **Android SDK** | Via Android Studio Wizard | `%LOCALAPPDATA%\Android\Sdk` (par défaut) | ✅ Téléchargé via wizard |
| **VS Code** | 1.108.1 | Dans le PATH | ✅ OK |
| **Extensions VS Code** | Flutter + Dart + Riverpod Snippets | — | ✅ Installées |
| **Visual Studio Build Tools** | 2022 17.x | — | ✅ OK (détecté par flutter doctor) |

### PATH utilisateur
- `E:\flutter\bin` a été ajouté au PATH utilisateur Windows le 27/03/2026
- Si Flutter n'est plus reconnu après reboot : Paramètres Windows → Variables d'environnement → PATH utilisateur → vérifier que `E:\flutter\bin` est présent

### Vérification rapide (à faire en début de session)
```powershell
flutter doctor
```
Résultat attendu : tout ✅ sauf éventuellement les licences Android.
Si licences pas acceptées :
```powershell
flutter doctor --android-licenses
```

---

## 📍 État actuel

**Phase :** 0 — Initialisation  
**Statut :** ⏳ Projet Flutter NON encore créé

### ✅ Fait
- Cahier des charges complet rédigé et pushé (`cahier_des_charges_metronome.md`)
- README et DEVLOG créés
- Repo git initialisé sur `master`, remote GitHub configuré
- Flutter 3.41.5 installé dans `E:\flutter` et PATH configuré
- Android Studio Panda 2 installé avec SDK Android (via Setup Wizard)
- VS Code avec extensions Flutter/Dart/Riverpod installées

### 🔜 Prochaines étapes immédiates (dans cet ordre)

1. **Accepter les licences Android** (si pas encore fait)
   ```powershell
   flutter doctor --android-licenses
   ```
   Taper `y` à chaque invite.

2. **Créer le projet Flutter** dans le dossier cloné
   ```powershell
   # Le repo est déjà cloné dans E:\METRONOME APP
   # Se placer dans le dossier et créer le projet Flutter
   flutter create . --org com.herveobe --project-name metronome_for_live
   ```

3. **Configurer `pubspec.yaml`** — Remplacer le contenu généré par :
   ```yaml
   name: metronome_for_live
   description: Professional live metronome for drummers
   version: 1.0.0+1

   environment:
     sdk: '>=3.0.0 <4.0.0'
     flutter: '>=3.10.0'

   dependencies:
     flutter:
       sdk: flutter
     # State management
     flutter_riverpod: ^2.5.1
     riverpod_annotation: ^2.3.5
     # Navigation
     go_router: ^13.2.0
     # Audio
     just_audio: ^0.9.36
     audio_session: ^0.1.18
     # Database
     sqflite: ^2.3.3+1
     path: ^1.9.0
     # TTS
     flutter_tts: ^4.0.2
     # Utils
     freezed_annotation: ^2.4.1
     json_annotation: ^4.9.0
     uuid: ^4.4.0
     intl: ^0.19.0

   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^3.0.0
     build_runner: ^2.4.9
     freezed: ^2.5.2
     json_serializable: ^6.7.6
     riverpod_generator: ^2.4.0
   ```

4. **Mettre en place l'architecture feature-first**
   ```
   lib/
   ├── core/
   │   ├── audio/          # MetronomeEngine, AudioService
   │   ├── models/         # Block, Song, Setlist, Project (freezed)
   │   ├── database/       # AppDatabase, DAOs
   │   └── tts/            # TtsService
   ├── features/
   │   ├── creation/       # Écrans mode Création
   │   ├── rehearsal/      # Écrans mode Répétition
   │   └── live/           # Écrans mode Live
   ├── shared/
   │   ├── theme/          # AppTheme (dark par défaut)
   │   ├── widgets/        # Widgets communs
   │   └── router/         # AppRouter (go_router)
   └── main.dart
   ```

5. **Commencer par le moteur métronome** (`lib/core/audio/metronome_engine.dart`)
   - C'est la brique la plus critique (latence < 20ms)
   - Utiliser `just_audio` avec des fichiers audio courts pré-chargés en mémoire
   - Timer haute précision via `Isolate` ou `dart:async` Stopwatch

---

## 🎨 Design

- **Thème :** Dark par défaut
- **Couleur accent :** À définir (proposer plusieurs options à l'utilisateur)
- **Police :** À définir (suggestion : Nunito ou Rajdhani pour le côté "metal/tech")

---

## 🔑 Décisions techniques prises

| Sujet | Décision | Raison |
|---|---|---|
| Framework | Flutter | Cross-platform Android+iOS, une seule base de code |
| State management | Riverpod | Modern, compile-safe, adapté aux états audio |
| Audio | just_audio + AudioSession | Meilleur support latence faible, AudioFocus Android |
| BDD locale | sqflite | Mature, rapide, 100% offline |
| TTS natif | flutter_tts | Zéro dépendance externe, marche partout |
| TTS HD | Piper TTS (option) | Open source Mozilla/Rhasspy, offline, FR+EN |
| Routeur | go_router | Standard Flutter recommandé |
| Modèles | freezed | Immutabilité, copyWith, JSON auto |

---

## 🎸 Rappel fonctionnel rapide

### Hiérarchie des données
```
Projet (ex: "Mon Groupe")
├── Chansons
│   └── Chanson → [Bloc1, Bloc2, Bloc3, ...]
└── Setlists
    └── Setlist → [Chanson1, Chanson2, ...]
```

### Un Bloc contient
- Nom, BPM départ, BPM fin, Signature (X/Y)
- Durée (mesures fixes OU boucle manuelle)
- Type de variation (brutale / crescendo beat-par-beat / par paliers)
- Annonce TTS (texte + nombre de temps de décompte)

### 3 Modes
- 🛠️ **Création** : éditeur complet, tous les paramètres accessibles
- 🎸 **Répétition** : UI simplifiée, boutons plus grands
- 🎤 **Live** : BPM TRÈS GRAND, boutons larges, aucun paramètre modifiable, anti-fat-finger

---

## 📱 Écran Live (wireframe)
```
┌─────────────────────────────────┐
│  ◀ Précédent   [SETLIST]   Suivant ▶ │
├─────────────────────────────────┤
│       NOM DU MORCEAU            │
│       NOM DU BLOC COURANT       │
│                                 │
│         ⬤  140 BPM  ⬤          │
│                                 │
│  ████████████░░░░░░░░░░░░░░░░   │
│           Mesure 4/8            │
│                                 │
│        ▶ PLAY / STOP            │
└─────────────────────────────────┘
```

---

## ⚠️ Points critiques à ne pas oublier

1. **Latence audio** : c'est LA priorité. Tester sur vrai appareil dès le début.
2. **AudioFocus Android** : le clic doit prendre la priorité audio sur les autres apps.
3. **Écran allumé** : activer `WakeLock` pendant le jeu (sinon l'écran se met en veille).
4. **Mode Live anti-fat-finger** : espacement minimum 48dp entre boutons, confirmation sur actions destructives.
5. **TTS timing** : l'annonce DOIT finir AVANT le premier temps du décompte.

---

## 🔗 Ressources utiles

- Flutter install Windows : https://docs.flutter.dev/get-started/install/windows/mobile
- just_audio : https://pub.dev/packages/just_audio
- flutter_riverpod : https://riverpod.dev
- go_router : https://pub.dev/packages/go_router
- sqflite : https://pub.dev/packages/sqflite
- flutter_tts : https://pub.dev/packages/flutter_tts
- Piper TTS (voix HD offline) : https://github.com/rhasspy/piper

---

*Document maintenu par Antigravity AI — Sessions des 25 et 27 mars 2026*
