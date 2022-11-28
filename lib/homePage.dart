import 'package:consumo_api/boasvindasPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Home Page',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () async {
              bool saiu = await sair();
              if(saiu){
                Navigator.pushReplacement(context,
                  MaterialPageRoute(
                      builder: (context) => BoasVindas(),
                  ),
                );
              }
            },
            child: Text('Sair'),
          ),
        ],
      )
    );
  }

  Future<bool> sair() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }

}
