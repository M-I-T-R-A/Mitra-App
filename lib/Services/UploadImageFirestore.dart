import 'dart:io';    
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;  

Future uploadFile(File _image, String path) async {  
   String _uploadedFileURL;
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('$path/${Path.basename(_image.path)}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   storageReference.getDownloadURL().then((fileURL) {    
       _uploadedFileURL = fileURL;        
   });    
   return _uploadedFileURL;
 } 