import 'package:consumo_api/homePage.dart';
import 'package:consumo_api/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoasVindas extends StatefulWidget {
  const BoasVindas({Key? key}) : super(key: key);

  @override
  State<BoasVindas> createState() => _BoasVindasState();
}

class _BoasVindasState extends State<BoasVindas> {
  @override
  void initState() {
    super.initState();
    verificarToken().then((value) => {
      if (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homePage(),
          ),
        )
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        )
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      /*body: Center(
        child: CircularProgressIndicator(),
      ),*/
    );
  }

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null){
      return false;
    }else{
      return true;
    }
  }
}
