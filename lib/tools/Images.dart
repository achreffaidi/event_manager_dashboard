import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';


class Images {
  File originalFile;

  Images(this.originalFile);


  Future<File> CompressAndGetFileWithoutRotation() async {

    print("start compression file");
    var result = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path, originalFile.absolute.path + "_compressed",
        quality: 50, minHeight: 600);

    print(originalFile.lengthSync());
    print(result.lengthSync());

    return result;
  }






  Future<int> uploadImage(url) async {
    var uri = Uri.parse(url);
    print(url);
    var request = new http.MultipartRequest("POST", uri);

    request.files.add(new http.MultipartFile.fromBytes(
        "file", originalFile.readAsBytesSync(),
        filename: DateTime.now().toIso8601String()));

    var response = await request.send();

    print(response.headers);
    return response.statusCode;

  }
  Future<void> uploadImageWithHeaders(url , headers) async {
    var uri = Uri.parse(url);
    print(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.files.add(new http.MultipartFile.fromBytes(
        "file", originalFile.readAsBytesSync(),
        filename: DateTime.now().toIso8601String()));

    var response = await request.send();

    print(response.headers);


  }
}
