import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

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

  FlutterTts flutterTts = FlutterTts();

  final player = AudioPlayer(); // Create a player

  Map map = {};
  bool vv = false;
  List<String> anslist = [];
  List<String> bottomlist = [];
  List<String> toplist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initImages();
  }

  List someImages = [];

  Future _initImages() async {
    await player.setAsset("Musicdir/move.wav");
    await player.load();
    // await player.setLoopMode(LoopMode.one);

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
      s2 = imagename.split("/")[1].split("\.")[0];
      anslist = s2.split(""); // [d, o, g]
      toplist = List.filled(anslist.length, "");
      print("==$anslist");
      String abcd = "abcdefghijklmnopqrstuvwxyz";
      List<String> absclist = abcd.split("");
      print("${absclist}");
      absclist.shuffle();
      bottomlist = absclist.getRange(0, 10 - anslist.length).toList();
      print("==${bottomlist}");
      bottomlist.addAll(anslist);
      bottomlist.shuffle();
      print("$bottomlist");
    });
  }

  String s2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vv
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color: Colors.yellow, child: Image.asset(imagename)),
                Container(
                  height: 100,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: anslist.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          await player.load();
                          await player.play();

                          setState(() {
                            if (toplist[index].isNotEmpty) {
                              bottomlist[map[index]] = toplist[index];

                              toplist[index] = "";
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.yellow,
                          alignment: Alignment.center,
                          child: Text(
                            "${toplist[index]}".toUpperCase(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 12,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      if (index == 10) {
                        return Center(
                          child: IconButton(
                              onPressed: () async {
                                // await flutterTts.setSpeechRate(0.1);
                                await flutterTts.speak(s2);
                              },
                              icon: Icon(
                                Icons.lightbulb,
                                color: Colors.red,
                              )),
                        );
                      } else if (index == 11) {
                        return Center(
                          child: IconButton(
                              onPressed: () async {
                                // await flutterTts.setSpeechRate(0.1);
                                for (int i = 0; i < anslist.length; i++) {
                                  await flutterTts.setSpeechRate(0.5);
                                  await Future.delayed(Duration(seconds: 3));
                                  await flutterTts.speak(anslist[i]);
                                }
                              },
                              icon: Icon(
                                Icons.lightbulb,
                                color: Colors.blue,
                              )),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (bottomlist[index].isNotEmpty) {
                                for (int a = 0; a < anslist.length; a++) {
                                  if (toplist[a] == "") {
                                    toplist[a] = bottomlist[index];
                                    bottomlist[index] = "";
                                    // from = where
                                    map[a] = index;
                                    print("==${map}");
                                    // {0:2,1:9,2:5}
                                    break;
                                  }
                                }

                                if (listEquals(anslist, toplist)) {
                                  setState(() {
                                    cc = Colors.green;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("YOU Are Won")));
                                } else if (!toplist.contains("")) {
                                  setState(() {
                                    cc = Colors.red;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Try More")));
                                }
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            color: cc,
                            alignment: Alignment.center,
                            child: Text(
                              "${bottomlist[index]}".toUpperCase(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Color cc = Colors.yellow;
}
