import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rezervacija_restorana/ui/dashboard.dart';

class UserRepository {
  final _databaseReference = FirebaseFirestore.instance;

  void loginByServerId(
      int serverId, String password, BuildContext context) async {
    await getServerEmailById(serverId)
        .then((value) => loginUser(value, password, context));
  }

  void loginUser(email, password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getServerEmailById(int serverId) async {
    String response = '';
    try {
      await _databaseReference
          .collection('users')
          .doc(serverId.toString())
          .get()
          .then((value) => response = value.get('email'));
    } catch (e) {
      debugPrint(e.toString());
    }
    return response;
  }

  Future<void> createServer(
      email, password, username, serverId, context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addUserToDB(email, username, serverId, context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addUserToDB(email, username, serverId, context) async {
    await _databaseReference.collection('users').doc(serverId).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'username': username,
      'email': email,
      'serverId': serverId
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }
}
