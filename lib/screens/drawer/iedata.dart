import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/topic.dart';
import '../../drawer/drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

/* ----- ENCRYPT/DECRYPT FUNCTIONS ----- */
final String keyString = 'pEjJZzdd8CQ52qw1c0GGosvGO59y63A8'; // 32 bytes
final String ivString = 'iWkElzov2w1CxM76'; // 16 bytes
final encrypt.Key key = encrypt.Key.fromUtf8(keyString);
final encrypt.IV iv = encrypt.IV.fromUtf8(ivString);

String encryptContent(String content) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encryptedContent = encrypter.encrypt(content, iv: iv);
  return encryptedContent.base64;
}

String decryptContent(String encryptedContent) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final decryptedContent = encrypter.decrypt64(encryptedContent, iv: iv);
  return decryptedContent;
}

/* ----- EXPORT FUNCTIONS ----- */
String convertTopicsToJson(List<Topic> topics, String userId) {
  List<Map<String, dynamic>> topicsList =
      topics.map((topic) => topic.toJson()).toList();
  Map<String, dynamic> data = {
    "userId": userId,
    "topics": topicsList,
  };
  return jsonEncode(data);
}

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

Future<Directory> getDownloadsDirectory() async {
  if (Platform.isAndroid) {
    final String downloadsPath = '/storage/emulated/0/Download';
    final Directory downloadsDirectory = Directory(downloadsPath);
    return downloadsDirectory;
  } else if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

Future<void> saveFile(
    String fileName, String content, BuildContext context) async {
  try {
    await requestStoragePermission();
    Directory downloadsDirectory = await getDownloadsDirectory();
    String filePath = '${downloadsDirectory.path}/$fileName';
    File file = File(filePath);
    if (await file.exists()) {
      print('Archivo existente, eliminando...');
      await file.delete();
      // Crear un nuevo archivo después de eliminar el existente
      file = File(filePath);
      print('Archivo eliminado, creando uno nuevo...');
    }
    await file.writeAsString(content);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data exported successfully to ${filePath}'),
      backgroundColor: Color.fromARGB(255, 22, 109, 25),
    ));
  } catch (e) {
    print("Error al guardar el archivo: $e");
  }
}

Future<void> exportTopics(String fileName, BuildContext context) async {
  User user = FirebaseAuth.instance.currentUser;
  var myTopicsStorage = TopicsStorage(user.uid);
  List<Topic> topics = await myTopicsStorage.loadTopics();
  if (topics != null) {
    String content = convertTopicsToJson(topics, user.uid);
    String encryptedContent = encryptContent(content);
    await saveFile(fileName, encryptedContent, context);
  } else {
    print("No hay topics para exportar");
  }
}

/* ----- IMPORT FUNCTIONS ----- */

Future<File> pickImportFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result != null) {
    return File(result.files.single.path);
  } else {
    print("Operación cancelada por el usuario");
    return null;
  }
}

Future<String> readFileContent(File file) async {
  try {
    String content = await file.readAsString();
    return content;
  } catch (e) {
    print("Error al leer el archivo: $e");
    return null;
  }
}

List<Topic> parseTopicsFromJson(String jsonString) {
  Map<String, dynamic> data = jsonDecode(jsonString);
  List<dynamic> topicsJsonList = data['topics'];
  String userId = data['userId'];
  if (userId != FirebaseAuth.instance.currentUser.uid) {
    print("nope");
    return null;
  }
  List<Topic> topics =
      topicsJsonList.map((topicJson) => Topic.fromJson(topicJson)).toList();

  return topics;
}

Future<void> saveImportedTopics(List<Topic> topics) async {
  User user = FirebaseAuth.instance.currentUser;
  var myTopicsStorage = TopicsStorage(user.uid);
  for (var topic in topics) {
    myTopicsStorage.saveTopic(topic);
  }
}

Future<void> importTopics(BuildContext context) async {
  File importFile = await pickImportFile();
  if (importFile != null) {
    String content = await readFileContent(importFile);
    print('Read content: $content');
    if (content != null) {
      String decryptedContent = decryptContent(content);
      List<Topic> importedTopics = parseTopicsFromJson(decryptedContent);
      if (importedTopics != null) {
        await saveImportedTopics(importedTopics);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data imported successfully'),
          backgroundColor: Color.fromARGB(255, 22, 109, 25),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: You tried to import data from another user'),
          backgroundColor: Color.fromARGB(255, 125, 29, 22),
        ));
      }
    }
  }
}

class ImportExportScreen extends StatelessWidget {
  static const routeName = '/import-export-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import/Export Data'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(7, 110, 219, 1),
                  Color.fromRGBO(6, 70, 138, 1),
                  Color.fromRGBO(5, 41, 79, 1),
                ],
                stops: [0.0, 0.5, 0.99],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose an option',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  height: 80.h, // altura de la línea
                  thickness: 6.w, // grosor de la línea
                  color: Color.fromARGB(255, 3, 35, 94), // color de la línea
                  indent: 20
                      .w, // espacio a la izquierda (puedes omitir si no necesitas)
                  endIndent: 20
                      .w, // espacio a la derecha (puedes omitir si no necesitas)
                ),
                ElevatedButton(
                  onPressed: () async {
                    User user = FirebaseAuth.instance.currentUser;
                    final databaseReference = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(user.uid);

                    DatabaseEvent snapshot =
                        await databaseReference.child('num_exports').once();
                    int numExports = snapshot.snapshot.value;

                    await exportTopics(
                        'magic-mirror-${user.email}-topics${numExports}.json',
                        context);

                    numExports = numExports + 1;
                    databaseReference
                        .update({'num_exports': numExports}).then((value) {
                      print('Campo actualizado correctamente');
                    }).catchError((error) {
                      print('Error al actualizar el campo: $error');
                    });
                  },
                  child: Text(
                    'Export Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 35, 94),
                    padding:
                        EdgeInsets.symmetric(horizontal: 64.0, vertical: 12.0)
                            .r,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0).w,
                    ),
                  ),
                ),
                Divider(
                  height: 80.h,
                  thickness: 6.w,
                  color: Color.fromARGB(255, 3, 35, 94),
                  indent: 20.w,
                  endIndent: 20.w,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await importTopics(context);
                  },
                  child: Text(
                    'Import Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 35, 94),
                    padding:
                        EdgeInsets.symmetric(horizontal: 64.0, vertical: 12.0)
                            .r,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0).w,
                    ),
                  ),
                ),
                Divider(
                  height: 80.h,
                  thickness: 6.w,
                  color: Color.fromARGB(255, 3, 35, 94),
                  indent: 20.w,
                  endIndent: 20.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0).r,
                  child: Text(
                    'Note: You will only be able to import information which comes from an account with the same email address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
