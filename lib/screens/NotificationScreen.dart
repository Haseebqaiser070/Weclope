// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wecloppeapp/screens/FriendsScreen.dart';
import '../constant.dart';

class NotificationScreen extends StatefulWidget {
  var lang;
  NotificationScreen(this.lang);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(image: AssetImage('assets/images/ornament_background.png'),
          //   fit: BoxFit.fill,
          //   )
          // ),
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
                          widget.lang == 'en' ? 'Notifications' : 'Avis',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2f2f2f),
                            // height: 22.h
                          ),
                        ),
                        GestureDetector(
                          // Within the `FirstRoute` widget
                          onTap: () async {
                            // var user = FirebaseAuth.instance.currentUser!.uid;
                            // await FirebaseFirestore.instance
                            //     .collection('userInfo1')
                            //     .doc(user)
                            //     .collection('notifications')
                            //     .add({
                            //   'uid': FirebaseAuth.instance.currentUser!.uid,
                            //   'read': false,
                            //   'userEmail':
                            //       FirebaseAuth.instance.currentUser!.email,
                            //   'photoUrl': "",
                            //   'userName': "myUsername",
                            //   'status': 'accept',
                            //   'occupation': "occupation",
                            //   'breakTime': "breakTime",
                            //   'aboutMe': "myBio",
                            //   'time': DateTime.now(),
                            //   'notification': widget.lang == 'en'
                            //       ? 'accepted your friend request'
                            //       : 'accepté votre demande d\'ami'
                            // });

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
                height: MediaQuery.of(context).size.height * .04,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(widget.lang == 'en' ? 'Today' : 'Aujourd\'hui',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('notifications')
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    return !dataSnapShot.hasData
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  'No Notifications yet',
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
                              updateNotifications(ds.id);
                              Timestamp dt = (ds.get('time') as Timestamp);
                              // var format = new DateFormat('d MMM, hh:mm a');
                              // var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                              // format.format(date);
                              // // Get the timestamp (in milliseconds)
                              int timestamp = dt
                                  .millisecondsSinceEpoch; // May 21, 2021 00:00:00 UTC

                              // Get the current time (in milliseconds)
                              int currentTime =
                                  DateTime.now().millisecondsSinceEpoch;

                              // Calculate the difference between the timestamp and the current time
                              int difference = currentTime - timestamp;

                              // Convert the difference to a Duration object
                              Duration remainingTime =
                                  Duration(milliseconds: difference);

                              // Print the remaining time in the form of "remaining time ago"
                              print(
                                  '${remainingTime.inDays} days, ${remainingTime.inHours % 24} hours, ${remainingTime.inMinutes % 60} minutes ago');
                              // int currentTime = DateTime.now().hour;
                              // var finalTimeAgo = '0';
                              // int output = currentTime - dt.hour;
                              // if (output > 0) {
                              //   finalTimeAgo = '${output.toString()}h ago';
                              // } else {
                              //   finalTimeAgo = 'Few min ago';
                              // }
                              print('finalTimeAgo');
                              // print(finalTimeAgo);
                              print('photoUrl');
                              ds.get('photoUrl').toString() != null
                                  ? print(ds.get('photoUrl'))
                                  : print('photoUrl');
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  FriendsScreen(widget.lang)));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 110.h,
                                          // margin: EdgeInsets.only(top: 50),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  decoration: ds.get(
                                                              'photoUrl') ==
                                                          'null'
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/profile_pic.png'),
                                                            fit: BoxFit.cover,
                                                          ))
                                                      : BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                ds.get(
                                                                    'photoUrl')),
                                                            fit: BoxFit.cover,
                                                          )),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      top: 20,
                                                      bottom: 20.0),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          remainingTime.inHours %
                                                                      24 ==
                                                                  0
                                                              ? Text(
                                                                  '${remainingTime.inMinutes % 60} minutes ago',
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xff6b6b6b),
                                                                    // height: 22.h
                                                                  ),
                                                                )
                                                              : Text(
                                                                  '${remainingTime.inHours % 24} hours, ${remainingTime.inMinutes % 60} minutes ago',
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xff6b6b6b),
                                                                    // height: 22.h
                                                                  ),
                                                                ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ds
                                                                          .get(
                                                                              'userName')
                                                                          .toString()
                                                                          .length >
                                                                      12
                                                                  ? Text(
                                                                      '${dataSnapShot.data!.docs[index].get('userName').toString().substring(0, 12)} ',
                                                                      style: GoogleFonts
                                                                          .nunitoSans(
                                                                        fontSize:
                                                                            15.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color:
                                                                            kOrangeColor,
                                                                        // height: 22.h
                                                                      ))
                                                                  : Text(
                                                                      '${dataSnapShot.data!.docs[index].get('userName').toString()} ',
                                                                      style: GoogleFonts
                                                                          .nunitoSans(
                                                                        fontSize:
                                                                            15.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color:
                                                                            kOrangeColor,
                                                                        // height: 22.h
                                                                      )),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${dataSnapShot.data!.docs[index].get('notification').toString()}',
                                                                    style: GoogleFonts
                                                                        .nunitoSans(
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 60,
                                          left: 45,
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                                'assets/images/add_friend.png'),
                                            decoration: BoxDecoration(
                                                color: Color(0xffE99A25),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5.h,
                                  // )
                                ],
                              );
                            },
                            itemCount: dataSnapShot.data!.docs.length,
                          );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              )
            ],
          ),
        ),
      ),
    );
  }

  updateNotifications(String docId) async {
    print("Document Id" + docId);
    var user = FirebaseAuth.instance.currentUser!.uid;
    var a = await FirebaseFirestore.instance
        .collection('userinfo1')
        .doc(user)
        .collection('notifications')
        .doc(docId)
        .get();
    if (a.exists) {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('userinfo1')
          .doc(user)
          .collection('notifications')
          .doc(docId);
      return await documentReference.update({"read": true});
    } else {
      print("object not founddd");
    }
  }
}
