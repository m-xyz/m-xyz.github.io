import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GetProjTitle extends StatelessWidget {
  final String docID;
  final String userID;
  const GetProjTitle({required this.docID, required this.userID});

  @override
  Widget build(BuildContext context) {
    var projs = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('projects');

    return FutureBuilder<DocumentSnapshot>(
      future: projs.doc(docID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data['title'],
          );
        }
        return const Text('Loading...');
      }),
    );
  }
}

class GetProjType extends StatelessWidget {
  final String docID;
  const GetProjType({required this.docID});

  @override
  Widget build(BuildContext context) {
    var projs = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('projects');

    return FutureBuilder<DocumentSnapshot>(
      future: projs.doc(docID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data['type'],
          );
        }
        return const Text('Loading...');
      }),
    );
  }
}
