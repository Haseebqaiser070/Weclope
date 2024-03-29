// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MessageScreen.dart';

class OtherProfileScreen extends StatefulWidget {
  QueryDocumentSnapshot doc;
  QueryDocumentSnapshot myDoc;
  int view;
  bool isOnline;
  var lang;
  OtherProfileScreen(this.doc, this.view, this.isOnline, this.myDoc, this.lang);

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  var myProfile;
  // myUsername, occupation, breakTime, myBio;
  bool isAdded = false, isFriend = false;
  List<dynamic> friendList = [];
  List<dynamic> requests = [];
  List<dynamic> req = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 15, left: 30, right: 20, bottom: 10),
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.lang == 'en' ? 'Profile' : 'Profil',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2f2f2f),
                            // height: 22.h
                          ),
                        ),
                        GestureDetector(
                          // Within the `FirstRoute` widget
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => SmookersList()),
                            // );
                          },
                          child: Container(
                            child: Image.asset('assets/images/dots_icon.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'assets/images/Ornament.png',
                      width: 155.w,
                      height: 60.h,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                padding: EdgeInsets.only(bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doc['userEmail'],
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000).withOpacity(0.6),
                              // height: 22.h
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          widget.doc['userName'].length > 10
                              ? Text(
                                  '${widget.doc['userName'].toString()}' ??
                                      'User',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff000000),
                                    // height: 22.h
                                  ),
                                )
                              : Text(
                                  widget.doc['userName'] ?? 'User',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff000000),
                                    // height: 22.h
                                  ),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          StreamBuilder<String>(
                              stream: FirebaseFirestore.instance
                                  .collection('userInfo1')
                                  .doc(widget.doc['uid'])
                                  .snapshots()
                                  .map((event) =>
                                      event.data()!['occupation'] ??
                                      Text(
                                        widget.lang == 'en'
                                            ? 'Occupation'
                                            : 'Profession',
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffFE9063),
                                          // height: 22.h
                                        ),
                                      )),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: [
                                      Text(
                                        snapshot.data.toString(),
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffFE9063),
                                          // height: 22.h
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    widget.lang == 'en'
                                        ? 'Occupation'
                                        : 'Profession',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffFE9063),
                                      // height: 22.h
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .19,
                        width: MediaQuery.of(context).size.width * .4,
                        child: Stack(
                          children: [
                            Container(
                              child: Image.asset(
                                  'assets/images/profile_border.png'),
                            ),

                            widget.doc['photoUrl'] == null
                                ? Positioned(
                                    left: 9,
                                    top: 10,
                                    child: Image.asset(
                                        'assets/images/profile_pic.png'),
                                  )
                                : Positioned(
                                    left: 4,
                                    top: 5,
                                    child: Container(
                                      height: 120.h,
                                      width: 110.w,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: widget.doc['photoUrl'] == 'null'
                                            ? Image.asset(
                                                'assets/images/profile_pic.png',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                widget.doc['photoUrl'],
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                            // Positioned(
                            //   top: 77,
                            //   left: -10,
                            //   child: Image.asset(
                            //       'assets/images/profile_add_icon.png'),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userInfo1')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, dataSnapShot) {
                  return !dataSnapShot.hasData
                      ? Center(
                          child: Stack(
                            children: const [
                              CircularProgressIndicator(),
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
                            myProfile =
                                dataSnapShot.data!.docs[index].get('photoUrl');
                            myProfile = myProfile == null ? "null" : myProfile;
                            friendList = dataSnapShot.data!.docs[index]
                                .get('friendList');
                            requests =
                                dataSnapShot.data!.docs[index].get('requests');
                            // myUsername =
                            //     dataSnapShot.data!.docs[index].get('userName');
                            // myBio =
                            //     dataSnapShot.data!.docs[index].get('aboutMe');
                            // breakTime =
                            //     dataSnapShot.data!.docs[index].get('breakTime');
                            // occupation = dataSnapShot.data!.docs[index]
                            //     .get('occupation');
                            // print('myUsername send request');
                            // print(myUsername);
                            print(myProfile);
                            print('friendList');
                            print(friendList);
                            req = widget.myDoc['requests'];
                            // req.add(widget.doc['uid']);
                            if (friendList.contains(widget.doc['uid'])) {
                              print('frienddddddddddddddd');
                            } else {
                              print('not friendssssssssssssssssssssss');
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.view == 2
                                    ? SizedBox()
                                    : friendList.contains(widget.doc['uid'])
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          MessageScreen(
                                                              widget.doc[
                                                                  'photoUrl'],
                                                              widget.doc['uid'],
                                                              widget.doc[
                                                                  'userName'],
                                                              widget.myDoc[
                                                                  'userName'],
                                                              widget.isOnline,
                                                              widget.lang)));
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .06,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              // margin: const EdgeInsets.only(top: 10),

                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE99A25),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    widget.lang == 'en'
                                                        ? 'Message'
                                                        : 'Message',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color(0xffffffff),
                                                      // height: 22.h
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : req.contains(widget.doc['uid'])
                                            ? GestureDetector(
                                                onTap: () async {},
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  // margin: const EdgeInsets.only(top: 10),

                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffE99A25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.lang == 'en'
                                                            ? 'Request Sent'
                                                            : 'Demande envoyée',
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xffffffff),
                                                          // height: 22.h
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  print('level1');
                                                  myProfile = widget.myDoc[
                                                              'photoUrl'] ==
                                                          null
                                                      ? 'null'
                                                      : widget
                                                          .myDoc['photoUrl'];

                                                  /// sent, accept, ignore,
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('userInfo1')
                                                      .doc(widget.doc['uid'])
                                                      .collection('requests')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .set({
                                                    'status': 'sent',
                                                    "userName": widget
                                                        .myDoc['userName'],
                                                    "userEmail": FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email,
                                                    "uid": FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    "occupation": widget
                                                        .myDoc['occupation'],
                                                    "photoUrl": myProfile,
                                                    'breakTime': 'breakTime',
                                                    'aboutMe':
                                                        widget.myDoc['aboutMe'],
                                                  }).whenComplete(() async {
                                                    print('level2');

                                                    /// for the notification
                                                    Timestamp myTimeStamp =
                                                        Timestamp.fromDate(
                                                            DateTime.now());
                                                    // var dsA = DateTime.now().toString();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('userInfo1')
                                                        .doc(widget.doc['uid'])
                                                        .collection(
                                                            'notifications')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .set({
                                                      'status': 'sent',
                                                      'read': false,
                                                      "userName": widget
                                                          .myDoc['userName'],
                                                      "userEmail": FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .email,
                                                      "uid": FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      "occupation": widget
                                                          .myDoc['occupation'],
                                                      "photoUrl": myProfile,
                                                      'breakTime': 'breakTime',
                                                      'aboutMe': widget
                                                          .myDoc['aboutMe'],
                                                      'notification': widget
                                                                  .lang ==
                                                              'en'
                                                          ? 'send you a friend request'
                                                          : 'vous a envoyé une demande d\'ami de',
                                                      'time': myTimeStamp
                                                    }).whenComplete(() async {
                                                      print('level3');
                                                      setState(() {
                                                        isAdded = true;
                                                      });
                                                      List<dynamic> req = widget
                                                          .myDoc['requests'];
                                                      req.add(
                                                          widget.doc['uid']);
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'userInfo1')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'requests': req
                                                      });
                                                    });
                                                  });
                                                  try {
                                                    await sendNotificationToToken(
                                                        widget.doc['token'],
                                                        'Friend Request',
                                                        '${widget.myDoc['userName']} just sent you a friend request');
                                                  } catch (e) {
                                                    print('e.toString()');
                                                    print(e.toString());
                                                  }

                                                  // showToastShort('Req', kOrangeColor);
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  // margin: const EdgeInsets.only(top: 10),

                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffE99A25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.lang == 'en'
                                                            ? isAdded
                                                                ? 'Request Sent'
                                                                : 'Add as a friend'
                                                            : isAdded
                                                                ? 'Demande envoyée'
                                                                : 'Ajouter',
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xffffffff),
                                                          // height: 22.h
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                              ],
                            );
                          },
                          itemCount: 1,
                        );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(widget.lang == 'en' ? 'About me' : 'Sur moi',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 19.0),
                child: Row(
                  children: [
                    widget.doc['aboutMe'] == null
                        ? Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do sum sit ematons ectetur adipiscing elit, \nsed do sum sit emat',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000).withOpacity(0.7),
                              // height: 22.h
                            ),
                          )
                        : Flexible(
                            child: Text(
                              widget.doc['aboutMe'],
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff000000).withOpacity(0.7),
                                // height: 22.h
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      widget.lang == 'en'
                          ? 'Breaks Timings'
                          : 'Horaires des pauses',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff000000),
                        // height: 22.h
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(widget.doc['uid'])
                      .collection('break')
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    return !dataSnapShot.hasData
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.lang == 'en'
                                      ? 'No Time Selected yet'
                                      : 'Aucune heure sélectionnée pour le moment',
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
                              // userModel workerAdModel =
                              // userModel.fromJson(
                              //     dataSnapShot.data?.docs[index].data() as Map<String, dynamic>);
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: Icon(
                                      //     Icons.edit,
                                      //     color: kOrangeColor,
                                      //   ),
                                      // ),
                                      Text(
                                        dataSnapShot.data!.docs[index]
                                            .get('breakTime'),
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff646464),
                                          // height: 22.h
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                              ;
                            },
                            itemCount: dataSnapShot.data!.docs.length,
                          );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
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
