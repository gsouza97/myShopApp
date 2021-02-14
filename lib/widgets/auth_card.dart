import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exceptions.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  GlobalKey<FormState> _form = GlobalKey();
  final _passwordController = TextEditingController();
  final Map<String, String> _authForm = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Ocorreu um erro!',
          style: TextStyle(
            color: Theme.of(context).errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authForm['email'],
          _authForm['password'],
        );
      } else {
        await auth.singup(
          _authForm['email'],
          _authForm['password'],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Aconteceu um erro inesperado.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        padding: EdgeInsets.all(16),
        width: mediaQuery.width * 0.75,
        height: _authMode == AuthMode.Login ? 315 : 375,
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Ex: usuario@gmail.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.trim().isEmpty || !value.contains('@')) {
                    return 'Informe um email válido';
                  }
                  return null;
                },
                onSaved: (value) => _authForm['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Senha',
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.trim().isEmpty || value.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
                onSaved: (value) => _authForm['password'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    hintText: 'Senha',
                  ),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Senha não confere';
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text(
                        _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      onPressed: _submit,
                    ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _authMode == AuthMode.Login
                      ? 'ALTERNAR PARA REGISTRAR'
                      : 'ALTERNAR PARA ENTRAR',
                ),
                textColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
