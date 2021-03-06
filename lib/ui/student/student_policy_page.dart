//import 'dart:io' as Io;
//import 'dart:io';
//
//import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:toast/toast.dart';
//
//class StudentPolicy extends StatefulWidget {
//  @override
//  _StudentPolicyState createState() => _StudentPolicyState();
//}
//
//class _StudentPolicyState extends State<StudentPolicy> {
//  //PDFDocument pdfDocument;
//  bool downloading = false;
//  var progressString = "";
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Student Policy'),
//      ),
//      body: Column(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text(
//              'Click to Download PDF',
//              style: TextStyle(fontSize: 20),
//            ),
//          ),
//          Expanded(
//            child: Center(
//              child: downloading
//                  ? Container(
//                      height: 120.0,
//                      width: 200.0,
//                      child: Card(
//                        elevation: 10,
//                        color: Colors.black,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            CircularProgressIndicator(),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Text(
//                              "Downloading File: $progressString",
//                              style: TextStyle(
//                                color: Colors.white,
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    )
//                  : Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: MaterialButton(
//                            height: 50,
//                            color: Colors.teal,
//                            onPressed: () async {
//                              var dio = new Dio();
//                              dio.interceptors.add(LogInterceptor());
//                              Directory dir =
//                                  await getExternalStorageDirectory();
//                              var testDir = await new Io.Directory(
//                                      '${dir.path}/homestayStudent')
//                                  .create(recursive: true);
//                              var url =
//                                  "https://firebasestorage.googleapis.com/v0/b/homestay-app.appspot.com/o/homestayDocs%2FStudent%20homestay%20handbook-2019.pdf?alt=media&token=f96547b0-0d85-4bb0-b7d0-0d751e3dd972";
//                              await download1(dio, url,
//                                  '${testDir.path}/studentHandbook.pdf');
//                            },
//                            child: Text(
//                              'STUDENT HOMESTAY HANDBOOK',
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: MaterialButton(
//                            height: 50,
//                            onPressed: () {
//                              Toast.show("Document not available.", context,
//                                  duration: Toast.LENGTH_LONG,
//                                  gravity: Toast.BOTTOM);
//                            },
//                            color: Colors.teal,
//                            child: Text(
//                              'HOMESTAY RULES',
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: MaterialButton(
//                            height: 50,
//                            onPressed: () {
//                              Toast.show("Document not available.", context,
//                                  duration: Toast.LENGTH_LONG,
//                                  gravity: Toast.BOTTOM);
//                            },
//                            color: Colors.teal,
//                            child: Text(
//                              'HOMESTAY AGREEMENT',
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Future download1(Dio dio, String url, savePath) async {
//    try {
//      await dio.download(
//        url,
//        savePath,
//        onReceiveProgress: showDownloadProgress,
//      );
//    } catch (e) {
//      print(e);
//    }
//    setState(() {
//      downloading = false;
//      progressString = "Completed";
//      Toast.show("File downloaded successfuly please check your files", context,
//          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//    });
//  }
//
//  void showDownloadProgress(received, total) {
//    print("Rec: $received , Total: $total");
//
//    setState(() {
//      downloading = true;
//      progressString = ((received / total) * 100).toStringAsFixed(0) + "%";
//    });
//  }
//}

import 'dart:io';
import 'dart:io' as Io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class StudentPolicy extends StatefulWidget {
  @override
  _StudentPolicyState createState() => _StudentPolicyState();
}

class _StudentPolicyState extends State<StudentPolicy> {
  bool downloading = false;
  var progressString = "";
  final CollectionReference collectionReference =
      Firestore.instance.collection('homestayDocs');

  @override
  Widget build(BuildContext context) {
    var fUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Policy',
          style: TextStyle(fontSize: 17),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/studenthomepage', ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
        child: Center(
      child: downloading
          ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                elevation: 10,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Downloading File: $progressString",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Click to download',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                _getListViewWidget(),
              ],
            ),
    ));
  }

  Widget _getListViewWidget() {
    var fUser = Provider.of<FirebaseUser>(context);
    return Flexible(
      child: RefreshIndicator(
          child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference
                .where('userType', isEqualTo: 'student')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return new Text('${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data.documents[index];
                      // final itemID = snapshot.data.documents[index].documentID;
//                final list = snapshot.data.documents;
                      return Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      var dio = new Dio();
                                      dio.interceptors.add(LogInterceptor());
                                      Directory dir =
                                          await getExternalStorageDirectory();
                                      var testDir = await new Io.Directory(
                                              '${dir.path}/homestayParent')
                                          .create(recursive: true);
                                      var url = item['docUrl'];
                                      await download1(dio, url,
                                          '${testDir.path}/${item['documentName']}.pdf');
                                    },
                                    color: Colors.teal,
                                    child: Text(
                                      item['documentName'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
              }
            },
          ),
          onRefresh: refresh),
    );
  }

  Future<Null> refresh() {
    return new Future<Null>.value();
  }

  Future download1(Dio dio, String url, savePath) async {
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: showDownloadProgress,
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
      Toast.show("File downloaded successfuly please check your files", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  void showDownloadProgress(received, total) {
    print("Rec: $received , Total: $total");

    setState(() {
      downloading = true;
      progressString = ((received / total) * 100).toStringAsFixed(0) + "%";
    });
  }
}
