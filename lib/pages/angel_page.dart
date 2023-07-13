import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ten_2023/pages/view_idea_page.dart';
import 'auth_page.dart';

class AngelPage extends StatefulWidget {
  var data;
  AngelPage(this.data, {super.key});

  @override
  State<AngelPage> createState() => _AngelPageState();
}

class _AngelPageState extends State<AngelPage> {
  List<List<String>> _allUserID = [];
  List<Map<String, dynamic>> _allProjs = [];
  Map<String, List<Map<String, dynamic>>> allContens = {};

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future getAllProjs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.forEach((element) async {
              if (element.data()['u_type'] == 'guest') {
                String currID = element.reference.id;
                String currUsername = element.data()['username'];
                _allUserID.add([currID, currUsername]);
              }
            }));

    for (int i = 0; i < _allUserID.length; i++) {
      String id = _allUserID[i][0];
      String username = _allUserID[i][1];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('projects')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            Map<String, dynamic> t = element.data();
            t['username'] = username;
            t['userID'] = id;
            t['projID'] = element.reference.id;
            _allProjs.add(t);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Welcome ${widget.data['username']}',
          style: GoogleFonts.bebasNeue(fontSize: 36),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                onPressed: () {
                  signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return const AuthPage();
                      }),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Browse the projects of entrepreneurs below!',
              style: GoogleFonts.bebasNeue(fontSize: 20),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2.5,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: FutureBuilder(
                future: getAllProjs(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      _allProjs.isEmpty) {
                    return const Text(
                        'There are currently no business ideas...');
                  }
                  return ListView.builder(
                    itemCount: _allProjs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                  'lib/images/light_bulb_icon_64.png'),
                            ),
                            title: Text(_allProjs[index]['title']),
                            subtitle: Text(_allProjs[index]['type']),
                            trailing: Text(
                                'Project by:\n${_allProjs[index]['username']}'), // Limit number of username characters in register page
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return ViewIdeiaPage(
                                        userID: _allProjs[index]['userID'],
                                        docID: _allProjs[index]['projID']);
                                  }),
                                ),
                              );
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                            indent: 15,
                            endIndent: 15,
                          )
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
