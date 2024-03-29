import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart' as Im;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecloppeapp/screens/WelcomeScreen.dart';
import 'package:wecloppeapp/screens/editHomeAddress.dart';

import '../constant.dart';
import '../style/toast.dart';
import 'editOfficeAddress.dart';

class ProfileScreen extends StatefulWidget {
  var lang;
  ProfileScreen(this.lang);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  List<dynamic> breakTimeList = [];
  final picker = ImagePicker();
  bool isLoadingImage = false;
  bool obscureText = true;
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  File? file;
  bool uploading = false;
  String? imageUrl;
  bool _choice = false;
  File? _image;
  TimeOfDay _fromTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _toTime = TimeOfDay(hour: 0, minute: 0);
  var fromTime = '12:00 PM', ToTime = '12:00 PM';

  DetailsResult? startPosition;
  DetailsResult? endPosition;

  FocusNode? startFocusNode;
  FocusNode? endFocusNode;

  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];
  List<AutocompletePrediction> predictions2 = [];
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKey = 'AIzaSyBxPmk11ZgYxaCAp7RMfGesv1NW2GzWVi8';
    googlePlace = GooglePlace(apiKey);

    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode!.dispose();
    endFocusNode!.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void autoCompleteSearchHome(String value) async {
    var result2 = await googlePlace!.autocomplete.get(value);
    if (result2 != null && result2.predictions != null && mounted) {
      print(result2.predictions!.first.description);
      setState(() {
        predictions2 = result2.predictions!;
      });
    }
  }

  TextEditingController homeController = TextEditingController();
  TextEditingController officeController = TextEditingController();
  List<TimeOfDay> _timeSlots = [];

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (selectedTime != null) {
      setState(() {
        _fromTime = selectedTime;
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _toTime,
    );
    if (selectedTime != null) {
      setState(() {
        _toTime = selectedTime;
      });
    }
  }

  void _createSlots() {
    setState(() {
      _timeSlots = createTimeSlots(_fromTime, _toTime);
    });
    print('_timeSlots');
    print(_timeSlots.last.minute);
  }

  List<TimeOfDay> createTimeSlots(TimeOfDay fromTime, TimeOfDay toTime) {
    final List<TimeOfDay> timeSlots = [];

    // Calculate the duration between the two times
    final Duration duration = Duration(
      hours: toTime.hour - fromTime.hour,
      minutes: toTime.minute - fromTime.minute,
    );

    // Calculate the total number of 15-minute slots between the two times
    final int totalSlots = duration.inMinutes ~/ 15;

    // Create the time slots
    for (int i = 0; i <= totalSlots; i++) {
      final int minutesToAdd = i * 15;
      final TimeOfDay slotTime = TimeOfDay(
          hour: fromTime.hour, minute: fromTime.minute + minutesToAdd);
      timeSlots.add(slotTime);
    }

    return timeSlots;
  }

  // @override
  // void initState() {
  //   print('FirebaseAuth.instance.currentUser!.uid');
  //   print(FirebaseAuth.instance.currentUser!.uid);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Stack(
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
                                showBottomSheet();
                              },
                              child: Container(
                                child:
                                    Image.asset('assets/images/dots_icon.png'),
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
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<String>(
                                stream: FirebaseFirestore.instance
                                    .collection('userInfo1')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots()
                                    .map((event) =>
                                        event.data()!['userEmail'] ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color(0xff000000).withOpacity(0.6),
                                        // height: 22.h
                                      ),
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                }),
                            // Text(
                            //   'jackmadani.900@gmail.com',
                            //   style: GoogleFonts.nunitoSans(
                            //     fontSize: 14.sp,
                            //     fontWeight: FontWeight.w400,
                            //     color: Color(0xff000000).withOpacity(0.6),
                            //     // height: 22.h
                            //   ),
                            // ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            StreamBuilder<String>(
                                stream: FirebaseFirestore.instance
                                    .collection('userInfo1')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots()
                                    .map((event) =>
                                        event.data()!['userName'] ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: [
                                        snapshot.data.toString().length > 12
                                            ? Text(
                                                '${snapshot.data.toString().substring(0, 12)}..',
                                                style: GoogleFonts.nunitoSans(
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff000000),
                                                  // height: 22.h
                                                ),
                                              )
                                            : Text(
                                                snapshot.data.toString(),
                                                style: GoogleFonts.nunitoSans(
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff000000),
                                                  // height: 22.h
                                                ),
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              // _displayDialog(context);
                                              EditUsername(context);
                                              // EditBio(context);
                                            },
                                            child: Image.asset(
                                                'assets/images/editprofile_icon.png')),
                                      ],
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                }),
                            // Text(
                            //   'Jack Madani',
                            //   style: GoogleFonts.nunitoSans(
                            //     fontSize: 24.sp,
                            //     fontWeight: FontWeight.w700,
                            //     color: Color(0xff000000),
                            //     // height: 22.h
                            //   ),
                            // ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            StreamBuilder<String>(
                                stream: FirebaseFirestore.instance
                                    .collection('userInfo1')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              EditOccupation(context);
                                            },
                                            child: Image.asset(
                                                'assets/images/editprofile_icon.png')),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
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
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              EditOccupation(context);
                                            },
                                            child: Image.asset(
                                                'assets/images/editprofile_icon.png')),
                                      ],
                                    );
                                  }
                                }),
                          ],
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
                              GestureDetector(
                                onTap: () {
                                  takeImage(context);
                                },
                                child: _image == null
                                    ? Center(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 5,
                                              top: 5,
                                              child: StreamBuilder<String>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('userInfo1')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .snapshots()
                                                      .map((event) =>
                                                          event.data()![
                                                              'photoUrl'] ??
                                                          Image.asset(
                                                              'assets/images/profile_pic.png')),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Container(
                                                        height: 120.h,
                                                        width: 110.w,
                                                        // decoration: BoxDecoration(
                                                        //   borderRadius:
                                                        //       BorderRadius.circular(
                                                        //           25.0),
                                                        // ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          child: snapshot.data
                                                                      .toString() ==
                                                                  'null'
                                                              ? Image.asset(
                                                                  'assets/images/profile_pic.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  snapshot.data
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Image.asset(
                                                          'assets/images/profile_pic.png');
                                                    }
                                                  }),
                                              // Image.asset(
                                              //     'assets/images/profile_pic.png'),
                                            ),
                                            Positioned(
                                              top: 77,
                                              left: -10,
                                              child: Image.asset(
                                                  'assets/images/profile_add_icon.png'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          InkWell(
                                            onTap: () => takeImage(context),
                                            child: Container(
                                              height: 184.h,
                                              width: 110.w,
                                              margin: EdgeInsets.only(
                                                  bottom: 20, left: 4.0),
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          alignment:
                                                              Alignment.center,
                                                          image: FileImage(
                                                              _image!,
                                                              scale: 6.0),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          _image == null
                                              ? SizedBox()
                                              : Positioned(
                                                  top: 77,
                                                  left: 10,
                                                  child: CircleAvatar(
                                                    backgroundColor: kGreyColor,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        uploadImageAndSaveItemInfo();
                                                      },
                                                      icon: isLoadingImage
                                                          ? CircularProgressIndicator(
                                                              color:
                                                                  kWhiteColor,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .check_outlined,
                                                              color:
                                                                  kWhiteColor,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                              )

                              // Positioned(
                              //   left: 9,
                              //   top: 10,
                              //   child: Image.asset('assets/images/profile_pic.png'),
                              // ),
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
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        widget.lang == 'en' ? 'About me' : 'Sur moi',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .15,
                      ),
                      GestureDetector(
                          onTap: () {
                            EditBio(context);
                          },
                          child: Image.asset(
                              'assets/images/editprofile_icon.png')),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      StreamBuilder<String>(
                          stream: FirebaseFirestore.instance
                              .collection('userInfo1')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots()
                              .map(
                                (event) =>
                                    event.data()!['aboutMe'] ??
                                    Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do sum sit ematons ectetur adipiscing elit, \nsed do sum sit emat',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color(0xff000000).withOpacity(0.7),
                                        // height: 22.h
                                      ),
                                    ),
                              ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Flexible(
                                child: Text(
                                  snapshot.data.toString(),
                                  style: GoogleFonts.nunitoSans(
                                    // overflow: TextOverflow.ellipsis,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000).withOpacity(0.7),

                                    // height: 22.h
                                  ),
                                ),
                              );
                            } else {
                              return Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do sum sit ematons ectetur adipiscing elit, \nsed do sum sit emat',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000).withOpacity(0.7),
                                  // height: 22.h
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .01,
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 20),
                //   child: Row(
                //     children: [
                //       Text(
                //         '',
                //         style: GoogleFonts.nunitoSans(
                //           fontSize: 16.sp,
                //           fontWeight: FontWeight.w400,
                //           color: Color(0xff000000).withOpacity(0.7),
                //           // height: 22.h
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .01,
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 20),
                //   child: Row(
                //     children: [
                //       Text(
                //         '',
                //         style: GoogleFonts.nunitoSans(
                //           fontSize: 16.sp,
                //           fontWeight: FontWeight.w400,
                //           color: Color(0xff000000).withOpacity(0.7),
                //           // height: 22.h
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        widget.lang == 'en'
                            ? 'Work Address'
                            : 'Adresse professionnelle',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .15,
                      ),
                      GestureDetector(
                          onTap: () {
                            // EditWorkAddress(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EditOfficeAddress1(widget.lang)));
                          },
                          child: Image.asset(
                              'assets/images/editprofile_icon.png')),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: StreamBuilder<String>(
                      stream: FirebaseFirestore.instance
                          .collection('userInfo1')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots()
                          .map(
                            (event) =>
                                event.data()!['officeAddress'] ??
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.location_on_outlined,
                                            color: Color(0xffE99A25),
                                          ),
                                          hintText:
                                              '30 rue Gontier-Patin, Abbeville, France',
                                          hintStyle: TextStyle(fontSize: 14.sp),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 50,
                                      top: 4,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text(
                                          widget.lang == 'en'
                                              ? 'Work Address'
                                              : 'Adresse professionnelle',
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff2f2f2f),
                                            // height: 22.h
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    // suffixIcon: GestureDetector(
                                    //     onTap: () {
                                    //       print('Hellllllo');
                                    //       EditBio(context);
                                    //     },
                                    //     child: Image.asset(
                                    //         'assets/images/editprofile_icon.png')),
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffE99A25),
                                    ),
                                    hintText: snapshot.data.toString(),
                                    hintStyle: TextStyle(
                                        fontSize: 14.sp, color: kBlackColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 4,
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    widget.lang == 'en'
                                        ? 'Work Address'
                                        : 'Adresse professionnelle',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2f2f2f),
                                      // height: 22.h
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffE99A25),
                                    ),
                                    hintText:
                                        '30 rue Gontier-Patin, Abbeville, France',
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 4,
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    widget.lang == 'en'
                                        ? 'Work Address'
                                        : 'Adresse professionnelle',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2f2f2f),
                                      // height: 22.h
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        widget.lang == 'en'
                            ? 'Home Address'
                            : 'Adresse du domicile',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .15,
                      ),
                      GestureDetector(
                          onTap: () {
                            print('pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EditHomeAddress1(widget.lang)));
                            // EditHomeAddress(context);
                          },
                          child: Image.asset(
                              'assets/images/editprofile_icon.png')),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: StreamBuilder<String>(
                      stream: FirebaseFirestore.instance
                          .collection('userInfo1')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots()
                          .map(
                            (event) =>
                                event.data()!['homeAddress'] ??
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.location_on_outlined,
                                            color: Color(0xffE99A25),
                                          ),
                                          hintText:
                                              '30 rue Gontier-Patin, Abbeville, France',
                                          hintStyle: TextStyle(fontSize: 14.sp),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 50,
                                      top: 4,
                                      child: Container(
                                        color: Colors.white,
                                        child: Text(
                                          widget.lang == 'en'
                                              ? 'Home Address'
                                              : 'Adresse du domicile',
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff2f2f2f),
                                            // height: 22.h
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffE99A25),
                                    ),
                                    hintText: snapshot.data.toString(),
                                    hintStyle: TextStyle(
                                        fontSize: 14.sp, color: kBlackColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 4,
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    widget.lang == 'en'
                                        ? 'Home Address'
                                        : 'Adresse du domicile',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2f2f2f),
                                      // height: 22.h
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xffE99A25),
                                    ),
                                    hintText:
                                        '30 rue Gontier-Patin, Abbeville, France',
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 4,
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    widget.lang == 'en'
                                        ? 'Home Address'
                                        : 'Adresse du domicile',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff2f2f2f),
                                      // height: 22.h
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
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
                            ? 'Break Timings'
                            : 'Horaires des pauses',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff000000),
                          // height: 22.h
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .15,
                      ),
                      GestureDetector(
                          onTap: () {
                            _displayDialog(context);
                          },
                          child: Image.asset(
                              'assets/images/editprofile_icon.png')),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userInfo1')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('break')
                            .snapshots(),
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.lang == 'en'
                                            ? 'No Time  Selected yet'
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                            IconButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('userInfo1')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('break')
                                                    .doc(ds.id)
                                                    .delete()
                                                    .whenComplete(() =>
                                                        showToastShort(
                                                            widget.lang == 'en'
                                                                ? 'Slot Deleted'
                                                                : 'Emplacement supprimé',
                                                            Colors.red));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                    ;
                                  },
                                  itemCount: dataSnapShot.data!.docs.length,
                                );
                        },
                      ),
                      // StreamBuilder<String>(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('userInfo1')
                      //         .doc(FirebaseAuth.instance.currentUser!.uid)
                      //         .snapshots()
                      //         .map(
                      //           (event) =>
                      //               event.data()!['breakTime'] ??
                      //               Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   SizedBox(
                      //                     height:
                      //                         MediaQuery.of(context).size.height *
                      //                             .01,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.start,
                      //                     children: [
                      //                       Text(
                      //                         'Add Break Timing',
                      //                         style: GoogleFonts.nunitoSans(
                      //                           fontSize: 16.sp,
                      //                           fontWeight: FontWeight.w400,
                      //                           color: Color(0xff646464),
                      //                           // height: 22.h
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //         ),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         return Column(
                      //           // mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             SizedBox(
                      //               height:
                      //                   MediaQuery.of(context).size.height * .01,
                      //             ),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   snapshot.data.toString(),
                      //                   style: GoogleFonts.nunitoSans(
                      //                     fontSize: 16.sp,
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Color(0xff646464),
                      //                     // height: 22.h
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         );
                      //       } else {
                      //         return Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             SizedBox(
                      //               height:
                      //                   MediaQuery.of(context).size.height * .01,
                      //             ),
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   'Add Break Timing',
                      //                   style: GoogleFonts.nunitoSans(
                      //                     fontSize: 16.sp,
                      //                     fontWeight: FontWeight.w400,
                      //                     color: Color(0xff646464),
                      //                     // height: 22.h
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         );
                      //       }
                      //     }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickUImageFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              widget.lang == 'en'
                  ? "Upload Image"
                  : 'Télécharger une image', //item Image
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
                color: kBlackColor,
                // height: 42.h
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: pickUImageFromGallery,
                child: Text(
                  widget.lang == 'en'
                      ? "Gallery"
                      : 'Galerie', //Select From Gallery
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                    // height: 42.h
                  ),
                ),
              ),
              SimpleDialogOption(
                child: Text(
                  widget.lang == 'en' ? "Cancel" : 'Annuler',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor,
                    // height: 42.h
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  showBottomSheet() {
    // var uid = FirebaseAuth.instance.currentUser!.uid;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ListTile(
              //   leading: new Icon(Icons.photo),
              //   title: new Text('Photo'),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: new Icon(
                  Icons.note,
                  color: kOrangeColor,
                ),
                title: new Text(
                  widget.lang == 'en'
                      ? 'Terms & Conditions'
                      : 'Termes et Conditions',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    // height: 22.h
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.privacy_tip,
                  color: kOrangeColor,
                ),
                title: new Text(
                  widget.lang == 'en'
                      ? 'Privacy Policy'
                      : 'Politique de confidentialité',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    // height: 22.h
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.logout_outlined,
                  color: kOrangeColor,
                ),
                title: new Text(
                  widget.lang == 'en' ? 'Logout' : 'Se déconnecter',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    // height: 22.h
                  ),
                ),
                onTap: () async {
                  FirebaseFirestore.instance
                      .collection('userActivity')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'isOnline': false});
                  FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'isOnline': false}).whenComplete(() async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    FirebaseAuth.instance.signOut().whenComplete(() async {
                      // void signOutGoogle() async{
                      await googleSignIn.signOut();
                      sp.remove('email');
                      showToastShort(
                          widget.lang == 'en' ? 'Logged Out' : 'Déconnecté',
                          Colors.red);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => WelcomeScreen(widget.lang)),
                          (route) => false);
                      // Navigator.pushReplacement(
                      //     context, MaterialPageRoute(builder: (_) => LogIn()));
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  TextEditingController breakTimeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  List<String> breakTime = [];
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              widget.lang == 'en' ? 'Add Break Timing' : 'Horaires des pauses',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width * .6,
                      // margin: const EdgeInsets.only(top: 10),

                      decoration: BoxDecoration(
                          color: const Color(0xffE99A25),
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.lang == 'en'
                                ? 'From: $fromTime'
                                : 'Depuis: $fromTime',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xffffffff),
                              // height: 22.h
                            ),
                          )
                        ],
                      ),
                    ),
                    // Within the `FirstRoute` widget
                    onPressed: () {
                      _selectFromTime(context).whenComplete(() {
                        setState(() {
                          fromTime = _fromTime.format(context);
                          print('fromTime');
                          print(fromTime);
                        });
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  ///to
                  MaterialButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width * .6,
                      // margin: const EdgeInsets.only(top: 10),

                      decoration: BoxDecoration(
                          color: const Color(0xffE99A25),
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.lang == 'en'
                                ? 'To: $ToTime'
                                : 'Pour: $ToTime',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xffffffff),
                              // height: 22.h
                            ),
                          )
                        ],
                      ),
                    ),
                    // Within the `FirstRoute` widget
                    onPressed: () {
                      _selectToTime(context).whenComplete(() {
                        setState(() {
                          ToTime = _toTime.format(context);
                          print('ToTime');
                          print(ToTime);
                        });
                      });
                    },
                  ),
                  // TextButton(
                  //   child: Text('To: ${_toTime.format(context)}'),
                  //   onPressed: () => _selectToTime(context),
                  // ),
                  // ElevatedButton(
                  //   child: Text('Show'),
                  //   onPressed: () => _showTimeInterval(context),
                  // ),
                ],
              );
            }),
            actions: [
              TextButton(
                child: new Text(
                  widget.lang == 'en' ? 'Cancel' : 'Annuler',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text(widget.lang == 'en' ? 'SAVE' : 'Sauvegarder'),
                onPressed: () {
                  setState(() {
                    _timeSlots = createTimeSlots(_fromTime, _toTime);
                  });
                  print('_timeSlots');
                  print(_timeSlots.last.minute);
                  // if (_timeSlots.last.minute <= 15) {
                  breakTimeList.add(breakTimeController.text);
                  FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('break')
                      .doc(
                          '${_fromTime.format(context)} - ${_toTime.format(context)}')
                      .set({
                    'breakTime':
                        '${_fromTime.format(context)} - ${_toTime.format(context)}',
                  }).whenComplete(() {
                    showToastShort(
                        widget.lang == 'en'
                            ? 'Saved Changes'
                            : 'Modifications enregistrées',
                        Colors.red);
                    Navigator.of(context).pop();
                  });
                  // } else {
                  //   showToastShort(
                  //       '15 minutes interval is only allowed.\nPlease try interval of 15 minutes',
                  //       Colors.red);
                  // }
                  // _createSlots();
                },
              )
            ],
          );
        });
  }

  TextEditingController occupationController = TextEditingController();
  EditUsername(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Username',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.lang == 'en'
                      ? 'Please enter some text'
                      : 'Veuillez saisir du texte';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0xffE99A25),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                labelText:
                    widget.lang == 'en' ? '    username' : 'nom d\'utilisateur',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: new Text(
                  widget.lang == 'en' ? 'Cancel' : 'Annuler',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: new Text(widget.lang == 'en' ? 'Update' : 'Mise à jour'),
                onPressed: () {
                  // breakTimeList.add(breakTimeController.text);
                  FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'userName': usernameController.text,
                  }).whenComplete(() {
                    showToastShort(
                        widget.lang == 'en'
                            ? 'Saved Changes'
                            : 'Modifications enregistrées',
                        Colors.red);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  EditOccupation(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              widget.lang == 'en'
                  ? 'Edit Occupation'
                  : 'Modifier la profession',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: occupationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.lang == 'en'
                      ? 'Please enter some text'
                      : 'Veuillez saisir du texte';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.sensor_occupied,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0xffE99A25),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                labelText:
                    widget.lang == 'en' ? '    Occupation' : '    Profession',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: new Text(
                  widget.lang == 'en' ? 'Cancel' : 'Annuler',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text(widget.lang == 'en' ? 'Update' : 'Mise à jour'),
                onPressed: () {
                  // breakTimeList.add(breakTimeController.text);
                  FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'occupation': occupationController.text,
                  }).whenComplete(() {
                    showToastShort(
                        widget.lang == 'en'
                            ? 'Saved Changes'
                            : 'Modifications enregistrées',
                        Colors.red);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  EditBio(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              widget.lang == 'en' ? 'Add About me' : 'Ajouter À propos de moi',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: bioController,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.lang == 'en'
                      ? 'Please enter some text'
                      : 'Veuillez saisir du texte';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0xffE99A25),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                labelText:
                    widget.lang == 'en' ? '    Description' : '    Description',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: new Text(
                  widget.lang == 'en' ? 'Cancel' : 'Annuler',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text(widget.lang == 'en' ? 'Update' : 'Mise à jour'),
                onPressed: () {
                  // breakTimeList.add(breakTimeController.text);
                  FirebaseFirestore.instance
                      .collection('userInfo1')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'aboutMe': bioController.text,
                  }).whenComplete(() {
                    showToastShort(
                        widget.lang == 'en'
                            ? 'Saved Changes'
                            : 'Modifications enregistrées',
                        Colors.red);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  TextEditingController workController = TextEditingController();
  // TextEditingController homeController = TextEditingController();
  // EditWorkAddress(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Edit Work Address',
  //             style: GoogleFonts.nunitoSans(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w700,
  //               color: Color(0xff000000),
  //               // height: 22.h
  //             ),
  //           ),
  //           content: Column(
  //             // mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // TextFormField(
  //               //   controller: workController,
  //               //   // maxLines: 2,
  //               //   validator: (value) {
  //               //     if (value == null || value.isEmpty) {
  //               //       return 'Please enter some text';
  //               //     }
  //               //     return null;
  //               //   },
  //               //   style: GoogleFonts.nunitoSans(
  //               //     fontSize: 16.sp,
  //               //     fontWeight: FontWeight.w600,
  //               //     color: Color(0xff000000),
  //               //     // height: 22.h
  //               //   ),
  //               //   decoration: InputDecoration(
  //               //     prefixIcon: Container(
  //               //       margin: const EdgeInsets.all(4),
  //               //       child: Icon(
  //               //         Icons.map,
  //               //         color: Colors.white,
  //               //       ),
  //               //       decoration: BoxDecoration(
  //               //           color: const Color(0xffE99A25),
  //               //           borderRadius: BorderRadius.circular(8.r)),
  //               //     ),
  //               //     labelText: '    Work Address',
  //               //     labelStyle: GoogleFonts.nunitoSans(
  //               //       fontSize: 16.sp,
  //               //       fontWeight: FontWeight.w600,
  //               //       color: Color(0xff000000),
  //               //       // height: 22.h
  //               //     ),
  //               //     border: OutlineInputBorder(
  //               //       borderRadius: BorderRadius.circular(8.r),
  //               //     ),
  //               //   ),
  //               // ),
  //               Container(
  //                 padding:
  //                     const EdgeInsets.only(left: 10, right: 10, bottom: 0),
  //                 child: TextField(
  //                   controller: officeController,
  //                   autofocus: false,
  //                   focusNode: startFocusNode,
  //                   style: GoogleFonts.nunitoSans(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xff646464),
  //                     // height: 22.h
  //                   ),
  //                   decoration: InputDecoration(
  //                       prefixIcon: Icon(
  //                         Icons.location_on_outlined,
  //                         color: Color(0xffE99A25),
  //                       ),
  //                       hintText: 'Enter Work Address',
  //                       hintStyle: GoogleFonts.nunitoSans(
  //                         fontSize: 14.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: Color(0xff646464),
  //                         // height: 22.h
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(10.r),
  //                       ),
  //                       suffixIcon: officeController.text.isNotEmpty
  //                           ? IconButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   predictions = [];
  //                                   officeController.clear();
  //                                 });
  //                               },
  //                               icon: Icon(
  //                                 Icons.clear_outlined,
  //                                 color: Colors.grey,
  //                               ),
  //                             )
  //                           : null),
  //                   onChanged: (value) {
  //                     if (_debounce?.isActive ?? false) _debounce!.cancel();
  //                     _debounce = Timer(const Duration(milliseconds: 1000), () {
  //                       if (value.isNotEmpty) {
  //                         //places api
  //                         autoCompleteSearch(value);
  //                       } else {
  //                         //clear out the results
  //                         setState(() {
  //                           predictions = [];
  //                           startPosition = null;
  //                         });
  //                       }
  //                     });
  //                   },
  //                 ),
  //               ),
  //               ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: BouncingScrollPhysics(),
  //                   itemCount: predictions.length,
  //                   itemBuilder: (context, index) {
  //                     return ListTile(
  //                       leading: CircleAvatar(
  //                         backgroundColor: kGreyColor,
  //                         child: Icon(
  //                           Icons.location_on_outlined,
  //                           color: Color(0xffE99A25),
  //                         ),
  //                       ),
  //                       title: Text(
  //                         predictions[index].description.toString(),
  //                         style: GoogleFonts.nunitoSans(
  //                           fontSize: 14.sp,
  //                           fontWeight: FontWeight.w600,
  //                           color: Color(0xff646464),
  //                           // height: 22.h
  //                         ),
  //                       ),
  //                       onTap: () async {
  //                         final placeId = predictions[index].placeId!;
  //                         final details =
  //                             await googlePlace!.details.get(placeId);
  //                         if (details != null &&
  //                             details.result != null &&
  //                             mounted) {
  //                           if (startFocusNode!.hasFocus) {
  //                             setState(() {
  //                               startPosition = details.result;
  //                               officeController.text = details.result!.name!;
  //                               print('officeController.text');
  //                               print(officeController.text);
  //                               predictions = [];
  //                             });
  //                           } else {
  //                             setState(() {
  //                               startPosition = details.result;
  //                               officeController.text = details.result!.name!;
  //                               predictions = [];
  //                             });
  //                           }
  //
  //                           if (startPosition != null && endPosition != null) {
  //                             print('navigate');
  //                             // Navigator.push(
  //                             //   context,
  //                             //   MaterialPageRoute(
  //                             //     builder: (context) => MapScreen(),
  //                             //   ),
  //                             // );
  //                           }
  //                         }
  //                       },
  //                     );
  //                   }),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               child: new Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             new TextButton(
  //               child: new Text('Update'),
  //               onPressed: () {
  //                 // breakTimeList.add(breakTimeController.text);
  //                 FirebaseFirestore.instance
  //                     .collection('userInfo1')
  //                     .doc(FirebaseAuth.instance.currentUser!.uid)
  //                     .update({
  //                   'officeAddress': officeController.text,
  //                 }).whenComplete(() {
  //                   showToastShort('Saved Changes', Colors.red);
  //                   Navigator.of(context).pop();
  //                 });
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }
  //
  // EditHomeAddress(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Edit Home Address',
  //             style: GoogleFonts.nunitoSans(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w700,
  //               color: Color(0xff000000),
  //               // height: 22.h
  //             ),
  //           ),
  //           content: Column(
  //             children: [
  //               // TextFormField(
  //               //   controller: homeController,
  //               //   // maxLines: 2,
  //               //   validator: (value) {
  //               //     if (value == null || value.isEmpty) {
  //               //       return 'Please enter some text';
  //               //     }
  //               //     return null;
  //               //   },
  //               //   style: GoogleFonts.nunitoSans(
  //               //     fontSize: 16.sp,
  //               //     fontWeight: FontWeight.w600,
  //               //     color: Color(0xff000000),
  //               //     // height: 22.h
  //               //   ),
  //               //   decoration: InputDecoration(
  //               //     prefixIcon: Container(
  //               //       margin: const EdgeInsets.all(4),
  //               //       child: Icon(
  //               //         Icons.maps_home_work,
  //               //         color: Colors.white,
  //               //       ),
  //               //       decoration: BoxDecoration(
  //               //           color: const Color(0xffE99A25),
  //               //           borderRadius: BorderRadius.circular(8.r)),
  //               //     ),
  //               //     labelText: '    Home Address',
  //               //     labelStyle: GoogleFonts.nunitoSans(
  //               //       fontSize: 16.sp,
  //               //       fontWeight: FontWeight.w600,
  //               //       color: Color(0xff000000),
  //               //       // height: 22.h
  //               //     ),
  //               //     border: OutlineInputBorder(
  //               //       borderRadius: BorderRadius.circular(8.r),
  //               //     ),
  //               //   ),
  //               // ),
  //               Container(
  //                 padding:
  //                     const EdgeInsets.only(left: 30, right: 30, bottom: 0),
  //                 child: TextField(
  //                   controller: homeController,
  //                   autofocus: false,
  //                   focusNode: endFocusNode,
  //                   style: GoogleFonts.nunitoSans(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xff646464),
  //                     // height: 22.h
  //                   ),
  //                   decoration: InputDecoration(
  //                       prefixIcon: Icon(
  //                         Icons.location_on_outlined,
  //                         color: Color(0xffE99A25),
  //                       ),
  //                       hintText: 'Enter Home Address',
  //                       hintStyle: GoogleFonts.nunitoSans(
  //                         fontSize: 14.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: Color(0xff646464),
  //                         // height: 22.h
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(10.r),
  //                       ),
  //                       suffixIcon: homeController.text.isNotEmpty
  //                           ? IconButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   predictions2 = [];
  //                                   homeController.clear();
  //                                 });
  //                               },
  //                               icon: Icon(
  //                                 Icons.clear_outlined,
  //                                 color: Colors.grey,
  //                               ),
  //                             )
  //                           : null),
  //                   onChanged: (value) {
  //                     if (_debounce?.isActive ?? false) _debounce!.cancel();
  //                     _debounce = Timer(const Duration(milliseconds: 1000), () {
  //                       if (value.isNotEmpty) {
  //                         //places api
  //                         autoCompleteSearchHome(value);
  //                       } else {
  //                         //clear out the results
  //                         setState(() {
  //                           predictions = [];
  //                           endPosition = null;
  //                         });
  //                       }
  //                     });
  //                   },
  //                 ),
  //               ),
  //               ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: BouncingScrollPhysics(),
  //                   itemCount: predictions2.length,
  //                   itemBuilder: (context, index) {
  //                     return ListTile(
  //                       leading: CircleAvatar(
  //                         backgroundColor: kGreyColor,
  //                         child: Icon(
  //                           Icons.location_on_outlined,
  //                           color: Color(0xffE99A25),
  //                         ),
  //                       ),
  //                       title: Text(
  //                         predictions2[index].description.toString(),
  //                         style: GoogleFonts.nunitoSans(
  //                           fontSize: 14.sp,
  //                           fontWeight: FontWeight.w600,
  //                           color: Color(0xff646464),
  //                           // height: 22.h
  //                         ),
  //                       ),
  //                       onTap: () async {
  //                         final placeId = predictions2[index].placeId!;
  //                         final details =
  //                             await googlePlace!.details.get(placeId);
  //                         if (details != null &&
  //                             details.result != null &&
  //                             mounted) {
  //                           if (endFocusNode!.hasFocus) {
  //                             setState(() {
  //                               endPosition = details.result;
  //                               homeController.text = details.result!.name!;
  //                               print('homeController.text');
  //                               print(homeController.text);
  //                               predictions2 = [];
  //                             });
  //                           } else {
  //                             setState(() {
  //                               endPosition = details.result;
  //                               homeController.text = details.result!.name!;
  //                               predictions2 = [];
  //                             });
  //                           }
  //
  //                           if (startPosition != null && endPosition != null) {
  //                             print('navigate');
  //                             // Navigator.push(
  //                             //   context,
  //                             //   MaterialPageRoute(
  //                             //     builder: (context) => MapScreen(),
  //                             //   ),
  //                             // );
  //                           }
  //                         }
  //                       },
  //                     );
  //                   }),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               child: new Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             new TextButton(
  //               child: new Text('Update'),
  //               onPressed: () {
  //                 // breakTimeList.add(breakTimeController.text);
  //                 FirebaseFirestore.instance
  //                     .collection('userInfo1')
  //                     .doc(FirebaseAuth.instance.currentUser!.uid)
  //                     .update({
  //                   'homeAddress': homeController.text,
  //                 }).whenComplete(() {
  //                   showToastShort('Saved Changes', Colors.red);
  //                   Navigator.of(context).pop();
  //                 });
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  File? imageFile;

  Future<String> uploadCircularImageToFirebase2(
      File imageFile, int size) async {
    // Read the image file into memory
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode the image using the `image` library
    Im.Image? image = Im.decodeImage(imageBytes);

    // Resize the image to fit within a square of the specified size
    Im.Image resizedImage = Im.copyResize(image!, width: size, height: size);

    // Crop the image to a circle
    Im.Image circularImage = Im.copyCropCircle(resizedImage);

    // Encode the circular image as a PNG
    Uint8List? circularImageBytes = Im.encodePng(circularImage) as Uint8List?;

    // Get a reference to the Firebase storage bucket
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef = storage
        .ref()
        .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.png');

    // Upload the circular image to Firebase storage
    await storageRef.putData(circularImageBytes!);

    // Get the download URL of the uploaded circular image
    String downloadURL = await storageRef.getDownloadURL();

    return downloadURL;
  }

  uploadImageAndSaveItemInfo() async {
    // setState(() {
    //   uploading = true;
    // });
    showToastShort(widget.lang == 'en' ? 'Loading' : 'Chargement', Colors.red);
    setState(() {
      isLoadingImage = true;
    });
    // String imageDownloadUrl = await uploadResizedImage(_image!);
    // String imageDownloadUrl = await uploadCircularImageToFirebase(_image!);
    // String imageDownloadUrl = await uploadCircularImageToFirebase(_image!);
    String imageDownloadUrl =
        await uploadCircularImageToFirebase2(_image!, 150);
    // String avtarDownloadUrl = await uploadItemImage(_image!);
    print('uploadImageAndSaveItemInfo');
    print(imageDownloadUrl);
    saveStoreInfo(imageDownloadUrl);
  }

  void saveStoreInfo(String downloadUrl) async {
    print('downloadUrl');
    print(downloadUrl);
    FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "photoUrl": downloadUrl,
      // "avatarUrl": avtarDownloadUrl,
    }).whenComplete(() {
      setState(() {
        isLoadingImage = false;
      });
    });
    // Navigator.pushAndRemoveUntil(
    // context,
    // MaterialPageRoute(builder: (_) => const ()),
    // (route) => false).whenComplete(() {
    setState(() {});
    showToastShort(
        widget.lang == 'en'
            ? 'Information Updated'
            : 'Informations mises à jour',
        Colors.red);
    // });
  }
}
