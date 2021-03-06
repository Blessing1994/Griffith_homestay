import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homestay/ui/accommodation/cottage_details_page.dart';
import 'package:homestay/utils/routes.dart';
import 'package:provider/provider.dart';

class AccommodationList extends StatefulWidget {
  @override
  _AccommodationListState createState() => _AccommodationListState();
}

class _AccommodationListState extends State<AccommodationList> {
  final CollectionReference collectionReference =
      Firestore.instance.collection('listings');

  @override
  Widget build(BuildContext context) {
    var fUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Accommodation',
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
      child: Column(
        children: <Widget>[
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _getListViewWidget() {
    return Flexible(
      child: RefreshIndicator(
          child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.snapshots(),
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
                      return Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            elevation: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(new FadePageRoute(
                                      builder: (c) {
                                        return CottageDetails(
                                            cottage:
                                                snapshot.data.documents[index]);
                                      },
                                      settings: new RouteSettings(),
                                    ));
                                  },
                                  leading: Hero(
                                    tag: index,
                                    child: CircleAvatar(
                                      child: Text(
                                        item['cottageColorName'][0],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Muli',
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item['cottageColorName'] + ' Cottage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Click and view the cottage details',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                  trailing: Icon(
                                    Icons.home,
                                    color: Colors.teal.withOpacity(0.8),
                                  ),
                                  isThreeLine: true,
                                  dense: false,
                                ),
//                                FlutterRatingBar(
//                                  initialRating: 5,
//                                  itemSize: 20,
//                                  fillColor: Colors.amber,
//                                  borderColor: Colors.amber.withAlpha(70),
//                                  allowHalfRating: true,
//                                  onRatingUpdate: (rating) {
//                                    print(rating);
//                                  },
//                                ),
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
}
