import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'imagePreview.dart';

class MessageScreen extends StatefulWidget {
  String? imageUrl, name, uid, myUsername;
  bool isOnline;
  var lang;
  MessageScreen(this.imageUrl, this.uid, this.name, this.myUsername,
      this.isOnline, this.lang);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with WidgetsBindingObserver {
  // bool? isUserOnline;
  // bool isUserOnline2 = true;
  // bool? getStatus(DocumentSnapshot ds) {
  //   // bool isOnline;
  //   FirebaseFirestore.instance
  //       .collection('userActivity')
  //       .doc(ds.id)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       isUserOnline = value.data()?['isOnline'];
  //     });
  //   });
  //   return isUserOnline;
  // }
  var myProfile;
  var docum = 'doc';
  bool _isLoading = false;
  var image;
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  DateTime time = DateTime.now();
  // var dateF = DateFormat('EEEE').format(date);

  // @override
  // void initState() {
  //   // print(time.);
  //   print('myUsername');
  //   print(widget.myUsername);
  //   print('other name');
  //   print(widget.name);
  //   print('widget.uid');
  //   print(widget.uid);
  //   print('FirebaseAuth.instance.currentUser!.uid');
  //   print(FirebaseAuth.instance.currentUser!.uid);
  //   super.initState();
  // }
  var otherToken;
  isOnline(bool isOnline) async {
    // await FirebaseFirestore.instance
    //     .collection('userActivity')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .update({'isOnline': isOnline});

    var collection = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc('${widget.myUsername}*${widget.name}')
        .collection('chat');
    // var collection = FirebaseFirestore.instance
    //     .collection('user')
    //     .doc('admin')
    //     .collection('orders');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      print('fine');
      await doc.reference.update({
        'isRead': isOnline,
      });
    }

    // await snapshots.forEach((snapshot) async {
    //   List<DocumentSnapshot> documents = snapshot.docs;
    //
    //   await snapshots.forEach((document) async {
    //     document.reference.updateData(<String, dynamic>{
    //       name: this.name
    //     });
    //   })
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      isOnline(true);
    } else {
      isOnline(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
      WidgetsBinding.instance.addObserver(this);
    } else {
      print('uid not match for isRead');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Image.asset('assets/images/back_icon.png'),
                        // Within the `FirstRoute` widget
                        onTap: () {
                          Navigator.pop(context);
                        }),

                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width*.15,
                    // ),
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: widget.imageUrl == 'null'
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/profile_pic.png'),
                                              fit: BoxFit.cover,
                                            ))
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.imageUrl!),
                                                fit: BoxFit.cover)),
                                  ),
                                  Positioned(
                                    left: 40,
                                    top: 40,
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                        color: widget.isOnline
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff2f2f2f),
                                    // height: 22.h
                                  )),
                              widget.isOnline
                                  ? Text(
                                      'Active Now',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff2f2f2f),
                                        // height: 22.h
                                      ),
                                    )
                                  : Text(
                                      '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff2f2f2f),
                                        // height: 22.h
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),

                    Image.asset('assets/images/dots_icon.png'),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${DateFormat('EEEE, d MMM, yyyy').format(time)}',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2f2f2f),
                        // height: 22.h
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo1')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return const Text("");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('');
                      default:
                        return Column(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            // adBy = document['uid'];
                            // myUsername = document['userName'];
                            myProfile = document['photoUrl'];
                            print('myProfile');
                            print(myProfile);
                            // print('myUsername.hashCode');
                            // print(myUsername.hashCode);
                            print('widget.name.hashCode');
                            print(widget.name.hashCode);
                            print(
                                'myUsername.hashCode <= widget.name.hashCode');
                            print(widget.myUsername.hashCode <=
                                widget.name.hashCode);
                            return const SizedBox(
                              height: 0.0,
                            );
                          }).toList(),
                        );
                    }
                  }),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo1')
                      .where('uid', isEqualTo: widget.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return const Text("");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('');
                      default:
                        return Column(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            otherToken = document['token'];
                            print('otherToken');
                            print(otherToken);
                            return const SizedBox(
                              height: 0.0,
                            );
                          }).toList(),
                        );
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              widget.myUsername.hashCode <= widget.name.hashCode
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc('${widget.myUsername}*${widget.name}')
                          .collection('chat')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return const Text("");
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text('');
                          default:
                            return Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                var send = document['senderTo'];
                                bool isImage = document['isImage'];
                                bool isSender = true;
                                if (send !=
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  isSender = false;
                                }
                                return MessageCard(
                                    msg: document['message'],
                                    isSender: !isSender,
                                    image: widget.imageUrl,
                                    time: document['ds'],
                                    isImage: isImage);
                              }).toList(),
                            );
                        }
                      })
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc('${widget.name}*${widget.myUsername}')
                          .collection('chat')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return const Text("");
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text('');
                          default:
                            return Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                var send = document['senderTo'];
                                bool isImage = document['isImage'];
                                bool isSender = true;
                                if (send !=
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  isSender = false;
                                }
                                return MessageCard(
                                    msg: document['message'],
                                    isSender: !isSender,
                                    image: widget.imageUrl,
                                    time: document['ds'],
                                    isImage: isImage);
                              }).toList(),
                            );
                        }
                      }),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: TextField(
          onChanged: (val) {
            if (val.isNotEmpty) {
              setState(() {
                isTyping = true;
              });
              if (val.isEmpty) {
                setState(() {
                  isTyping = false;
                });
              }
            }
          },
          controller: messageController,
          style: GoogleFonts.nunitoSans(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff646464)),
          decoration: InputDecoration(
            fillColor: Color(0xff9797BD).withOpacity(0.1),
            filled: true,
            prefixIcon: Container(
              margin: const EdgeInsets.all(4),
              child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (builder) => bottomSheet());
                  },
                  child: Image.asset('assets/images/camera_icon.png')),
              decoration: BoxDecoration(
                  color: const Color(0xffE99A25),
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            hintText: '    Message',
            hintStyle: GoogleFonts.nunitoSans(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff646464)),
            suffixIcon: isTyping
                ? IconButton(
                    onPressed: () async {
                      var ds = DateTime.now().toString();
                      List<String> member = [];
                      member.add(FirebaseAuth.instance.currentUser!.uid);
                      member.add(widget.uid!);
                      if (widget.myUsername.hashCode <= widget.name.hashCode) {
                        docum =
                            '${widget.myUsername!.trim()}*${widget.name!.trim()}';
                      } else {
                        docum =
                            '${widget.name!.trim()}*${widget.myUsername!.trim()}';
                      }
                      List<String> memberName = [
                        widget.name!.trim(),
                        widget.myUsername!.trim()
                      ];
                      List<String> memberImages = [];
                      if (widget.imageUrl == null) {
                        memberImages = ['null', myProfile];
                      } else if (myProfile == null) {
                        memberImages = [widget.imageUrl!, 'null'];
                      } else if (widget.imageUrl == null && myProfile == null) {
                        memberImages = ['null', 'null'];
                      } else {
                        memberImages = [widget.imageUrl!, myProfile];
                      }
                      // widget.imageUrl == null
                      //     ? memberImages = ['null', myProfile]
                      //     : myProfile == null ?
                      // memberImages = [widget.imageUrl!, 'null']:memberImages = [widget.imageUrl!, myProfile];
                      print('image before database');
                      print(image);
                      FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc(docum)
                          .set({
                        'roomId': '${widget.myUsername}*${widget.name}',
                        'members': member,
                        'recieverImage': widget.imageUrl,
                        'senderImage': myProfile,
                        'name': widget.name,
                        'uidd': widget.uid,
                        'lastMessage': messageController.text,
                        'memberName': memberName,
                        'memberImage': memberImages,
                        'isOnline': true,
                        'BadgeNo': 0,
                      });
                      FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc(docum)
                          .update({
                        'lastMessage': messageController.text,
                      });
                      FirebaseFirestore.instance
                          .collection('chatRoom')
                          .doc(docum)
                          .collection('chat')
                          .doc(ds)
                          .set({
                        'senderTo': widget.uid,
                        'senderBy': FirebaseAuth.instance.currentUser!.uid,
                        'ds': ds,
                        'message': messageController.text.toString(),
                        'isImage': false,
                        'isRead': false,
                      });

                      FirebaseFirestore.instance
                          .collection('userInfo1')
                          .doc(widget.uid)
                          .update(
                              {"chatCount": FieldValue.increment(1)});

                      // sendNotification(
                      //     otherToken, 'You have got a new message');
                      // const sendNotification = firebase.functions().httpsCallable('sendNotification');
                      //
                      // sendNotification({ token: 'FCM_TOKEN_HERE', title: 'Notification Title', body: 'Notification Body' })
                      //     .then((result) => {
                      // console.log(result.data);
                      // })
                      //     .catch((error) => {
                      // console.error(error);
                      // });
                      try {
                        await sendNotificationToToken(
                            otherToken,
                            '${widget.myUsername}',
                            messageController.text.toString());
                      } catch (e) {
                        print('e.toString()');
                        print(e.toString());
                      }

                      messageController.clear();
                    },
                    icon: Icon(Icons.send_outlined),
                    color: Colors.black,
                  )
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send_outlined),
                    // icon: Icon(Icons.mic_none_outlined),
                    color: Colors.black,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
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
  // Future<void> sendNotification(String targetFcmToken, String message) async {
  //   try {
  //     HttpsCallable callable =
  //         FirebaseFunctions.instance.httpsCallable('sendNotification');
  //     final response = await callable
  //         .call({'targetFcmToken': targetFcmToken, 'message': message});
  //     print('Notification sent successfully: ${response.data}');
  //     print('Notification sent successfully: ${response.data}');
  //   } catch (error) {
  //     print('Error sending notification: $error');
  //   }
  // }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxWidth: 680.0, maxHeight: 970.0);

    setState(() {
      _image = File(pickedFile!.path);
    });
    image = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SendImage(_image, widget.uid, widget.myUsername,
                widget.name, widget.imageUrl, myProfile)));
  }

  File? _image;
  File? file;
  final picker = ImagePicker();
  pickUImageFromGallery() async {
    // Navigator.pop(context);
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
    image = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SendImage(_image, widget.uid, widget.myUsername,
                widget.name, widget.imageUrl, myProfile)));
    print('image');

    setState(() {
      // print(image);
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 250.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // iconCreation(
                  //     Icons.insert_drive_file, Colors.indigo, "Document"),
                  // SizedBox(
                  //   width: 40,
                  // ),
                  iconCreation(Icons.camera_alt, Colors.pink,
                      widget.lang == 'en' ? "Camera" : 'Caméra', () {
                    capturePhotoWithCamera();
                  }),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple,
                      widget.lang == 'en' ? "Gallery" : 'Galerie', () {
                    pickUImageFromGallery();
                  }),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     iconCreation(Icons.headset, Colors.orange, "Audio"),
              //     SizedBox(
              //       width: 40,
              //     ),
              //     iconCreation(Icons.location_pin, Colors.teal, "Location"),
              //     SizedBox(
              //       width: 40,
              //     ),
              //     iconCreation(Icons.person, Colors.blue, "Contact"),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, onTap()) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}

// class MessageCard extends StatelessWidget {
//   final String msg;
//   final bool isSender;
//   var image, time;
//   bool isImage;
//   MessageCard({
//     Key? key,
//     required this.msg,
//     required this.isSender,
//     required this.image,
//     required this.time,
//     required this.isImage,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 15.0),
//       child: Column(
//         crossAxisAlignment:
//             isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           isSender
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(right: 7),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(25),
//                             height: MediaQuery.of(context).size.height * .12,
//                             // width: MediaQuery.of(context).size.width*.8,
//
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Yes, Surely.',
//                                   style: GoogleFonts.nunitoSans(
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(0xffffffff),
//                                   ),
//                                 ),
//                                 Image.asset('assets/images/emogi.png'),
//                               ],
//                             ),
//                             decoration: BoxDecoration(
//                               color: Color(0xffE99A25),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(50.r),
//                                 bottomRight: Radius.circular(50.r),
//                                 bottomLeft: Radius.circular(50.r),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(
//                   margin: EdgeInsets.only(left: 7),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(25.r),
//                         height: MediaQuery.of(context).size.height * .12,
//                         width: MediaQuery.of(context).size.width * .8,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Hi Jack I saw you were looking for a',
//                               style: GoogleFonts.nunitoSans(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff262628),
//                               ),
//                             ),
//                             Text(
//                               'smoke partner.',
//                               style: GoogleFonts.nunitoSans(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff262628),
//                               ),
//                             )
//                           ],
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color(0xff9797BD).withOpacity(.3),
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(50.r),
//                             topLeft: Radius.circular(50.r),
//                             bottomRight: Radius.circular(50.r),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * .04,
//           ),
//         ],
//       ),
//     );
//   }
// }
class AttachmentCard extends StatelessWidget {
  final String imageUrl;
  const AttachmentCard({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Container(
        height: 81.h,
        width: 104.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: NetworkImage(
              imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String msg;
  final bool isSender;
  var image, time;
  bool isImage;
  MessageCard({
    Key? key,
    required this.msg,
    required this.isSender,
    required this.image,
    required this.time,
    required this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Container(
                alignment:
                    isSender ? Alignment.centerRight : Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.45,
                padding: isImage ? EdgeInsets.all(0) : EdgeInsets.all(15),
                margin: isSender
                    ? EdgeInsets.only(right: 7)
                    : EdgeInsets.only(left: 7),
                height: MediaQuery.of(context).size.height * .09,
                decoration: BoxDecoration(
                  color: isImage
                      ? Colors.transparent
                      : isSender
                          ? Color(0xffE99A25)
                          : Color(0xff9797BD).withOpacity(.3),
                  borderRadius: isSender
                      ? BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          bottomRight: Radius.circular(50.r),
                          bottomLeft: Radius.circular(50.r),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(50.r),
                          topLeft: Radius.circular(50.r),
                          bottomRight: Radius.circular(50.r),
                        ),
                ),
                child: isImage
                    ? Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 2 + 40,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              msg,
                              height: MediaQuery.of(context).size.height / 3,
                              // fit: BoxFit.fill,
                            )),
                      )
                    : Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: isSender
                            ? GoogleFonts.nunitoSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffffff),
                              )
                            : GoogleFonts.nunitoSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff262628),
                              ),
                      ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0.h, left: 20.w, right: 10.w),
            child: Text(
              time.toString().substring(11, 16),
              style: GoogleFonts.nunitoSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff262628).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
