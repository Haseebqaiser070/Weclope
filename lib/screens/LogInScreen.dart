import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:smooking_app/BottomNavigationBar/bottomNavigationBar.dart';
// import 'package:smooking_app/SignUpScreen.dart';

import '../constant.dart';
import '../models/userModel.dart';
import '../style/toast.dart';
import '../widgets/BottomNavigationBar/bottomNavigationBar.dart';
import 'EnterAdressScreen.dart';
import 'SignUpScreen.dart';

class LogIn extends StatefulWidget {
  var isAddress;
  var lang;
  LogIn(this.isAddress, this.lang);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool passwordObscured = true;
  // var loc = 'loc';
  // bool passwordObscured = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  late UserCredential authResult;
  // ignore: non_constant_identifier_names
  bool Loading = false;
  void submit() async {
    setState(() {
      Loading = true;
    });
    try {
      authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passcontroller.text);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('email', emailController.text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => bottomNavigationBar(widget.lang)));
    } on PlatformException catch (e) {
      String message = widget.lang == 'en'
          ? "Please Check the Internet Connection"
          : 'Veuillez vérifier la connexion Internet';
      if (e.message != null) {
        message = e.message.toString();
        print('message');
        print(message);
      }
      showToastShort(message, Colors.red);

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(message.toString()),
      // ));
      setState(() {
        Loading = false;
      });
    } catch (e) {
      showToastShort(
          widget.lang == 'en'
              ? 'Wrong email or password'
              : 'Mauvais email ou mot de passe',
          Colors.red);
      print('e.toString()');
      print(e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
      setState(() {
        Loading = false;
      });
    }

    setState(() {
      Loading = false;
    });
  }

  void validation(context) {
    if (emailController.text.isEmpty && passcontroller.text.isEmpty) {
      showToastShort(
          widget.lang == 'en'
              ? 'Invalid Credentials'
              : 'Les informations d\'identification invalides',
          Colors.red);
    } else if (emailController.text.isEmpty) {
      showToastShort(
          widget.lang == 'en'
              ? 'Invalid Credentials'
              : 'Les informations d\'identification invalides',
          Colors.red);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Invalid Empty"),
      //     duration: Duration(milliseconds: 300),
      //   ),
      // );
    }
    // else if (phonecontroller.text.length < 11) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("PhoneNumber Length must be 11 digits"),
    //       duration: Duration(milliseconds: 300),
    //     ),
    //   );
    // }
    else if (passcontroller.text.isEmpty) {
      showToastShort(
          widget.lang == 'en'
              ? 'Invalid Credentials'
              : 'Les informations d\'identification invalides',
          Colors.red);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Invalid Empty"),
      //     duration: Duration(milliseconds: 300),
      //   ),
      // );
    } else {
      submit();
    }
  }

  ///google Login
  bool isLoadGoogle = false;
  // var address;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  Future<User?> _googleSignIn(BuildContext context) async {
    // Scaffold.of(context).showSnackBar(new SnackBar(
    //   content: new Text('Sign in'),
    // ));
    setState(() {
      isLoadGoogle = true;
    });
    final GoogleSignInAccount? googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDetails providerInfo =
        new ProviderDetails(userDetails.credential!.providerId);

    // ignore: deprecated_member_use
    List<ProviderDetails> providerData = <ProviderDetails>[];
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(
      userDetails.credential!.providerId,
      userDetails.user!.displayName!,
      userDetails.user!.displayName!,
      userDetails.user!.email!,
      providerData,
    );

    try {
      await FirebaseFirestore.instance
          .collection('userInfo1')
          .doc(userDetails.user!.uid)
          .update({
        'uid': userDetails.user!.uid,
      }).whenComplete(() {
        print('try call');
        print('try call');
        // if()
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (ctx) => bottomNavigationBar()));
      });
    } catch (e) {
      print('errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      print(e);
      // var random = Random().nextInt(99999999);

      List<dynamic> getBreakTime = [];
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('email', userDetails.user!.email.toString());

      // print('addresssssssssssssssss');
      // print(address);
      // print('sp email gmailllllllllllllllllllllllll');
      print(sp.get('email'));
      List<String> friendList = [];
      LatLng location = LatLng(0.0, 0.0);
      var fcmToken = await FirebaseMessaging.instance.getToken();
      print('fcmToken');
      print(fcmToken);
      await FirebaseFirestore.instance
          .collection('userInfo1')
          .doc(userDetails.user!.uid)
          .set({
        'userEmail': userDetails.user!.email.toString().trim(),
        'uid': userDetails.user!.uid,
        "userNumber": null,
        "userBirth": null,
        'userName': userDetails.user!.displayName.toString().trim(),
        'photoUrl': userDetails.user!.photoURL.toString(),
        "occupation": null,
        'homeAddress': null,
        'officeAddress': null,
        'breakTime': null,
        'aboutMe': null,
        'lat': location.latitude,
        'lng': location.longitude,
        'friendList': friendList,
        'requests': friendList,
        'token': fcmToken,
        // 'isOnline': true,
      }).whenComplete(() async {
        await FirebaseFirestore.instance
            .collection('userActivity')
            .doc(userDetails.user!.uid)
            .set({
          'userEmail': userDetails.user!.email.toString().trim(),
          'uid': userDetails.user!.uid,
          "userNumber": null,
          "userBirth": null,
          'userName': userDetails.user!.displayName.toString().trim(),
          'photoUrl': userDetails.user!.photoURL.toString(),
          "occupation": null,
          'homeAddress': null,
          'officeAddress': null,
          'breakTime': null,
          'aboutMe': null,
          'lat': null,
          'lng': null,
          'friendList': friendList,
          'isOnline': true,
        });
        setState(() {
          isLoadGoogle = false;
          // address = sp.get('address');
          // loc = isFirstUser() as String;
          // print('loc pre');
          // print(loc);
          // print('address');
          // print(address);
          // print('loc');
          // print(loc);
        });
      });
    }

    setState(() {
      isLoadGoogle = false;
      // loc = isFirstUser() as String;
      // print('loc post');
      // print(loc);
    });
    // print('address');
    // print(loc);
    widget.isAddress == 'address'
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => EnterAdress(widget.lang)))
        : Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => bottomNavigationBar(widget.lang)));
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => bottomNavigationBar(),
    //     ),
    //     (route) => false);
    return userDetails.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill,
              ),
            ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * .09,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lang == 'en' ? 'Sign in' : 'S\'identifier',
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
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: TextFormField(
                    controller: emailController,
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
                        child: Image.asset('assets/images/user.png'),
                        decoration: BoxDecoration(
                            color: const Color(0xffE99A25),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      labelText: widget.lang == 'en'
                          ? '    username'
                          : '    Nom d\'utilisateur',
                      labelStyle: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff646464),
                        // height: 22.h
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: TextFormField(
                    controller: passcontroller,
                    obscureText: passwordObscured,
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
                        child: Image.asset('assets/images/lock.png'),
                        decoration: BoxDecoration(
                            color: const Color(0xffE99A25),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      labelText: widget.lang == 'en'
                          ? '    Password'
                          : '    Mot de passe',
                      labelStyle: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff646464),
                        // height: 22.h
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordObscured = !passwordObscured;
                          });
                        },
                        icon: Icon(
                          passwordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kOrangeColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      validation(context);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width * .8,
                    // margin: const EdgeInsets.only(top: 10),

                    decoration: BoxDecoration(
                        color: const Color(0xffE99A25),
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.lang == 'en' ? 'SIGN IN' : 'S\'IDENTIFIER',
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
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Text(
                  widget.lang == 'en'
                      ? 'Or Sign in with'
                      : 'Ou connectez-vous avec',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff505050),
                    // height: 22.h
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _googleSignIn(context);
                      },
                      child: isLoadGoogle
                          ? CircularProgressIndicator(color: Colors.black)
                          : Image.asset(
                              'assets/images/Google.png',
                              width: 36,
                              height: 36,
                            ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * .07,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     ///facebook Login
                    //   },
                    //   child: Image.asset(
                    //     'assets/images/fb.png',
                    //     width: 36,
                    //     height: 36,
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lang == 'en'
                            ? 'Don’t have an account? '
                            : 'Vous n\'avez pas de compte? ',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000).withOpacity(0.5),
                          // height: 22.h
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignUp(widget.lang)));
                        },
                        child: Text(
                          widget.lang == 'en'
                              ? 'Signup here'
                              : 'Inscrivez-vous ici',
                          style: GoogleFonts.nunitoSans(
                            decoration: TextDecoration.underline,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: kOrangeColor,
                            // height: 22.h
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
