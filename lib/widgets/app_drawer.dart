import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('My Shop App'),
            automaticallyImplyLeading: false,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1e3d59),
                  Color(0xfff5f0e1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/default-user-image.png',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bem-vindo Usuário!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.PRODUCTS_MANAGEMENT);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
