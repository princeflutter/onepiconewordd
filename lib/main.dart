import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Wordpuzzle(),
  ));
}

class Wordpuzzle extends StatefulWidget {
  const Wordpuzzle({Key? key}) : super(key: key);

  @override
  State<Wordpuzzle> createState() => _WordpuzzleState();
}

class _WordpuzzleState extends State<Wordpuzzle> {
  String imagename = "";

  bool vv = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initImages();
  }

  List someImages = [];

  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('Images/'))
        .where((String key) => key.contains('.webp'))
        .toList();

    setState(() {
      someImages = imagePaths;

      int a = Random().nextInt(someImages.length);

      imagename = someImages[a];
      // imagename = "Images/dog.webp";
      vv = true;
      print("====${someImages}");
      print("====${imagename}");

      // List<String> ll = imagename.split("/"); //[Images, dog.webp]
      // print("=$ll");
      // String s1 = ll[1]; // dog.webp
      // print("=$s1");
      // List<String> l2 = s1.split("\."); // [dog, webp]
      // print("==$l2");
      // String s2 = l2[0]; //dog
      // print("===${s2}");
      //
      String s2 = imagename.split("/")[1].split("\.")[0];
      List<String> anslist = s2.split(""); // [d, o, g]
      print("==$anslist");
      String abcd = "abcdefghijklmnopqrstuvwxyz";
      List<String> absclist = abcd.split("");
      print("${absclist}");
      absclist.shuffle();
      List bottomlist = absclist.getRange(0, 10 - anslist.length).toList();
      print("==${bottomlist}");
      bottomlist.addAll(anslist);
      bottomlist.shuffle();
      print("$bottomlist");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vv
          ? Container(color: Colors.yellow, child: Image.asset(imagename))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
