# Cahier des Charges — Application Métronome Live

> **Projet :** Metronome for Live  
> **Repo :** https://github.com/Herve-obe/Metronome_for_live  
> **Date :** 25 mars 2026  
> **Version :** 1.0 — Draft initial  
> **Statut :** En cours de validation

---

## 1. Contexte & Objectif

L'application est destinée à un batteur de groupe de metal souhaitant disposer d'un métronome professionnel utilisable en conditions réelles (répétition, concert). Elle doit remplacer l'usage d'un PC de studio (Pro Tools) pour le suivi des tempos en live.

**Cibles :** Musiciens en groupe, principalement des batteurs.  
**Plateformes :** Android (prioritaire) + iOS (compatibilité requise).  
**Distribution :** Gratuite, sans publicité, sur Google Play Store et Apple App Store.  
**Licence :** Open Source.

---

## 2. Technologie

| Critère | Choix recommandé | Justification |
|---|---|---|
| Framework | **Flutter** | Android + iOS depuis une seule base de code, excellent support audio bas niveau, UI fluide |
| Langage | Dart | Natif Flutter |
| Moteur audio | `flutter_audio_engine` / `just_audio` + plugin natif | Faible latence critique |
| TTS | TTS natif Android/iOS (par défaut) + pack voix HD téléchargeable | Compromis qualité/poids |
| Stockage local | SQLite (`sqflite`) | Données hors ligne, rapide |
| Cloud optionnel | Firebase (Firestore + Auth) | Sync et partage multi-membres |

---

## 3. Modes de l'application

L'application fonctionne selon **3 modes distincts**, accessibles depuis un menu principal :

### 3.1 Mode Création 🛠️
> *Composition des chansons, réglages fins, création de blocs et setlists.*

- Accès à tous les paramètres
- Interface complète avec formulaires et éditeurs
- Pas de contrainte d'ergonomie live
- Navigation standard

### 3.2 Mode Répétition 🎸
> *Usage en salle de répétition, accès simplifié mais avec du choix.*

- Affichage épuré mais avec navigation dans les setlists/morceaux
- Boutons plus grands
- Accès rapide aux chansons et sections
- Paramètres non-critiques masqués
- Possibilité de modifier le tempo à la volée

### 3.3 Mode Live 🎤
> *Usage sur scène, lisibilité maximale, actions rapides.*

- Affichage ultra-simplifié : **BPM en très grand**, nom du bloc courant, indicateur visuel du clic
- Boutons larges et avec grand espacement (transpiration, faible luminosité, stress)
- Navigation : bouton "Suivant" + swipe + appui sur morceau dans la setlist
- Aucune modification de paramètres possible (sauf tempo live optionnel)
- Anti-manipulation accidentelle

---

## 4. Fonctionnalités du Métronome

### 4.1 Tempo
- **Plage :** 40 à 320 BPM
- **Résolution :** entiers uniquement (pas de demi-BPM)
- **Ajustement :** slider + boutons +1/-1
- **Tap Tempo :** disponible dans **tous les modes** (bouton dédié), calcule le BPM moyen des derniers appuis

### 4.2 Signature rythmique
- **Numérateur (haut) :** de 1 à 9
- **Dénominateur (bas) :** 1, 2, 4, 8, 16
- Réglage indépendant par bloc
- Exemple : 4/4, 7/8, 6/8, 5/4…

### 4.3 Subdivisions
- Activation/désactivation des subdivisions (croches, triolets, doubles croches)
- Son distinct des temps principaux et des accents

### 4.4 Accent sur le temps 1
- Activable/désactivable
- Son et/ou volume différent sur le premier temps de chaque mesure

### 4.5 Indicateur visuel du clic
- **Cercle pulsant** (Animation scale/opacity synchronisée avec le beat)
- **Barre de progression** de la mesure en cours
- Synchronisation son/image **garantie et prioritaire** (latence max. acceptable : <10ms)

### 4.6 Sons du clic
- Bibliothèque de sons intégrés (minimum 5 au lancement) : click bois, bip électronique, baguette, cowbell, bip aigu
- Son distinct pour : temps 1 accentué, temps courant, subdivisions
- Sélection indépendante de chaque type de son

### 4.7 Audio
- **Sortie son :** haut-parleur téléphone + casque/in-ear (avec détection automatique)
- **Balance clic :** contrôle du volume indépendant du volume système
- **Gestion stéréo :** possibilité de choisir le canal de sortie (gauche, droite, centre) pour les in-ears
- **Priorité audio** : le clic doit couper les autres apps audio si nécessaire (AudioFocus Android)

---

## 5. Système de Blocs

### 5.1 Définition d'un bloc
Un **bloc** est la brique élémentaire d'une chanson. Il représente une section musicale (intro, couplet, refrain, pont, etc.) avec ses propres paramètres.

**Paramètres d'un bloc :**

