import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wecloppeapp/style/toast.dart';

import '../constant.dart';
import 'otherProfile.dart';
// import 'package:smooking_app/constant.dart';

class FriendsScreen extends StatefulWidget {
  var lang;
  FriendsScreen(this.lang);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  var myProfile, myUsername, occupation, breakTime, myBio;
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  QueryDocumentSnapshot? myDs;
  List<dynamic> myFriendList = [];
  List<dynamic> otherFriendList = [];
  bool? isUserOnline;
  bool isUserOnline2 = true;
  bool? getStatus(DocumentSnapshot ds) {
    // bool isOnline;
    FirebaseFirestore.instance
        .collection('userActivity')
        .doc(ds.id)
        .get()
        .then((value) {
      setState(() {
        isUserOnline = value.data()?['isOnline'];
      });
    });
    return isUserOnline;
  }

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
                          widget.lang == 'en' ? 'Friends' : 'Amis',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2f2f2f),
                            // height: 22.h
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
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
              Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                ),
                child: TextField(
                  onChanged: (val) {
                    if (val.isEmpty) {
                      setState(() {
                        isSearch = false;
                      });
                    } else {
                      setState(() {
                        isSearch = true;
                      });
                    }
                  },
                  controller: searchController,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    // height: 22.h
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffE99A25),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Color(0xffE99A25),
                      ),
                    ),
                    hintText:
                        widget.lang == 'en' ? '   Search...' : '   Recherche..',
                    hintStyle: GoogleFonts.nunitoSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff6b6b6b),
                      // height: 22.h
                    ),
                    suffixIcon: isSearch
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: kGreyColor,
                            ))
                        : Container(
                            // color: kOrangeColor,
                            width: 24.w,
                            child: Image.asset(
                              'assets/images/search.png',
                              scale: 2.0,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lang == 'en' ? 'Requests' : 'Demandes',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2f2f2f),
                        // height: 22.h
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Container(
                height: 0.0,
                // padding: EdgeInsets.only(left: 20),
                child: StreamBuilder<QuerySnapshot>(
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
                              myDs = dataSnapShot.data!.docs[index];
                              
                              // myDs =
                              //     dataSnapShot.data!.docs[index];
                              
                              myFriendList = dataSnapShot.data!.docs[index]
                                  .get('friendList');
                              myProfile = dataSnapShot.data!.docs[index]
                                  .get('photoUrl');
                              myUsername = dataSnapShot.data!.docs[index]
                                  .get('userName');
                              myBio =
                                  dataSnapShot.data!.docs[index].get('aboutMe');
                              breakTime = dataSnapShot.data!.docs[index]
                                  .get('breakTime');
                              occupation = dataSnapShot.data!.docs[index]
                                  .get('occupation');

                              // print('myUsername send request');
                              // print(myUsername);
                              // print(myProfile);
                              return SizedBox();
                            },
                            itemCount: 1,
                          );
                  },
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('userInfo1')
              //       .doc(FirebaseAuth.instance.currentUser!.uid)
              //       .collection('requests')
              //       .where('status', isEqualTo: 'sent')
              //       .snapshots(),
              //   builder: (context, dataSnapShot) {
              //     return !dataSnapShot.hasData
              //         ? Center(
              //             child: Column(
              //               children: [
              //                 Center(
              //                   child: Text(
              //                     'No Requests yet',
              //                     style: GoogleFonts.nunitoSans(
              //                       fontSize: 16.sp,
              //                       fontWeight: FontWeight.w600,
              //                       color: Color(0xff000000),
              //                       // height: 22.h
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ), //No data Found
              //           )
              //         : StaggeredGridView.countBuilder(
              //             scrollDirection: Axis.vertical,
              //             shrinkWrap: true,
              //             physics: const ScrollPhysics(), // new
              //             crossAxisCount: 1,
              //             staggeredTileBuilder: (c) =>
              //                 const StaggeredTile.fit(1),
              //             itemBuilder: (context, index) {
              //               DocumentSnapshot ds =
              //                   dataSnapShot.data!.docs[index];
              //               return dataSnapShot.data!.docs.isEmpty
              //                   ? Center(
              //                       child: Column(
              //                         children: [
              //                           Center(
              //                             child: Text(
              //                               'No Requests yet',
              //                               style: GoogleFonts.nunitoSans(
              //                                 fontSize: 16.sp,
              //                                 fontWeight: FontWeight.w600,
              //                                 color: Color(0xff000000),
              //                                 // height: 22.h
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       ), //No data Found
              //                     )
              //                   : Column(
              //                       children: [
              //                         Stack(
              //                           children: [
              //                             GestureDetector(
              //                               onTap: () {
              //                                 Navigator.push(
              //                                     context,
              //                                     MaterialPageRoute(
              //                                         builder: (_) =>
              //                                             OtherProfileScreen(
              //                                                 dataSnapShot.data!
              //                                                     .docs[index],
              //                                                 2,
              //                                                 isUserOnline2)));
              //                               },
              //                               child: Container(
              //                                 padding: EdgeInsets.symmetric(
              //                                     horizontal: 12.0),
              //                                 child: Row(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment
              //                                           .spaceEvenly,
              //                                   children: [
              //                                     Container(
              //                                       height: 60,
              //                                       width: 60,
              //                                       // margin: EdgeInsets.only(
              //                                       //     left: 5),
              //                                       decoration: BoxDecoration(
              //                                           borderRadius:
              //                                               BorderRadius
              //                                                   .circular(20.r),
              //                                           image: dataSnapShot
              //                                                       .data
              //                                                       ?.docs[
              //                                                           index]
              //                                                       .get(
              //                                                           'photoUrl') ==
              //                                                   null
              //                                               ? DecorationImage(
              //                                                   image: AssetImage(
              //                                                       'assets/images/profile_pic.png'),
              //                                                   fit: BoxFit
              //                                                       .cover,
              //                                                 )
              //                                               : DecorationImage(
              //                                                   image: NetworkImage(
              //                                                       dataSnapShot
              //                                                           .data
              //                                                           ?.docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'photoUrl')),
              //                                                   fit: BoxFit
              //                                                       .cover,
              //                                                 )),
              //                                     ),
              //                                     SizedBox(
              //                                       width: 0.0,
              //                                     ),
              //                                     Text(
              //                                       ds
              //                                                   .get('userName')
              //                                                   .toString()
              //                                                   .length >
              //                                               15
              //                                           ? '${ds.get('userName').toString().substring(0, 15)}...'
              //                                           : ds.get('userName'),
              //                                       style:
              //                                           GoogleFonts.nunitoSans(
              //                                         fontSize: 16.sp,
              //                                         fontWeight:
              //                                             FontWeight.w800,
              //                                         color: Color(0xff000000),
              //                                         // height: 22.h
              //                                       ),
              //                                     ),
              //                                     SizedBox(
              //                                       width: 50.0,
              //                                     ),
              //                                     Align(
              //                                       alignment:
              //                                           Alignment(0.7, -0.5),
              //                                       child: Row(
              //                                         // crossAxisAlignment:
              //                                         //     CrossAxisAlignment.end,
              //                                         children: [
              //                                           CircleAvatar(
              //                                               radius: 17.0,
              //                                               backgroundColor:
              //                                                   kOrangeColor,
              //                                               child: IconButton(
              //                                                   onPressed:
              //                                                       () async {
              //                                                     ///add it to mi friend
              //                                                     try {
              //                                                       myFriendList
              //                                                           .add(ds.get(
              //                                                               'uid'));
              //                                                       await FirebaseFirestore
              //                                                           .instance
              //                                                           .collection(
              //                                                               'userInfo1')
              //                                                           .doc(FirebaseAuth
              //                                                               .instance
              //                                                               .currentUser!
              //                                                               .uid)
              //                                                           .update({
              //                                                         'friendList':
              //                                                             myFriendList
              //                                                       });
              //                                                       print(
              //                                                           'myFriendList');
              //                                                       print(
              //                                                           myFriendList);
              //                                                     } catch (e, s) {
              //                                                       print(s);
              //                                                     }
              //                                                     try {
              //                                                       otherFriendList.add(FirebaseAuth
              //                                                           .instance
              //                                                           .currentUser!
              //                                                           .uid);
              //                                                       await FirebaseFirestore
              //                                                           .instance
              //                                                           .collection(
              //                                                               'userInfo1')
              //                                                           .doc(ds.get(
              //                                                               'uid'))
              //                                                           .update({
              //                                                         'friendList':
              //                                                             otherFriendList
              //                                                       });
              //                                                       print(
              //                                                           'otherFriendList');
              //                                                       print(
              //                                                           otherFriendList);
              //                                                     } catch (e, s) {
              //                                                       print(s);
              //                                                     }
              //
              //                                                     await FirebaseFirestore
              //                                                         .instance
              //                                                         .collection(
              //                                                             'userInfo1')
              //                                                         .doc(FirebaseAuth
              //                                                             .instance
              //                                                             .currentUser!
              //                                                             .uid)
              //                                                         .collection(
              //                                                             'friends')
              //                                                         .doc(dataSnapShot
              //                                                             .data!
              //                                                             .docs[
              //                                                                 index]
              //                                                             .get(
              //                                                                 'uid'))
              //                                                         .set({
              //                                                       'uid': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'uid'),
              //                                                       'userEmail': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'userEmail'),
              //                                                       'photoUrl': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'photoUrl'),
              //                                                       'userName': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'userName'),
              //                                                       'occupation': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'occupation'),
              //                                                       'breakTime': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'breakTime'),
              //                                                       'aboutMe': dataSnapShot
              //                                                           .data!
              //                                                           .docs[
              //                                                               index]
              //                                                           .get(
              //                                                               'aboutMe'),
              //                                                       'status':
              //                                                           'accept',
              //                                                     }).whenComplete(
              //                                                             () async {
              //                                                       ///add it to friend list of sender
              //                                                       print(
              //                                                           'level1');
              //                                                       await FirebaseFirestore
              //                                                           .instance
              //                                                           .collection(
              //                                                               'userInfo1')
              //                                                           .doc(dataSnapShot
              //                                                               .data!
              //                                                               .docs[
              //                                                                   index]
              //                                                               .get(
              //                                                                   'uid'))
              //                                                           .collection(
              //                                                               'friends')
              //                                                           .doc(FirebaseAuth
              //                                                               .instance
              //                                                               .currentUser!
              //                                                               .uid)
              //                                                           .set({
              //                                                         'uid': FirebaseAuth
              //                                                             .instance
              //                                                             .currentUser!
              //                                                             .uid,
              //                                                         'userEmail': FirebaseAuth
              //                                                             .instance
              //                                                             .currentUser!
              //                                                             .email,
              //                                                         'photoUrl':
              //                                                             myProfile,
              //                                                         'userName':
              //                                                             myUsername,
              //                                                         'status':
              //                                                             'accept',
              //                                                         'occupation':
              //                                                             occupation,
              //                                                         'breakTime':
              //                                                             breakTime,
              //                                                         'aboutMe':
              //                                                             myBio,
              //                                                       }).whenComplete(
              //                                                               () async {
              //                                                         print(
              //                                                             'level2');
              //
              //                                                         await FirebaseFirestore
              //                                                             .instance
              //                                                             .collection(
              //                                                                 'userInfo1')
              //                                                             .doc(FirebaseAuth
              //                                                                 .instance
              //                                                                 .currentUser!
              //                                                                 .uid)
              //                                                             .update({
              //                                                           'friendList':
              //                                                               myFriendList
              //                                                         }).whenComplete(
              //                                                                 () async {
              //                                                           print(
              //                                                               'level3');
              //                                                           await FirebaseFirestore
              //                                                               .instance
              //                                                               .collection(
              //                                                                   'userInfo1')
              //                                                               .doc(ds.get(
              //                                                                   'uid'))
              //                                                               .update({
              //                                                             'friendList':
              //                                                                 otherFriendList
              //                                                           }).whenComplete(() async {
              //                                                             Timestamp
              //                                                                 myTimeStamp =
              //                                                                 Timestamp.fromDate(DateTime.now());
              //                                                             print(
              //                                                                 'level4');
              //
              //                                                             ///add notification
              //                                                             await FirebaseFirestore
              //                                                                 .instance
              //                                                                 .collection('userInfo1')
              //                                                                 .doc(dataSnapShot.data!.docs[index].get('uid'))
              //                                                                 .collection('notifications')
              //                                                                 .doc(FirebaseAuth.instance.currentUser!.uid)
              //                                                                 .set({
              //                                                               'uid':
              //                                                                   FirebaseAuth.instance.currentUser!.uid,
              //                                                               'userEmail':
              //                                                                   FirebaseAuth.instance.currentUser!.email,
              //                                                               'photoUrl':
              //                                                                   myProfile,
              //                                                               'userName':
              //                                                                   myUsername,
              //                                                               'status':
              //                                                                   'accept',
              //                                                               'occupation':
              //                                                                   occupation,
              //                                                               'breakTime':
              //                                                                   breakTime,
              //                                                               'aboutMe':
              //                                                                   myBio,
              //                                                               'time':
              //                                                                   myTimeStamp,
              //                                                               'notification':
              //                                                                   'accepted your friend request'
              //                                                             });
              //                                                           }).whenComplete(() async {
              //                                                             print(
              //                                                                 'level5');
              //                                                             await FirebaseFirestore
              //                                                                 .instance
              //                                                                 .collection('userInfo1')
              //                                                                 .doc(FirebaseAuth.instance.currentUser!.uid)
              //                                                                 .collection('requests')
              //                                                                 .doc(ds.id)
              //                                                                 .update({
              //                                                               'status':
              //                                                                   'accept',
              //                                                             });
              //                                                           });
              //                                                         });
              //                                                       });
              //                                                     });
              //                                                   },
              //                                                   icon: Icon(
              //                                                     Icons
              //                                                         .check_outlined,
              //                                                     color:
              //                                                         kWhiteColor,
              //                                                     size: 15.0,
              //                                                   ))),
              //                                           SizedBox(
              //                                             width: 5.0,
              //                                           ),
              //                                           CircleAvatar(
              //                                               radius: 17.0,
              //                                               backgroundColor:
              //                                                   Colors.red,
              //                                               child: IconButton(
              //                                                   onPressed: () {
              //                                                     FirebaseFirestore
              //                                                         .instance
              //                                                         .collection(
              //                                                             'userInfo1')
              //                                                         .doc(FirebaseAuth
              //                                                             .instance
              //                                                             .currentUser!
              //                                                             .uid)
              //                                                         .collection(
              //                                                             'requests')
              //                                                         .doc(
              //                                                             ds.id)
              //                                                         .delete();
              //                                                   },
              //                                                   icon: Icon(
              //                                                     Icons.cancel,
              //                                                     color:
              //                                                         kWhiteColor,
              //                                                     size: 15.0,
              //                                                   ))),
              //                                         ],
              //                                       ),
              //                                     )
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         SizedBox(
              //                           height: 10.0,
              //                         )
              //                       ],
              //                     );
              //             },
              //             itemCount: dataSnapShot.data!.docs.length,
              //           );
              //   },
              // ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userInfo1')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('requests')
                    .where('status', isEqualTo: 'sent')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(widget.lang == 'en'
                            ? 'No Request found'
                            : 'Aucune demande trouvée'),
                      ));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Scrollbar(
                          thickness: 8.w,
                          radius: Radius.circular(10.r),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data!.docs[index];
                                // isUserOnline2 = getStatus(ds)!;
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        OtherProfileScreen(
                                                            snapshot.data!
                                                                .docs[index],
                                                            2,
                                                            isUserOnline2,
                                                            myDs!,
                                                            widget.lang)));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  // margin: EdgeInsets.only(
                                                  //     left: 5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      image: ds.get(
                                                                  'photoUrl') ==
                                                              'null'
                                                          ? DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/profile_pic.png'),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : DecorationImage(
                                                              image: NetworkImage(
                                                                  ds.get(
                                                                      'photoUrl')),
                                                              fit: BoxFit.cover,
                                                            )),
                                                ),
                                                SizedBox(
                                                  width: 0.0,
                                                ),
                                                Text(
                                                  ds
                                                              .get('userName')
                                                              .toString()
                                                              .length >
                                                          15
                                                      ? '${ds.get('userName').toString().substring(0, 15)}...'
                                                      : ds.get('userName'),
                                                  style: GoogleFonts.nunitoSans(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xff000000),
                                                    // height: 22.h
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.0,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.7, -0.5),
                                                  child: Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment.end,
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 17.0,
                                                          backgroundColor:
                                                              kOrangeColor,
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                ///add it to mi friend
                                                                try {
                                                                  myFriendList
                                                                      .add(ds.get(
                                                                          'uid'));
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'userInfo1')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      .update({
                                                                    'friendList':
                                                                        myFriendList
                                                                  });
                                                                  print(
                                                                      'myFriendList');
                                                                  print(
                                                                      myFriendList);
                                                                } catch (e, s) {
                                                                  print(s);
                                                                }
                                                                try {
                                                                  otherFriendList.add(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid);
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'userInfo1')
                                                                      .doc(ds.get(
                                                                          'uid'))
                                                                      .update({
                                                                    'friendList':
                                                                        otherFriendList
                                                                  });
                                                                  print(
                                                                      'otherFriendList');
                                                                  print(
                                                                      otherFriendList);
                                                                } catch (e, s) {
                                                                  print(s);
                                                                }

                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'userInfo1')
                                                                    .doc(FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                                    .collection(
                                                                        'friends')
                                                                    .doc(ds.get(
                                                                        'uid'))
                                                                    .set({
                                                                  'uid': ds.get(
                                                                      'uid'),
                                                                  'userEmail':
                                                                      ds.get(
                                                                          'userEmail'),
                                                                  'photoUrl':
                                                                      ds.get(
                                                                          'photoUrl'),
                                                                  'userName':
                                                                      ds.get(
                                                                          'userName'),
                                                                  'occupation':
                                                                      ds.get(
                                                                          'occupation'),
                                                                  'breakTime':
                                                                      ds.get(
                                                                          'breakTime'),
                                                                  'aboutMe': ds.get(
                                                                      'aboutMe'),
                                                                  'status':
                                                                      'accept',
                                                                }).whenComplete(
                                                                        () async {
                                                                  ///add it to friend list of sender
                                                                  print(
                                                                      'level1');
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'userInfo1')
                                                                      .doc(ds.get(
                                                                          'uid'))
                                                                      .collection(
                                                                          'friends')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      .set({
                                                                    'uid': FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid,
                                                                    'userEmail': FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .email,
                                                                    'photoUrl':
                                                                        myProfile,
                                                                    'userName':
                                                                        myUsername,
                                                                    'status':
                                                                        'accept',
                                                                    'occupation':
                                                                        occupation,
                                                                    'breakTime':
                                                                        breakTime,
                                                                    'aboutMe':
                                                                        myBio,
                                                                  }).whenComplete(
                                                                          () async {
                                                                    print(
                                                                        'level2');

                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'userInfo1')
                                                                        .doc(FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                        .update({
                                                                      'friendList':
                                                                          myFriendList
                                                                    }).whenComplete(
                                                                            () async {
                                                                      print(
                                                                          'level3');
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'userInfo1')
                                                                          .doc(ds.get(
                                                                              'uid'))
                                                                          .update({
                                                                        'friendList':
                                                                            otherFriendList
                                                                      }).whenComplete(
                                                                              () async {
                                                                        Timestamp
                                                                            myTimeStamp =
                                                                            Timestamp.fromDate(DateTime.now());
                                                                        print(
                                                                            'level4');

                                                                        ///add notification
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('userInfo1')
                                                                            .doc(ds.get('uid'))
                                                                            .collection('notifications')
                                                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                            .set({
                                                                          'uid': FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid,
                                                                          'read':
                                                                              false,
                                                                          'userEmail': FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .email,
                                                                          'photoUrl':
                                                                              myProfile,
                                                                          'userName':
                                                                              myUsername,
                                                                          'status':
                                                                              'accept',
                                                                          'occupation':
                                                                              occupation,
                                                                          'breakTime':
                                                                              breakTime,
                                                                          'aboutMe':
                                                                              myBio,
                                                                          'time':
                                                                              myTimeStamp,
                                                                          'notification': widget.lang == 'en'
                                                                              ? 'accepted your friend request'
                                                                              : 'accepté votre demande d\'ami'
                                                                        });
                                                                      }).whenComplete(
                                                                              () async {
                                                                        // try {
                                                                        //   await sendNotificationToToken(
                                                                        //       widget.doc['token'],
                                                                        //       'Friend Request',
                                                                        //       '${widget.myDoc['userName']} just sent you a friend request');
                                                                        // } catch (e) {
                                                                        //   print('e.toString()');
                                                                        //   print(e.toString());
                                                                        // }
                                                                        print(
                                                                            'level5');
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('userInfo1')
                                                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                                                            .collection('requests')
                                                                            .doc(ds.id)
                                                                            .update({
                                                                          'status':
                                                                              'accept',
                                                                        });
                                                                      });
                                                                    });
                                                                  });
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .check_outlined,
                                                                color:
                                                                    kWhiteColor,
                                                                size: 15.0,
                                                              ))),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      CircleAvatar(
                                                          radius: 17.0,
                                                          backgroundColor:
                                                              Colors.red,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'userInfo1')
                                                                    .doc(FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                                    .collection(
                                                                        'requests')
                                                                    .doc(ds.id)
                                                                    .delete();
                                                              },
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                color:
                                                                    kWhiteColor,
                                                                size: 15.0,
                                                              ))),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    )
                                  ],
                                );
                              }),
                        ),
                      );
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lang == 'en' ? 'Friends' : 'Amis',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2f2f2f),
                        // height: 22.h
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),

              isSearch
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('userInfo1')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('friends')
                          .where('userName',
                              isGreaterThan: searchController.text)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          if (snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text(widget.lang == 'en'
                                    ? 'No Friend found'
                                    : 'Aucun ami trouvé'));
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Scrollbar(
                                  thickness: 8.w,
                                  radius: Radius.circular(10.r),
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshot.data!.docs[index];
                                        isUserOnline2 = getStatus(ds)!;
                                        return Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                OtherProfileScreen(
                                                                    snapshot.data!
                                                                            .docs[
                                                                        index],
                                                                    1,
                                                                    isUserOnline2,
                                                                    myDs!,
                                                                    widget
                                                                        .lang)));
                                                  },
                                                  leading: Container(
                                                    height: 60,
                                                    width: 60,
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                        image: ds.get(
                                                                    'photoUrl') ==
                                                                null
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
                                                  title: Text(
                                                    ds.get('userName'),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff000000),
                                                      // height: 22.h
                                                    ),
                                                  ),
                                                  trailing: GestureDetector(
                                                    onTap: () {
                                                      // myFriendList.remove(ds.id);
                                                      // FirebaseFirestore.instance
                                                      //     .collection('userInfo1')
                                                      //     .doc(FirebaseAuth.instance
                                                      //         .currentUser!.uid)
                                                      //     .update({
                                                      //   'friendList': myFriendList
                                                      // });
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'userInfo1')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection('friends')
                                                          .doc(ds.id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        showToastShort(
                                                            widget.lang == 'en'
                                                                ? '${ds.get('userName')} unfriend from your friends'
                                                                : '${ds.get('userName')} Annuler la liste d\'amis de vos amis',
                                                            Colors.red);
                                                      });

                                                      // showAlertDialog(context,ds.id);
                                                    },
                                                    child: Container(
                                                      width: 93.w,
                                                      height: 33.h,
                                                      // padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            widget.lang == 'en'
                                                                ? 'UNFRIEND'
                                                                : 'UNAMI',
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  kOrangeColor,
                                                              // height: 22.h
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffE99A25)),
                                                        // color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 40,
                                                  left: 25,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        kWhiteColor,
                                                    radius: 7.0,
                                                    child: Container(
                                                      height: 18,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                          color: isUserOnline2
                                                              ? Color(
                                                                  0xff54D969)
                                                              : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('userInfo1')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('friends')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          if (snapshot.data!.docs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(widget.lang == 'en'
                                      ? 'No Friends found'
                                      : 'Aucun ami trouvé')),
                            );
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Scrollbar(
                                  thickness: 8.w,
                                  radius: Radius.circular(10.r),
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshot.data!.docs[index];
                                        isUserOnline2 = getStatus(ds)!;
                                        // print('isUserOnline2222');
                                        // print(isUserOnline2);
                                        return Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                OtherProfileScreen(
                                                                    snapshot.data!
                                                                            .docs[
                                                                        index],
                                                                    1,
                                                                    isUserOnline2,
                                                                    myDs!,
                                                                    widget
                                                                        .lang)));
                                                  },
                                                  leading: Container(
                                                    height: 60,
                                                    width: 60,
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                        image: ds.get(
                                                                    'photoUrl') ==
                                                                'null'
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
                                                  title: Text(
                                                    ds.get('userName') ??
                                                        'User',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff000000),
                                                      // height: 22.h
                                                    ),
                                                  ),
                                                  trailing: GestureDetector(
                                                    onTap: () {
                                                      // myFriendList.remove(ds.id);
                                                      // FirebaseFirestore.instance
                                                      //     .collection('userInfo1')
                                                      //     .doc(FirebaseAuth.instance
                                                      //         .currentUser!.uid)
                                                      //     .update({
                                                      //   'friendList': myFriendList
                                                      // });
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'userInfo1')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection('friends')
                                                          .doc(ds.id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        showToastShort(
                                                            widget.lang == 'en'
                                                                ? '${ds.get('userName')} unfriend from your friends'
                                                                : '${ds.get('userName')} Annuler la liste d\'amis de vos amis',
                                                            Colors.red);
                                                      });
                                                      // showAlertDialog(context,ds.id);
                                                    },
                                                    child: Container(
                                                      width: 93.w,
                                                      height: 33.h,
                                                      // padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            widget.lang == 'en'
                                                                ? 'UNFRIEND'
                                                                : 'UNAMI',
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  kOrangeColor,
                                                              // height: 22.h
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffE99A25)),
                                                        // color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 40,
                                                  left: 25,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        kWhiteColor,
                                                    radius: 7.0,
                                                    child: Container(
                                                      height: 18,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                          color: isUserOnline2
                                                              ? Color(
                                                                  0xff54D969)
                                                              : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            );
                          }
                        }
                      },
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

  showAlertDialog(BuildContext context, var ds) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(widget.lang == 'en' ? "Yes" : 'Oui'),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('userInfo1')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('friends')
            .doc(ds)
            .delete();
      },
    );
    Widget noButton = TextButton(
      child: Text(widget.lang == 'en' ? "No" : 'Non'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Unfriend User"),
      content: Text("Are you sure you want to unfriend that user"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
