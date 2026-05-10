import 'package:flutter/material.dart';

import '../screens/premium/premium_screen.dart';
import '../services/premium_service.dart';

class PremiumGuard {
  static void check(
    BuildContext context,
    VoidCallback onAllowed,
  ) {
    if (PremiumService().premiumAtivo) {
      onAllowed();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PremiumScreen(),
        ),
      );
    }
  }
}