import 'dart:convert';

import 'package:consumo_api/homePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formkey,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: 'e-mail'
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, digite seu e-mail';
                        } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text)) {
                          return 'Por favor, digite um e-mail correto';
                        }
                        return null;
                      }
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'senha'
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Por favor, digite sua senha';
                      } else if (senha.length < 6) {
                        return 'Por favor, digite um senha com mais de 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formkey.currentState!.validate()) {
                      bool acessoOk = await login();
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus(); // Fechar o teclado
                      }
                      if (acessoOk) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                            builder: (context) => homePage(),
                            ),
                        );
                      }else{
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                    child: Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),

        )
    );
  }

  final snackBar = SnackBar(
    content: Text(
      'e-mail ou senha inválidos',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse("http://192.168.0.57:8080/login");
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    var corpo = json.encode(
        {
          'email': _emailController.text,
          'password': _passwordController.text
        }
    );
    //print("corpo ${corpo}");
    //print("corpo ${url}" );
    var reposta = await http.post(
        url,
        body: corpo
    );
    if (reposta.statusCode == 200) {
      sharedPreferences.setString('token', "Token ${jsonDecode(reposta.body)['token']}");
      //print('token ' + jsonDecode(reposta.body)['token']);
      return true;
    } else {
      //print(jsonDecode(reposta.body));
      return false;
    }
  }

}
