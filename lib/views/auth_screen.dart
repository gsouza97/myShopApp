import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfff5f0e1),
                  Color(0xff1e3d59),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 70),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.85),
                            blurRadius: 8,
                            offset: Offset(2, 4),
                          )
                        ],
                      ),
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 45,
                          fontFamily: 'Anton',
                        ),
                      ),
                    ),
                    AuthCard(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
