import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/repository/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController rePasswordController = TextEditingController();
    TextEditingController serverIdController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Registracija")),
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
                  hintText: "Email",
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
            TextFormField(
              obscureText: true,
              controller: rePasswordController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: "Ponoviti Šifru",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            TextFormField(
              obscureText: false,
              controller: serverIdController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: "Nova šifra konobara",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text == rePasswordController.text) {
                  UserRepository userRepo = UserRepository();
                  userRepo.createServer(
                      emailController.text,
                      passwordController.text,
                      usernameController.text,
                      serverIdController.text,
                      context);
                }
              },
              child: const Text("Registruj se"),
            ),
          ],
        ),
      ),
    );
  }
}
