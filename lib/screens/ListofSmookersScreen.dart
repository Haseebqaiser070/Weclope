// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wecloppeapp/screens/otherProfile.dart';
import 'package:wecloppeapp/style/toast.dart';

class SmookersListScreen extends StatefulWidget {
  QueryDocumentSnapshot ds;
  // LatLng myLocation;
  List<dynamic> friendList;
  var lang;
  SmookersListScreen(this.ds, this.friendList, this.lang);

  @override
  State<SmookersListScreen> createState() => _SmookersListScreenState();
}

class _SmookersListScreenState extends State<SmookersListScreen> {
  // List<dynamic> friendList = [];
  var myProfile, myUsername, occupation, breakTime, myBio;
  double? distanceA;
  bool isAdded = false;
  double calculateDistance(
      double lat1, double lon1, double lat2, double lon2, int counter) {
    // double d1 = 2.0;
    // setState(() {
    const double earthRadius = 6371; // in kilometers

    final latDistance = _toRadians(lat2 - lat1);
    final lonDistance = _toRadians(lon2 - lon1);
    final a = pow(sin(latDistance / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(lonDistance / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;
    // d1 = distance;
    print('distance km $counter');
    print(distance);
    // });
    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  List<dynamic> reqList = [];
  @override
  void initState() {
    // print('widget.friendList');
    reqList.addAll(widget.ds['requests']);
    print('reqList');
    print(reqList ?? 'null');
    print("widget.ds['uid']");
    print(widget.ds['uid']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/ornament_background.png'),
          fit: BoxFit.fill,
        )),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            child: Icon(Icons.arrow_back),
                            // Within the `FirstRoute` widget
                            onTap: () {
                              Navigator.pop(context);
                            }),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              widget.lang == 'en'
                                  ? 'List Of Smokers Nearby'
                                  : 'Liste des utilisateurs à proximité',
                              //Liste des utilisateurs à proximité
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff212121),
                                // height: 22.h
                              ),
                            )),
                      ],
                    ),
                    GestureDetector(
                        child: Image.asset('assets/images/smooker_map.png'),
                        // Within the `FirstRoute` widget
                        onTap: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo1')
                      // .where('uid',
                      //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    return !dataSnapShot.hasData
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.lang == 'en'
                                      ? 'No Users yet'
                                      : 'Aucun utilisateur pour le moment',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                    // height: 22.h
                                  ),
                                ),
                              ],
                            ), //No data Found
                          )
                        : StaggeredGridView.countBuilder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(), // new
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) =>
                                const StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  dataSnapShot.data!.docs[index];
                              // ds.get('lat');
                              // const double earthRadius = 6371; // in kilometers
                              //
                              // final latDistance = _toRadians(
                              //     ds.get('lat') - widget.myLocation.latitude);
                              // final lonDistance = _toRadians(
                              //     ds.get('lng') - widget.myLocation.longitude);
                              // final a = pow(sin(latDistance / 2), 2) +
                              //     cos(_toRadians(ds.get('lat'))) *
                              //         cos(_toRadians(widget.myLocation.latitude)) *
                              //         pow(sin(lonDistance / 2), 2);
                              // final c = 2 * atan2(sqrt(a), sqrt(1 - a));
                              // final distance = earthRadius * c;
                              // print('dataSnapShot.data!.docs.length');
                              // print(dataSnapShot.data!.docs.length);
                              // print(
                              //     'distance km stream ${dataSnapShot.data!.docs.length}');
                              // print(distance);
                              print('dataSnapShot.data!.docs.length');
                              print(dataSnapShot.data!.docs.length);
                              LatLng myLoc =
                                  LatLng(widget.ds['lat'], widget.ds['lng']);
                              if (myLoc !=
                                  LatLng(ds.get('lat'), ds.get('lng'))) {
                                print('get Locarion true');
                                distanceA = calculateDistance(
                                    ds.get('lat'),
                                    ds.get('lng'),
                                    myLoc.latitude,
                                    myLoc.longitude,
                                    dataSnapShot.data!.docs.length);
                                print('distanceA');
                                print(distanceA);
                              }

                              // print("ds.get('lat')");
                              // print(ds.get('lat'));
                              return dataSnapShot.data!.docs.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.lang == 'en'
                                                ? 'No Users yet'
                                                : 'Aucun utilisateur pour le moment',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000),
                                              // height: 22.h
                                            ),
                                          ),
                                        ],
                                      ), //No data Found
                                    )
                                  : ds.get('uid') ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            OtherProfileScreen(
                                                                dataSnapShot
                                                                        .data!
                                                                        .docs[
                                                                    index],
                                                                1,
                                                                false,
                                                                widget.ds,
                                                                widget.lang)));
                                              },
                                              child: Container(
                                                height: 100,
                                                // margin: EdgeInsets.only(top: 50),
                                                child: Container(
                                                  child: Card(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20.r),
                                                              // image: DecorationImage(
                                                              //   image: NetworkImage(
                                                              //       ds.get('photoUrl')),
                                                              //   fit: BoxFit.cover,
                                                              // ),
                                                              image: ds.get('photoUrl') == 'null'
                                                                  ? DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/profile_pic.png'),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : DecorationImage(
                                                                      image: NetworkImage(
                                                                          ds.get(
                                                                              'photoUrl')),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .78,
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    ds.get(
                                                                        'userName'),
                                                                    style: GoogleFonts
                                                                        .outfit(
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          0xff212121),
                                                                      // height: 22.h
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .location_on_outlined,
                                                                          color:
                                                                              Color(
                                                                            0xffE99A25,
                                                                          ),
                                                                          size:
                                                                              16.sp,
                                                                        ),
                                                                        Text(
                                                                          "${distanceA!.toInt()} km" ??
                                                                              '12',
                                                                          style:
                                                                              GoogleFonts.outfit(
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                Color(0xff797979),
                                                                            // height: 22.h
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    widget.friendList.contains(ds.get('uid')) ||
                                                                            reqList.contains(ds.get('uid'))
                                                                        ? SizedBox()
                                                                        : GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              // friendList.add(
                                                                              //     ds.get(
                                                                              //         'uid'));
                                                                              // print(
                                                                              //     friendList);
                                                                              print('level1');
                                                                              myProfile = widget.ds['photoUrl'] == null ? 'null' : widget.ds['photoUrl'];
                                                                              print('profileeeeeeee');
                                                                              print(myProfile);

                                                                              /// sent, accept, ignore,
                                                                              await FirebaseFirestore.instance.collection('userInfo1').doc(ds.get('uid')).collection('requests').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                'status': 'sent',
                                                                                "userName": widget.ds['userName'],
                                                                                "userEmail": FirebaseAuth.instance.currentUser!.email,
                                                                                "uid": FirebaseAuth.instance.currentUser!.uid,
                                                                                "occupation": widget.ds['occupation'],
                                                                                "photoUrl": myProfile,
                                                                                'breakTime': breakTime,
                                                                                'aboutMe': widget.ds['aboutMe'],
                                                                              }).whenComplete(() async {
                                                                                print('level2');
                                                                                Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());
                                                                                // var dsA = DateTime.now().toString();
                                                                                await FirebaseFirestore.instance.collection('userInfo1').doc(ds.get('uid')).collection('notifications').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                  'status': 'sent',
                                                                                  'read': false,
                                                                                  "userName": widget.ds['userName'],
                                                                                  "userEmail": FirebaseAuth.instance.currentUser!.email,
                                                                                  "uid": FirebaseAuth.instance.currentUser!.uid,
                                                                                  "occupation": widget.ds['occupation'],
                                                                                  "photoUrl": myProfile,
                                                                                  'breakTime': breakTime,
                                                                                  'aboutMe': widget.ds['aboutMe'],
                                                                                  'notification': widget.lang == 'en' ? 'send you a friend request' : 'Vous envoyer une demande d\'ami',
                                                                                  'time': myTimeStamp
                                                                                }).whenComplete(() {
                                                                                  print('level3');
                                                                                  showToastShort(widget.lang == 'en' ? 'Request Sent Successfully' : 'Demande envoyée avec succès', Colors.red);
                                                                                  setState(() {
                                                                                    isAdded = true;
                                                                                  });
                                                                                });
                                                                                reqList.add(ds.get('uid'));
                                                                                print('reqList Updated');
                                                                                print(reqList);
                                                                                FirebaseFirestore.instance.collection('userInfo1').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                                                  'requests': reqList
                                                                                });
                                                                              });
                                                                              try {
                                                                                await sendNotificationToToken(ds.get('token'), 'Friend Request', '${widget.ds['userName']} just sent you a friend request');
                                                                              } catch (e) {
                                                                                print('e.toString()');
                                                                                print(e.toString());
                                                                              }

                                                                              /// for the notification

                                                                              // showToastShort('Req', kOrangeColor);
                                                                            },
                                                                            child:
                                                                                Image.asset('assets/images/add_people.png'),
                                                                          )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                            },
                            itemCount: dataSnapShot.data!.docs.length,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final HttpsCallable sendNotification1 =
      FirebaseFunctions.instance.httpsCallable('sendNotification');

  Future<void> sendNotificationToToken(
      String token, String title, String body) async {
    try {
      final response = await sendNotification1.call({
        'token': token,
        'title': title,
        'body': body,
      });
      print('Successfully sent notification: ${response.data}');
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}
