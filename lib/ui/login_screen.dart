import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/repository/user_repository.dart';
import 'package:rezervacija_restorana/ui/register_screen.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        padding: const EdgeInsets.only(top: 24, left: 40, right: 40),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              controller: emailController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "email / ID konobara",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: "Šifra",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                if (double.tryParse(emailController.text) != null) {
                  UserRepository().loginByServerId(
                      int.parse(emailController.text),
                      passwordController.text,
                      context);
                } else {
                  UserRepository().loginUser(
                      emailController.text, passwordController.text, context);
                }
              },
              child: const Text("Uloguj se"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: const Text("Kreirajte novi nalog",
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}
