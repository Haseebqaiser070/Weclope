import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_maps_webservice/places.dart';

const Color kBlackColor = Color(0xff2F2F2F);
const Color kOrangeColor = Color(0xffE99A25);
const Color kGreyColor = Color(0xff646464);
const Color kWhiteColor = Color(0xffffffff);

// bool isEnglish = true;
Future<bool> isEnglish() async {
  bool eng;
  SharedPreferences sp = await SharedPreferences.getInstance();
  eng = sp.getBool('isEnglish')!;
  print('eng');
  print(eng);
  return eng;
}

final TextStyle kHeading1 = GoogleFonts.poppins(
  fontSize: 28.sp,
  fontWeight: FontWeight.w600,
  color: kBlackColor,
  // height: 42.h
);

final TextStyle kHeading1Detials = GoogleFonts.nunitoSans(
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
  color: kBlackColor,
  // height: 22.h
);
// var myUid = FirebaseAuth.instance.currentUser!.uid;
// final places =
//     GoogleMapsPlaces(apiKey: 'AIzaSyCir0UU5rM0ghSPSwvIkoxUskt9DU4E5SM');
