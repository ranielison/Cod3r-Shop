import 'package:flutter/material.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _senhaController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'pass': '',
  };

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 320,
        width: size.width * .75,
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Senha inválida';
                  }
                  return null;
                },
                onSaved: (value) => _authData['senha'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Confirmação',
                  ),
                  obscureText: true,
                  validator: _authMode == AuthMode.Login
                      ? null
                      : (value) {
                          if (value != _senhaController.text) {
                            return 'Senhas diferentes';
                          }
                          return null;
                        },
                  onSaved: (value) => _authData['senha'] = value,
                ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 30,
                ),
                child: Text(
                  _authMode == AuthMode.Login ? 'Entrar' : 'Registar',
                ),
                onPressed: _submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
