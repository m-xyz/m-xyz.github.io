// visualização da proposta
//com:
//
// imagem / Video
// titulo
// descrição
// comentário se possivel
// Rocha / telmo
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ten_2023/pages/guest_page.dart';

class ViewIdeiaPage extends StatefulWidget {
  String docID;
  String userID;
  ViewIdeiaPage({required this.userID, required this.docID, super.key});

  @override
  _ViewIdeiaPageState createState() => _ViewIdeiaPageState();
}

class _ViewIdeiaPageState extends State<ViewIdeiaPage> {
  List<String> comments = [
    "Muito bom",
    "Parabens",
    "Projeto interessante",
  ];
  List<String> users = [
    "BusinessAngel",
    "Invester",
    "Manager",
  ];
  TextEditingController? textController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _image;
  String? _title;
  String? _description;
  String? _type;

  Future getProjectID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .collection('projects')
        .doc(widget.docID)
        .get()
        .then((value) {
      _image = value.data()!['img_path'];
      _title = value.data()!['title'];
      _description = value.data()!['desc'];
      _type = value.data()!['type'];
    });
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        users;
        comments;
      });
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProjectID(),
      builder: ((context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              '${_title}',
              style: GoogleFonts.bebasNeue(fontSize: 36),
            ),
            actions: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 78, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return const CircularProgressIndicator();
                          },
                          imageUrl: '$_image',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Text(
                      '$_title',
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
                    child: Text('$_description',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Work Sans',
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
                    child: Text('$_type',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Work Sans',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  6, 0, 0, 0),
                              child: Image.asset(
                                'lib/images/2366460-200.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(),
                                  child: TextFormField(
                                    controller: textController,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Add  a comment..',
                                      // Set border for enabled state (default)
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Work Sans',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(90, 40)),
                                onPressed: () {
                                  textController?.text;
                                  comments.insert(0, textController!.text);
                                  users.insert(
                                      0, GuestPage.userData['username']);
                                },
                                child: const Text('Send'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.asset(
                            'lib/images/2366460-200.png',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(users[index]),
                          subtitle: Text(comments[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
