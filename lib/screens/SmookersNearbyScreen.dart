// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecloppeapp/screens/otherProfile.dart';

import '../constant.dart';
import 'ListofSmookersScreen.dart';

class SmookerNearby extends StatefulWidget {
  var lang;
  SmookerNearby(this.lang);

  @override
  State<SmookerNearby> createState() => _SmookerNearbyState();
}

class _SmookerNearbyState extends State<SmookerNearby> {
  Set<Marker> _markers = {};
  List<Marker> _Marker = [];
  List<dynamic> friendList = [];
  Completer<GoogleMapController> _controller = Completer();

  QueryDocumentSnapshot? dsA;
  QueryDocumentSnapshot? dsB;
  Position? position;

  getLoc() async {
    // bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('email', FirebaseAuth.instance.currentUser!.email.toString());
    print('sp email gmailllllllllllllllllllllllll');
    print(sp.get('email'));
    position = await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.high
        );
    print('currentLocation');
    print(position!.latitude);
    print(position!.longitude);
    await FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'lat': position!.latitude,
      'lng': position!.longitude,
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/nav/youMap.png')
        .then((icon) {
      final Marker myLocation = Marker(
        onTap: () {},
        markerId: MarkerId("My Location"),
        position: LatLng(position!.latitude, position!.longitude),
        icon: icon,
      );

      setState(() {
        // _markers.add(marker1);
        // _markers.add(marker2);
        _markers.add(myLocation);
      });
    });
    // }
    //   return CircularProgressIndicator();
    // }
  }

  Future<ui.Image> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final image = await decodeImageFromList(data.buffer.asUint8List());
    return image;
  }

  Future<BitmapDescriptor> _createMarkerIcon(String imagePath) async {
    final uiImage = await _loadImage(imagePath);
    final imageWidth = uiImage.width;
    final imageHeight = uiImage.height;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = Colors.transparent;
    canvas.drawCircle(
      Offset(imageWidth / 2, imageHeight / 2),
      imageWidth / 2,
      paint,
    );
    canvas.drawImage(uiImage, Offset.zero, Paint());
    final ui.Image markerIconImage = await recorder.endRecording().toImage(
          imageWidth,
          imageHeight,
        );
    final ByteData? byteData =
        await markerIconImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromNetwork(
      String imageUrl, int width, int height) async {
    final ui.Image image = await loadImageFromNetwork(imageUrl, 40, 40);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<ui.Image> loadImageFromNetwork(
      String imageUrl, int width, int height) async {
    final Completer<ui.Image> completer = Completer();
    final ImageConfiguration config = createLocalImageConfiguration(context,
        size: Size(width.toDouble(), height.toDouble()));
    final NetworkImage networkImage = NetworkImage(imageUrl);
    final ImageStream stream = networkImage.resolve(config);
    stream.addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
      completer.complete(imageInfo.image);
    }));
    return completer.future;
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAsset(String assetName,
      {int width = 100, int height = 100}) async {
    final ui.Image image = await loadImageFromAsset(assetName);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<ui.Image> loadImageFromAsset(String assetName,
      {int width = 100, int height = 100}) async {
    final Completer<ui.Image> completer = Completer();
    final ImageConfiguration config = createLocalImageConfiguration(context,
        size: Size(width.toDouble(), height.toDouble()));
    final AssetImage assetImage = AssetImage(assetName);
    final ImageStream stream = assetImage.resolve(config);
    stream.addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
      completer.complete(imageInfo.image);
    }));
    return completer.future;
  }

  Future<BitmapDescriptor> getAssetIcon(
      BuildContext context, String assetPath, int width, int height) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(assetPath, width, height);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  GoogleMapController? mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng firstMarkerPosition = LatLng(37.77483, -122.41942);
    LatLng secondMarkerPosition = LatLng(37.3368, -121.8754);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ///map
            position == null
                ? CircularProgressIndicator(
                    color: Colors.black,
                  )
                : _buildMap(FirebaseAuth.instance.currentUser!.uid),

            ///body
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 15, left: 30, right: 20, bottom: 20),
                      height: MediaQuery.of(context).size.height * .15,
                      decoration: BoxDecoration(
                          // color: Colors.white54,
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.r),
                              bottomRight: Radius.circular(25.r))),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<String>(
                              stream: FirebaseFirestore.instance
                                  .collection('userInfo1')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots()
                                  .map(
                                    (event) =>
                                        event.data()!['userName'] ??
                                        Text(
                                          'Hi Jack!',
                                          style: GoogleFonts.poppins(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff2f2f2f),
                                            // height: 22.h
                                          ),
                                        ),
                                  ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data.toString().length > 10
                                      ? Text(
                                          'Hi ${snapshot.data.toString()}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff2f2f2f),
                                            // height: 22.h
                                          ),
                                        )
                                      : Text(
                                          'Hi ${snapshot.data.toString()}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff2f2f2f),
                                            // height: 22.h
                                          ),
                                        );
                                } else {
                                  return const Text('');
                                }
                              }),
                          GestureDetector(
                            // Within the `FirstRoute` widget
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SmookersListScreen(
                                        dsB!, friendList, widget.lang)),
                              );
                            },

                            child: Container(
                              child: Image.asset('assets/images/menu.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Image.asset(
                        'assets/images/Ornament.png',
                        width: 155.w,
                        height: 60.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .16,
                ),
                // Container(
                //   margin: EdgeInsets.only(
                //       top: MediaQuery.of(context).size.height * 0.5),
                //   width: MediaQuery.of(context).size.width * .3,
                //   height: MediaQuery.of(context).size.height * .05,
                //   child: Container(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           'Distance: 1.4km',
                //           style: GoogleFonts.outfit(
                //             fontSize: 12.sp,
                //             fontWeight: FontWeight.w500,
                //             color: Color(0xff212121),
                //             // height: 22.h
                //           ),
                //         )
                //       ],
                //     ),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(30.r)),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          final CameraPosition myLoc = CameraPosition(
              bearing: 0,
              target: LatLng(position!.latitude, position!.longitude),
              // tilt: 59.440717697143555,
              zoom: 12);
          Future<void> _goToTheLake() async {
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(myLoc));
          }

          _goToTheLake();
        },
        child: Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(left: 200),
          padding: EdgeInsets.only(top: 550),
          child: Container(
            width: 69.w,
            height: 69.h,
            child: Icon(
              Icons.location_history,
              size: 45,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50.r)),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(String currentUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userInfo1').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<Set<Marker>>(
            future: _buildMarkers(snapshot.data!.docs, currentUserId, context),
            builder: (context, markerSnapshot) {
              if (markerSnapshot.hasData) {
                final markers = markerSnapshot.data!;
                final initialPosition = markers.isNotEmpty
                    ? position
                    : LatLng(0, 0); // Default position if no markers

                return GoogleMap(
                  compassEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  // zoomGesturesEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 12,
                  ),
                  markers: markers,
                );
              } else if (markerSnapshot.hasError) {
                print('markerSnapshot.error');
                print(markerSnapshot.error);
                // showToastShort('Internet Connectivity Error', Colors.red);
                print('markerSnapshot errorrrrrrrrrrrrr');
                print(markerSnapshot);
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading users.'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Set<Marker>> _buildMarkers(List<QueryDocumentSnapshot> docs,
      String currentUserId, BuildContext context) async {
    final markers = <Marker>{};

    for (final doc in docs) {
      final latitude = doc['lat'] as double;
      final longitude = doc['lng'] as double;
      final photo = doc['photoUrl'];
      final position = LatLng(latitude, longitude);
      print('photo1');
      print(photo);

      if (photo == null) {
        print('null image printed');
      } else {
        print(photo);
      }
      if (currentUserId == FirebaseAuth.instance.currentUser!.uid) {
        myLocation = LatLng(latitude, longitude);
        friendList.addAll(doc['friendList']);
        print(' my friendList');
        print(friendList);
        print('myLocation');
        print(myLocation);
        dsA = doc;
        if (dsA!.id == FirebaseAuth.instance.currentUser!.uid) {
          dsB = dsA;
          print('dsB');
          print(dsB!.id);
        }
        print(dsA!.id);
        print(dsA!.id);
        // ds1 = dsA;
      }
      final isCurrentUser = doc.id == currentUserId;
      final markerIconC = photo == 'null'
          ? await getBitmapDescriptorFromAsset('assets/images/person.png')
          : await MarkerIcon.downloadResizePictureCircle(photo,
              size: 100,
              addBorder: true,
              borderColor: kOrangeColor,
              borderSize: 10);
      print('markerIconC');
      print(markerIconC.toString());
      final marker = Marker(
        onTap: () {
          getVal(doc);
          isCurrentUser
              ? SizedBox()
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OtherProfileScreen(
                          doc, 1, isFriend, dsB!, widget.lang)));
        },
        markerId: MarkerId(doc.id),
        position: position,
        // icon: markerIconC,
        icon: markerIconC,
        infoWindow: InfoWindow(
          title: doc['userName'] as String,
          snippet: doc['userEmail'] as String,
        ),
      );
      markers.add(marker);
    }

    return markers;
  }

  bool isFriend = false;
  LatLng? myLocation;
  getVal(QueryDocumentSnapshot doc) {
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userInfo1')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  myLocation = LatLng(doc['lat'], doc['lng']);
                  print('myLocation');
                  print(myLocation);
                  return SizedBox();
                }).toList(),
              );
          }
        });
  }
}
