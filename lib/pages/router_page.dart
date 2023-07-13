import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ten_2023/pages/admin_page.dart';
import 'angel_page.dart';
import 'guest_page.dart';

class RouterPage extends StatelessWidget {
  const RouterPage({super.key});

  Future getInfo() async {
    Map<String, dynamic>? dbData = {};
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      Map<String, dynamic>? t = value.data();
      t!['userID'] = FirebaseAuth.instance.currentUser!.uid;
      dbData = t;
    });
    return dbData;
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      body: FutureBuilder(
        future: getInfo(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final data = snapshot.data;
            if (data['u_type'] == 'angel') {
              return AngelPage(data);
            }
            if (data['u_type'] == 'guest') {
              return GuestPage(data);
            }
            return AdminPage();
          }
        }),
      ),
    );
  }
}
