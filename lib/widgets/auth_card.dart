import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'pass': '',
  };

  Future<void> _submit() async {
    final scaffold = Scaffold.of(context);

    if (_formKey.currentState.validate()) {
      Auth auth = Provider.of<Auth>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      _formKey.currentState.save();

      try {
        if (_authMode == AuthMode.Login) {
          //Login
          await auth.login(
            _authData['email'],
            _authData['pass'],
          );
        } else {
          //Cadastro
          await auth.signup(
            _authData['email'],
            _authData['pass'],
          );
        }
      } on AuthException catch (erro) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text(
              erro.toString(),
            ),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: _authMode == AuthMode.Login ? 290 : 371,
        width: size.width * .75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                onSaved: (value) => _authData['pass'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
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
                ),
              Spacer(),
              Visibility(
                visible: !_isLoading,
                child: RaisedButton(
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
                ),
                replacement: CircularProgressIndicator(),
              ),
              FlatButton(
                onPressed: _switchMode,
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  _authMode == AuthMode.Login ? 'Registar' : 'Entrar',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
