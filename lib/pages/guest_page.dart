import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ten_2023/pages/add_idea_page.dart';
import 'package:ten_2023/pages/get_proj_info.dart';
import 'package:ten_2023/pages/view_idea_page.dart';
import 'auth_page.dart';

class GuestPage extends StatefulWidget {
  var data;
  static var userData;
  GuestPage(this.data, {super.key}) {
    userData = data;
  }

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  List<String> _allProjsID = [];
  List<String> test = [];

  Future resfresh() async {
    test = _allProjsID;
    _allProjsID.clear();
    setState(() {
      _allProjsID;
    });
    _allProjsID = test;
  }

  Future getProjectID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('projects')
        .get()
        .then(
          (value) => value.docs.forEach((element) async {
            _allProjsID.add(element.reference.id);
          }),
        );
    return _allProjsID;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return IdeaAddPage();
                        }));
                      },
                      child: const Text(
                        "Show your idea!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: resfresh,
                child: FutureBuilder(
                  future: getProjectID(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (_allProjsID.isEmpty) {
                        return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return const Center(
                              child: Text(
                                'Currently no active ideas...',
                              ),
                            );
                          },
                        );
                      }
                      return ListView.builder(
                        itemCount: _allProjsID.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: GetProjTitle(docID: _allProjsID[index]),
                                subtitle:
                                    GetProjType(docID: _allProjsID[index]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) {
                                        return ViewIdeiaPage(
                                            userID: widget.data['userID'],
                                            docID: _allProjsID[index]);
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
                    }
                    return Text('');
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
