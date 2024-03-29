import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecloppeapp/screens/selectLanguage.dart';

import '../constant.dart';
import '../style/toast.dart';
import '../widgets/BottomNavigationBar/bottomNavigationBar.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    getValidation().whenComplete(() => {
          Timer(
            const Duration(seconds: 5),
            () {
              finalEmail == null
                  ? Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => SelectLanguage()))
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => bottomNavigationBar(lang2)));
            },
          )
        });
  }

  Future getValidation() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var obtainedEmail = sp.getString('email');
    var lang = sp.getString('language');
    setState(() {
      finalEmail = obtainedEmail;
      lang2 = lang;
    });
    print('finalEmail');
    print(finalEmail);
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showToastShort('Location Permission Denied', Colors.red);
    } else if (permission == LocationPermission.whileInUse) {
      showToastShort('Location Permission While in use', Colors.red);
    } else if (permission == LocationPermission.always) {
      // Handle permission granted always
      // showToastShort(
      //     'Location Permission Proceed',
      //     Colors.red);
    }
  }

  String? finalEmail;
  String? lang2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOrangeColor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width * .6,
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
          ),
          SizedBox(
            height: 50,
          ),
          CircularProgressIndicator(
            color: kWhiteColor,
          )
        ],
      ),
    );
  }
}