| Paramètre | Description |
|---|---|
| Nom | Texte libre (ex. "Refrain", "Verse 1", "Outro")  |
| BPM de départ | Entier 40–320 |
| BPM de fin | Entier 40–320 (= BPM départ si pas de variation) |
| Signature | X/Y |
| Durée | Nombre de mesures fixes **ou** boucle manuelle |
| Type de variation | Brutale (saut immédiat) ou Crescendo/Decrescendo |
| Mode crescendo | Progressive (beat par beat) **ou** Par paliers (par mesure) |
| Annonce vocale | Texte annoncé par la TTS avant ce bloc |
| Décompte | Nombre de temps de décompte avant le bloc (0 = désactivé) |

### 5.2 Bibliothèque de blocs (templates)
- Un bloc créé peut être **sauvegardé en tant que template** réutilisable
- Les templates sont accessibles dans toutes les chansons
- Possibilité de modifier un template sans impacter les instances déjà insérées (copie à l'insertion)

### 5.3 Transitions entre blocs
- **Transition brutale :** le nouveau BPM s'applique dès le premier temps du bloc suivant
- **Transition progressive (crescendo/decrescendo) :**
  - **Beat par beat :** interpolation linéaire continue du BPM sur la durée du bloc
  - **Par paliers :** incrémentation du BPM à chaque nouvelle mesure

### 5.4 Mode de fin de bloc
- **Durée fixe (X mesures) :** passage automatique au bloc suivant
- **Boucle manuelle :** le bloc tourne en boucle jusqu'à une action de l'utilisateur pour passer au bloc suivant
  - En **mode Live**, un bouton dédié et visible permet de reprendre la progression (ex. un break qui dure plus longtemps que prévu → un simple appui relance le bloc suivant)
  - Compatible avec swipe et pédalier Bluetooth
- Les 2 modes sont configurables indépendamment pour chaque bloc

---

## 6. Gestion des Chansons

- Chaque chanson est composée d'une **séquence ordonnée de blocs**
- Paramètres globaux de la chanson : titre, artiste/groupe, notes libres, projet parent
- Réorganisation des blocs par glisser-déposer
- Prévisualisation du déroulement complet (timeline textuelle)
- Import/export de chanson (format JSON)

---

## 7. Gestion des Setlists

- Max. **99 morceaux** par setlist
- Titre de la setlist, date, lieu (optionnel)
- Réorganisation par glisser-déposer
- Navigation : swipe gauche/droite entre morceaux, bouton "Suivant", appui direct dans la liste
- Import/export de setlist (format JSON)

---

## 8. Gestion des Projets

Un **projet** est un conteneur de niveau supérieur permettant d'organiser les contenus :

```
Projet (ex: "Nom du Groupe")
├── Chansons
│   ├── Chanson 1
│   │   └── Blocs...
│   └── Chanson 2
├── Setlists
│   ├── Concert Paris 2026
│   └── Répétition Mars
└── Membres (si partage activé)
```

- Plusieurs projets peuvent coexister (utile pour plusieurs groupes)
- Chaque projet est totalement isolé
- Import/Export de projet complet

---

## 9. Synthèse Vocale (TTS)

> **⚠️ Point critique fonctionnel**

### 9.1 Fonctionnement
- Avant chaque bloc, la TTS annonce le **nom du bloc** puis effectue un **décompte vocal** (ex : *"Refrain... 1, 2, 3, 4"*)
- Nombre de temps du décompte : paramétrable par bloc (0 à 8 temps)
- Le décompte se fait au tempo du bloc suivant
- Activation/désactivation globale et par bloc

### 9.2 Options vocales
- **Langue des annonces :** Français ou Anglais (indépendant de la langue de l'interface)
- **Voix par défaut :** TTS natif Android/iOS (aucun téléchargement, qualité variable selon l'appareil)
- **Option voix HD :** téléchargement in-app gratuit de modèles **Piper TTS** (projet open source Mozilla/Rhasspy)
  - Qualité nettement supérieure au TTS natif
  - Entièrement offline après téléchargement
  - Disponible en Français et Anglais
  - Poids : ~50MB par langue
  - Lien projet : https://github.com/rhasspy/piper
- **Volume TTS :** réglable indépendamment du clic

### 9.3 Synchronisation
- L'annonce TTS doit se terminer **avant** le premier temps du décompte
- Si l'annonce est trop longue, le texte est tronqué ou accéléré automatiquement

---

## 10. Paramètres & Options

### 10.1 Audio
- Son du clic (temps 1, autres temps, subdivisions)
- Volume du clic (indépendant du volume système)
- Canal stéréo de sortie (G / D / Centre)
- Volume TTS
- Langue TTS

### 10.2 Interface
- Langue de l'application (FR / EN)
- Thème : Dark / Light (Dark par défaut)
- Orientation écran : Auto / Portrait / Paysage (verrouillable)
- Maintien de l'écran allumé pendant le jeu : ON par défaut (désactivable)
- **Feedback haptique** (vibration sur le temps 1) : désactivé par défaut, activable dans les options

### 10.3 Clic visuel
- Activer/désactiver le cercle pulsant
- Activer/désactiver la barre de progression
- Couleur du clic visuel (plusieurs préréglages)

### 10.4 Count-in (décompte global)
- Activer/désactiver globalement
- Nombre de temps par défaut (1 à 8)
- Son du count-in (peut être distinct du clic principal)

### 10.5 Contrôles physiques & Bluetooth
- Activer/désactiver les commandes via boutons physiques (volume haut/bas, bouton casque)
- Support pédalier Bluetooth (optionnel, si compatible HID ou MIDI-BLE)
- Mapping des boutons configurable

### 10.6 Sauvegarde & Sync
- **Sans compte (anonyme) :** stockage 100% local + export/import manuel (JSON et QR code)
- **Avec compte (optionnel) :** sync cloud Firebase + partage par lien ou invitation
  - Connexion via **Google Sign-In** (Android) ou **Sign in with Apple** (iOS)
  - Migration automatique des données locales vers le cloud à la première connexion

---

## 11. Partage entre membres

- Un projet peut être **partagé** avec d'autres utilisateurs (via compte ou lien)
- **Droits configurables :** lecture seule ou édition
- Synchronisation en temps réel (si cloud activé)
- Invitation par lien ou email
- Utile pour partager les setlists entre membres du groupe

---

## 12. Interface & UX

### 12.1 Principes directeurs
- **Priorité UX** sur le design : l'application doit être utilisable à faible luminosité, avec les doigts mouillés, stressé sur scène
- Boutons larges avec zones de touch généreuses (minimum 48dp)
- Contrastes élevés en mode Live
- Feedback haptique sur les actions importantes (optionnel, configurable)
- Animations limitées et non-bloquantes

### 12.2 Navigation principale
- Barre de navigation basse : **Projets / Setlists / Chansons / Réglages**
- Accès rapide au mode Live depuis n'importe quel écran (bouton flottant persistant)
- Changement de mode (Création / Répétition / Live) accessible depuis l'header

### 12.3 Écran principal Live
```
┌─────────────────────────────────┐
│  ◀ Précédent    [NOM SETLIST]  Suivant ▶ │
├─────────────────────────────────┤
│                                 │
│       NOM DU MORCEAU            │  ← Grande police
│       NOM DU BLOC COURANT       │  ← Couleur accent
│                                 │
│         ⬤  140 BPM  ⬤          │  ← Cercle pulsant
│                                 │
│  ████████████░░░░░░░░░░░░░░░░   │  ← Barre mesure
│           Mesure 4/8            │
│                                 │
│  ▶ PLAY / STOP                 │  ← Grand bouton
└─────────────────────────────────┘
```

---

## 13. Performances & Contraintes techniques

| Contrainte | Exigence |
|---|---|
| Latence audio (clic) | < 20ms (objectif < 10ms) |
| Sync son/visuel | Écart < 10ms |
| Démarrage de l'app | < 3 secondes |
| Réponse UI | < 100ms sur toute action |
| Taille de l'appli | < 50MB (sans pack voix HD) |
| Support Android | API 26+ (Android 8.0) |
| Support iOS | iOS 13+ |
| Sans réseau | Toutes fonctions core disponibles offline |

---

## 14. Phases de développement (MVP)

### Phase 1 — MVP Core *(priorité absolue)*
- [ ] Métronome fonctionnel (BPM, signature, sons, visuel)
- [ ] Système de blocs simple
- [ ] Création de chansons avec blocs
- [ ] Setlists basiques
- [ ] 3 modes (Création / Répétition / Live)
- [ ] TTS natif avec annonce + décompte
- [ ] Sauvegarde locale

### Phase 2 — Enrichissement
- [ ] Bibliothèque de templates de blocs
- [ ] Projets / multi-groupes
- [ ] Partage entre membres (cloud)
- [ ] Pack voix HD téléchargeable
- [ ] Import/Export JSON

### Phase 3 — Finitions & Distribution
- [ ] Support pédalier Bluetooth
- [ ] Publication Play Store + App Store
- [ ] Logo & identité visuelle
- [ ] Documentation utilisateur
- [ ] Tests iOS

---

## 15. Points ouverts / À décider

| # | Sujet | Statut |
|---|---|---|
| 1 | Nom définitif de l'application | ⏳ À définir |
| 2 | Logo et charte graphique | ⏳ À définir |
| 3 | Couleur accent du thème | ✅ Décidé |
| 4 | Tap tempo (utile en répet ?) | ✅ Décidé |
| 5 | Feedback haptique sur le beat | ✅ Décidé |
| 6 | Compte utilisateur obligatoire pour le cloud | ✅ Décidé |

---

*Document rédigé le 25 mars 2026 — Sujet à révision.*
