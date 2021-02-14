import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../views/auth_screen.dart';
import '../views/products_overview_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: true);
    return auth.isAuthenticated ? ProductOverviewScreen() : AuthScreen();
  }
}
