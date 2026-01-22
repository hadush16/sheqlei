// Track subscribed company IDs in a Set for fast lookup
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companySubscriptionsProvider = StateProvider<Set<String>>((ref) => {});
