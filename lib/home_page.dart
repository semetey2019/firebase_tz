import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _firstName = '';
  String _lastName = '';
  String _middleName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String uid = _auth.currentUser?.uid ?? '';
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _firstName = userData['firstName'] ?? '';
        _lastName = userData['lastName'] ?? '';
        _middleName = userData['middleName'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    String uid = _auth.currentUser?.uid ?? '';
    await _firestore.collection('users').doc(uid).set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'middleName': _middleNameController.text,
    });
    _loadUserData();
    _firstNameController.clear();
    _lastNameController.clear();
    _middleNameController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование профиля'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  labelText: _firstName == '' ? 'Имя' : _firstName),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  labelText: _lastName == '' ? 'Фамилия' : _lastName),
            ),
            TextField(
              controller: _middleNameController,
              decoration: InputDecoration(
                  labelText: _middleName == '' ? 'Отчество' : _middleName),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
