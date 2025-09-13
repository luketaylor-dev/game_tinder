import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing counter state
/// This is a simple example of how to organize providers in separate files
final counterProvider = StateProvider<int>((ref) => 0);
