import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/models/project.dart';

// Stocke en mémoire le projet sélectionné actuellement pour toute la session
final currentProjectProvider = StateProvider<Project?>((ref) => null);
