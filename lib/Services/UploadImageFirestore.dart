import 'dart:io';    
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;  
import 'package:cloud_firestore/cloud_firestore.dart';

Future uploadFile(File _image, String path) async {  
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('$path/${Path.basename(_image.path)}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   String _uploadedFileURL = (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();
  //  Firestore.instance
  //     .collection('data')
  //     .document()
  //     .updateData({"url": _uploadedFileURL});
  return _uploadedFileURL;
 } 