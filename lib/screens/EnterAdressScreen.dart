// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../widgets/BottomNavigationBar/bottomNavigationBar.dart';

class EnterAdress extends StatefulWidget {
  var lang;
  EnterAdress(this.lang);

  @override
  State<EnterAdress> createState() => _EnterAdressState();
}

class _EnterAdressState extends State<EnterAdress> {
  // final _startSearchFieldController = TextEditingController();
  // final _endSearchFieldController = TextEditingController();

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
  // // final places =
  // //     GoogleMapsPlaces(apiKey: 'AIzaSyCir0UU5rM0ghSPSwvIkoxUskt9DU4E5SM');
  // TextEditingController _controller = TextEditingController();
  // List<dynamic> _predictions = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Container(
            // height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .11,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * .18,
                  width: MediaQuery.of(context).size.width * .33,
                  margin: EdgeInsets.only(
                    top: 70,
                  ),
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * .17,
                        width: MediaQuery.of(context).size.width * .32,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFEFDC),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height * .14,
                //   width: MediaQuery.of(context).size.width * .27,
                //   padding: const EdgeInsets.all(25),
                //   decoration: BoxDecoration(
                //     color: const Color(0xffFFEFDC),
                //     borderRadius: BorderRadius.circular(30.r),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         child: Image.asset('assets/images/Vector.png'),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .16,
                ),
                Container(
                  // margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter your Address',
                        style: GoogleFonts.poppins(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor,
                          // height: 42.h
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing\nelit, sed do eiusmod tempor ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000).withOpacity(0.7),
                              // height: 22.h
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        'Enter Work Address',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2f2f2f),
                          // height: 22.h
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                  child: TextField(
                    controller: officeController,
                    autofocus: false,
                    focusNode: startFocusNode,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff646464),
                      // height: 22.h
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xffE99A25),
                        ),
                        hintText: 'Enter Work Address',
                        hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff646464),
                          // height: 22.h
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        suffixIcon: officeController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    predictions = [];
                                    officeController.clear();
                                  });
                                },
                                icon: Icon(
                                  Icons.clear_outlined,
                                  color: Colors.grey,
                                ),
                              )
                            : null),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        if (value.isNotEmpty) {
                          //places api
                          autoCompleteSearch(value);
                        } else {
                          //clear out the results
                          setState(() {
                            predictions = [];
                            startPosition = null;
                          });
                        }
                      });
                    },
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kGreyColor,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Color(0xffE99A25),
                          ),
                        ),
                        title: Text(
                          predictions[index].description.toString(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff646464),
                            // height: 22.h
                          ),
                        ),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details =
                              await googlePlace!.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            if (startFocusNode!.hasFocus) {
                              setState(() {
                                startPosition = details.result;
                                officeController.text = details.result!.name!;
                                print('officeController.text');
                                print(officeController.text);
                                predictions = [];
                              });
                            } else {
                              setState(() {
                                startPosition = details.result;
                                officeController.text = details.result!.name!;
                                predictions = [];
                              });
                            }

                            if (startPosition != null && endPosition != null) {
                              print('navigate');
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MapScreen(),
                              //   ),
                              // );
                            }
                          }
                        },
                      );
                    }),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        'Enter Home Address',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2f2f2f),
                          // height: 22.h
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                  child: TextField(
                    controller: homeController,
                    autofocus: false,
                    focusNode: endFocusNode,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff646464),
                      // height: 22.h
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xffE99A25),
                        ),
                        hintText: 'Enter Home Address',
                        hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff646464),
                          // height: 22.h
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        suffixIcon: homeController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    predictions2 = [];
                                    homeController.clear();
                                  });
                                },
                                icon: Icon(
                                  Icons.clear_outlined,
                                  color: Colors.grey,
                                ),
                              )
                            : null),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        if (value.isNotEmpty) {
                          //places api
                          autoCompleteSearchHome(value);
                        } else {
                          //clear out the results
                          setState(() {
                            predictions = [];
                            endPosition = null;
                          });
                        }
                      });
                    },
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: predictions2.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kGreyColor,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Color(0xffE99A25),
                          ),
                        ),
                        title: Text(
                          predictions2[index].description.toString(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff646464),
                            // height: 22.h
                          ),
                        ),
                        onTap: () async {
                          final placeId = predictions2[index].placeId!;
                          final details =
                              await googlePlace!.details.get(placeId);
                          if (details != null &&
                              details.result != null &&
                              mounted) {
                            if (endFocusNode!.hasFocus) {
                              setState(() {
                                endPosition = details.result;
                                homeController.text = details.result!.name!;
                                print('homeController.text');
                                print(homeController.text);
                                predictions2 = [];
                              });
                            } else {
                              setState(() {
                                endPosition = details.result;
                                homeController.text = details.result!.name!;
                                predictions2 = [];
                              });
                            }

                            if (startPosition != null && endPosition != null) {
                              print('navigate');
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MapScreen(),
                              //   ),
                              // );
                            }
                          }
                        },
                      );
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Container(
                  height: 85,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Image.asset('assets/images/map.png')),
                          Container(
                            width: MediaQuery.of(context).size.width * .49,
                            margin: EdgeInsets.only(top: 5, left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Allons-y',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff212121),
                                        // height: 22.h
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Smokers with Nearest Locations',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff797979),
                                        // height: 22.h
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                              child: Container(
                                // padding: EdgeInsets.all(10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                              // Within the `FirstRoute` widget
                              onPressed: () async {
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                sp.setString('address', homeController.text);
                                var addressss = sp.get('address');
                                print('addressss');
                                print(addressss);
                                var uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                if (_formKey.currentState!.validate()) {
                                  FirebaseFirestore.instance
                                      .collection('userInfo1')
                                      .doc(uid)
                                      .update({
                                    'homeAddress': homeController.text,
                                    'officeAddress': officeController.text,
                                  }).whenComplete(() async {
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const bottomNavigationBar(), (route) => false),
                                    // );
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => bottomNavigationBar(
                                                widget.lang)),
                                        (route) => false);
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<List<dynamic>> getPlaces(String query) async {
  //   final apiKey = 'AIzaSyCir0UU5rM0ghSPSwvIkoxUskt9DU4E5SM';
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=address&components=country:us&key=$apiKey&sessiontoken=$_sessionToken';
  //   final headers = {'Content-Type': 'application/json'};
  //   final response = await getResponse(url, headers);
  //   final predictions = jsonDecode(response.body)['predictions'];
  //   return predictions;
  // }
  //
  // Future<String> generateSessionToken() async {
  //   final configData = await rootBundle.loadString('assets/config.json');
  //   final config = json.decode(configData);
  //   final projectId = config['project_id'];
  //
  //   final tokenUrl = 'https://www.googleapis.com/auth/gmail.readonly';
  //
  //   final response = await getResponse(tokenUrl, {
  //     HttpHeaders.authorizationHeader: 'Bearer ${await getAccessToken()}',
  //     HttpHeaders.contentTypeHeader: 'application/json'
  //   });
  //
  //   final tokenJson = json.decode(response.body);
  //
  //   final sessionToken =
  //       '${tokenJson['token_type']} ${tokenJson['access_token']} $projectId';
  //   return sessionToken;
  // }
  //
  // Future<String> getAccessToken() async {
  //   final configData = await rootBundle.loadString('assets/config.json');
  //   final config = json.decode(configData);
  //   final clientId = config['client_id'];
  //   final clientSecret = config['client_secret'];
  //
  //   final tokenUrl = 'https://accounts.google.com/o/oauth2/token';
  //
  //   final response = await getResponse(tokenUrl, {
  //     HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
  //   }, body: {
  //     'client_id': clientId,
  //     'client_secret': clientSecret,
  //     'grant_type': 'client_credentials'
  //   });
  //
  //   final tokenJson = json.decode(response.body);
  //   return tokenJson['access_token'];
  // }
  //
  // Future<http.Response> getResponse(String url, Map<String, String> headers,
  //     {Map<String, String>? body}) async {
  //   final httpClient = http.Client();
  //   try {
  //     final response = await httpClient.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );
  //     return response;
  //   } finally {
  //     httpClient.close();
  //   }
  // }
}
