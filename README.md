# 🥁 Metronome for Live

> Métronome professionnel cross-platform (Android / iOS) conçu pour les batteurs de metal en conditions live.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)]()

---

## 🎯 Objectif

Application mobile open source remplaçant l'usage d'un PC de studio (Pro Tools) pour le suivi des tempos en live. Elle gère des **setlists complètes** avec des tempos précis par section, utilisable en répétition et sur scène.

---

## 📋 Documentation

- 📄 **[Cahier des charges complet](cahier_des_charges_metronome.md)** — Toutes les specs fonctionnelles et techniques
- 📝 **[Journal de développement](DEVLOG.md)** — État d'avancement, décisions techniques, prochaines étapes

---

## 🏗️ Stack technique

| Composant | Technologie |
|---|---|
| Framework | Flutter (Dart) |
| Architecture | Feature-first + Riverpod |
| Audio | `just_audio` + plugin natif bas latence |
| Base de données | SQLite (`sqflite`) |
| Routeur | `go_router` |
| TTS | TTS natif Android/iOS + option Piper TTS (offline HD) |
| Cloud (optionnel) | Firebase (Firestore + Auth) |

---

## 🗂️ Structure du projet (à venir)

```
lib/
├── core/                  # Moteur métronome, audio, modèles
│   ├── audio/             # Service audio bas latence
│   ├── models/            # Block, Song, Setlist, Project
│   └── database/          # sqflite + DAOs
├── features/
│   ├── creation/          # Mode Création 🛠️
│   ├── rehearsal/         # Mode Répétition 🎸
│   └── live/              # Mode Live 🎤
├── shared/                # Widgets, thème, constantes
└── main.dart
```

---

## 🚀 Fonctionnalités clés

- **3 modes** : Création / Répétition / Live
- **Système de blocs** : sections musicales indépendantes (BPM, signature, crescendo, décompte)
- **Setlists** jusqu'à 99 morceaux avec navigation rapide
- **Annonce TTS** avant chaque bloc (nom + décompte vocal)
- **Tap Tempo** disponible dans tous les modes
- **Latence audio** < 20ms (objectif < 10ms)
- **Indicateur visuel** : cercle pulsant + barre de mesure synchronisés
- **100% offline**, partage cloud optionnel

---

## 📱 Plateformes

| OS | Version minimale |
|---|---|
| Android | 8.0 (API 26+) |
| iOS | 13+ |

---

## 📦 Installation (développeurs)

> ⚠️ **Voir [DEVLOG.md](DEVLOG.md) pour l'état actuel avant de commencer.**

```bash
# Prérequis : Flutter 3.x installé
git clone https://github.com/Herve-obe/Metronome_for_live.git
cd Metronome_for_live
flutter pub get
flutter run
```

---

## 📅 Phases de développement

- **Phase 1** — MVP Core (métronome, blocs, chansons, setlists, 3 modes, TTS, stockage local)
- **Phase 2** — Enrichissement (templates, projets, cloud, Piper TTS, import/export)
- **Phase 3** — Distribution (pédalier Bluetooth, Play Store, App Store)

---

## 📄 Licence

Open Source — MIT License
