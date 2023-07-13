// pagina onde o guest adiciona a proposta com:
// - depositório de imagem /video
// - titulo
// - descrição da proposta
// - categoria da proposta

// paulo / joão
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdeaAddPage extends StatefulWidget {
  const IdeaAddPage({super.key});
  @override
  State<IdeaAddPage> createState() => _IdeaAddPageState();
}

const List<String> dropdownlist = <String>[
  "Investment",
  "Expert Guidance",
  "Consultancy Management",
];

class _IdeaAddPageState extends State<IdeaAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var dropdownvalue = dropdownlist.first;

  final List<TextEditingController> _controllers =
      List.generate(2, (i) => TextEditingController());
  var listaTexto = [
    "Titulo",
    "Descrição da Proposta",
  ];
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  var _image;
  var title;
  var description;
  var type = dropdownlist[0];

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
    _image = pickedFile!.name;
  }

  Future uploadFile() async {
    List<String> _allProjsID = [];
    title = _controllers[0];
    description = _controllers[1];
    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

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

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final String urlDownload = await snapshot.ref.getDownloadURL();
    debugPrint(urlDownload);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('projects')
        .doc(
            '${FirebaseAuth.instance.currentUser!.uid}${_allProjsID.length + 1}')
        .set({
      'img_path': urlDownload,
      'title': title.text,
      'desc': description.text,
      'type': type,
    });
    setState(() {
      uploadTask = null;
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 20,
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.black,
                  ),
                  Center(
                    child: Text(
                      "${(100 * progress).roundToDouble()}%",
                      style: const TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Add idea',
          style: GoogleFonts.bebasNeue(fontSize: 36),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(30)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              if (pickedFile != null)
                SafeArea(
                  child: Center(
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: selectFile,
                      child: const Text(
                        "Select file",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: _controllers[0],
                          decoration: InputDecoration(
                            labelText: 'Title',
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            suffix: IconButton(
                              onPressed: () {
                                _controllers[0].clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Title";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _controllers[1],
                          decoration: InputDecoration(
                            labelText: 'Description',
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            suffix: IconButton(
                              onPressed: () {
                                _controllers[1].clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Descritpion";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    Align(
                      alignment: const Alignment(
                        -1,
                        1,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: dropdownvalue,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.expand_more,
                            color: Colors.blue,
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String? change) {
                            setState(() {
                              dropdownvalue = change!;
                              type = change;
                            });
                          },
                          items: dropdownlist
                              .map<DropdownMenuItem<String>>((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pickedFile == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              onPressed:
                                  pickedFile == null ? () {} : uploadFile,
                              child: const Text(
                                "Submit Idea",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        buildProgress(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
