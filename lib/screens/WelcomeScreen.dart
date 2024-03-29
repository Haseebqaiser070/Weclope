import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
// import 'package:flutter_badge/flutter_badge.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecloppeapp/screens/LogInScreen.dart';

// import 'package:smooking_app/LogInScreen.dart';

import '../appLocalization.dart';
import '../constant.dart';
import 'SignUpScreen.dart';
// import 'constant.dart';

class WelcomeScreen extends StatefulWidget {
  var lang;
  WelcomeScreen(this.lang);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var address = 'address';
  var address2 = 'address';
  Future<bool>? esEnglish;
  // String? languageCode;
  // var widget.lang;
  isFirstUser() async {
    widget.lang = await LanguagePreferences.getLanguage();
    // .whenComplete(() {
    // languageCode = widget.lang;
    // print('languageCode');
    // print(languageCode);
    // print('widget.lang');
    // print(widget.lang);
    // });
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString('address') != null)
      address = sp.getString('address')!;
    // setState(() {
    //   isEnglish = sp.getBool('isEnglish')!;
    // });

    print('address');
    print(address);
    // print('isEnglish');
    // print(isEnglish);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFirstUser();
    print('isEnglish function');
    // esEnglish = isEnglish();
    print('address');
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
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
                    'assets/nav/logo2.0.png',
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
            // SizedBox(height: MediaQuery.of(context).size.height*.1,),

            Container(
              margin: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.lang == 'en' ? 'Let’s get started' : 'Commençons',
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
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod tempor ',
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
              height: MediaQuery.of(context).size.height * .02,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '. .',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.sp,
                      color: Color(0xffC4C4C4)),
                ),
                Text(
                  ' .',
                  style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffE99A25)),
                )
              ],
            ),

            MaterialButton(
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .8,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lang == 'en'
                            ? 'CREATE ACCOUNT'
                            : 'CRÉER UN COMPTE',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: kWhiteColor,
                          // height: 22.h
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffE99A25),
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                // Within the `FirstRoute` widget
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUp(widget.lang)),
                  );
                  try {
                    await FlutterAppBadger.isAppBadgeSupported();
                    await FlutterAppBadger.updateBadgeCount(2);
                  } catch (e) {
                    print('e.toString()');
                    print(e.toString());
                  }
                }),

            MaterialButton(
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .8,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lang == 'en' ? 'SIGN IN' : 'S\'IDENTIFIER',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff646464),
                          // height: 22.h
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffE6E6E6),
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                // Within the `FirstRoute` widget
                onPressed: () async {
                  try {
                    await FlutterAppBadger.isAppBadgeSupported();
                    await FlutterAppBadger.updateBadgeCount(2);
                  } catch (e) {
                    print('e.toString()');
                    print(e.toString());
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogIn(address, widget.lang)),
                  );
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),

            Text(
              widget.lang == 'en'
                  ? 'Forgot your account?'
                  : 'Vous avez oublié votre compte?',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff000000).withOpacity(0.5),
                // height: 22.h
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
          ],
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fill,
        )),
      ),
    );
  }

  // setBadgeNum(int count, BuildContext context) async {
  //   try {
  //     await FlutterDynamicIcon.setApplicationIconBadgeNumber(count);
  //   } on PlatformException {
  //     print('Exception: Platform not supported');
  //   } catch (e) {
  //     print(e);
  //   }
  //   // To get currently badge number that was set.
  //   int badgeNumber = await FlutterDynamicIcon.getApplicationIconBadgeNumber();
  //   // Quick alert box for acknowledgement
  //   print('sucess hogya');
  // }

}
