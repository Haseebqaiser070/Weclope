// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../style/toast.dart';
import 'EnterAdressScreen.dart';

class SignUp extends StatefulWidget {
  var lang;
  SignUp(this.lang);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController birthController = TextEditingController();
  bool passwordObscured = true;
  String countryCode = '+33';
  var numberA = '';
  String value = '+234';
  final myController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String initialCountry = 'FR';
  PhoneNumber number = PhoneNumber(isoCode: 'FR');
  bool isOlderThan18 = false;
  DateTime? _selectedDate;
  int? age;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        birthController.text = DateFormat('dd/MM/yyyy').format(picked);
        age = DateTime.now().difference(_selectedDate!).inDays ~/ 365;
      });
    }
  }

  void checkEligibility(DateTime dateOfBirth) {
    // Calculate the age based on the difference between the current date and the date of birth
    final age = DateTime.now().difference(dateOfBirth).inDays ~/ 365;

    // Check if the age is 18 or greater
    if (age >= 18) {
      showToastShort('success', Colors.red);
    } else {
      showToastShort('You are not eligible', Colors.red);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberController.dispose();
    myController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
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
                fit: BoxFit.cover,
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
                  margin: EdgeInsets.only(top: 140),
                  // padding: EdgeInsets.only(bottom: 80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.lang == 'en'
                            ? 'Create an Account'
                            : 'Créer un compte',
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children:  [
                      //     Text('',style: GoogleFonts.nunitoSans(
                      //       fontSize: 14.sp,
                      //       fontWeight: FontWeight.w400,
                      //       color: Color(0xff000000).withOpacity(0.7),
                      //       // height: 22.h
                      //     )),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 16),

                  ///username
                  child: TextFormField(
                    controller: userName,
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
                            border: Border.all(color: Color(0xffe6e6e6)),
                            color: const Color(0xffE99A25),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      labelText: widget.lang == 'en'
                          ? '    Username'
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
                      const EdgeInsets.only(left: 30, right: 30, bottom: 16),

                  ///email
                  child: TextFormField(
                    controller: email,
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
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: const Color(0xffE99A25),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      labelText:
                          widget.lang == 'en' ? '    Email' : '    E-mail',
                      labelStyle: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff646464),
                        // height: 22.h
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 16),

                  ///password
                  child: TextFormField(
                    controller: password,
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
                    obscureText: passwordObscured,
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
                Container(
                  width: 325.w,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),

                    ///number
                    child: InternationalPhoneNumberInput(
                      spaceBetweenSelectorAndTextField: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.lang == 'en'
                              ? 'Please enter some text'
                              : 'Veuillez saisir du texte';
                        }
                        return null;
                      },
                      hintText: widget.lang == 'en' ? 'Number' : 'Nombre',
                      textStyle: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                        // height: 22.h
                      ),
                      onInputChanged: (PhoneNumber number) {
                        print('Number is ${number.phoneNumber}');
                        setState(() {
                          numberA = number.phoneNumber.toString();
                        });
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          showFlags: true,
                          useEmoji: true),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: numberController,
                      formatInput: false,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 0, top: 15.0),

                  ///dob
                  child: TextFormField(
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    controller: birthController,
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
                          Icons.cake,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: const Color(0xffE99A25),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      labelText: widget.lang == 'en'
                          ? '    Select date'
                          : '    Sélectionner une date',
                      hintText: birthController.text.isEmpty
                          ? '    Select date'
                          : birthController.text.substring(0, 10),
                      labelStyle: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff646464),
                        // height: 22.h
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: CheckboxListTile(
                    activeColor: kOrangeColor,
                    title: Text(
                      widget.lang == 'en'
                          ? "Yes, I'm older than 18"
                          : 'Oui, j\'ai plus de 18 ans',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff000000),
                        // height: 22.h
                      ),
                    ),
                    value: isOlderThan18,
                    onChanged: (newValue) {
                      setState(() {
                        isOlderThan18 = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                MaterialButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width * .8,
                      // margin: const EdgeInsets.only(top: 10),

                      decoration: BoxDecoration(
                          color: const Color(0xffE99A25),
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  widget.lang == 'en'
                                      ? 'CREATE ACCOUNT'
                                      : 'Créer un compte',
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
                      if (_formKey.currentState!.validate() && isOlderThan18) {
                        validation(context);
                      }
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);
  bool isLoading = false;
  late UserCredential authResult;
  void submit() async {
    setState(() {
      isLoading = true;
      // actEmail.text = phoneNumber.text + '@gmail.com';
      // print('actEmail.text.toString()');
      // print(actEmail.text.toString());
    });
    try {
      authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {
      String message = widget.lang == 'en'
          ? "Please Check the Internet Connection"
          : 'Veuillez vérifier la connexion Internet';
      if (e.message != null) {
        message = e.message.toString();
      }
      showToastShort(message, Colors.red);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showToastShort(e.toString(), Colors.red);
    }
    // var random = Random().nextInt(99999999);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var obtainedEmail = sp.setString('email', email.text);
    List<dynamic> getBreakTime = [];
    List<String> friendList = [];
    LatLng location = LatLng(0.0, 0.0);
    var fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(authResult.user?.uid)
        .set({
      "userName": userName.text.toString().trim(),
      "userEmail": email.text.toString().trim(),
      "userNumber": numberController.text,
      "userBirth": birthController.text,
      "uid": authResult.user?.uid,
      "userPass": password.text.toString(),
      "occupation": null,
      "photoUrl": 'null',
      'homeAddress': null,
      'officeAddress': null,
      'breakTime': null,
      'aboutMe': null,
      'chatCount' : 0,
      'lat': location.latitude,
      'lng': location.longitude,
      'friendList': friendList,
      'requests': friendList,
      'token': fcmToken,
    });

    await FirebaseFirestore.instance
        .collection('userActivity')
        .doc(authResult.user?.uid)
        .set({
      "userName": userName.text.toString().trim(),
      "userEmail": email.text.toString().trim(),
      "userNumber": numberController.text,
      "userBirth": birthController.text,
      "uid": authResult.user?.uid,
      "userPass": password.text.toString(),
      "occupation": null,
      "photoUrl": null,
      'homeAddress': null,
      'officeAddress': null,
      'breakTime': null,
      'aboutMe': null,
      'lat': null,
      'lng': null,
      'friendList': friendList,
      'isOnline': true,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EnterAdress(widget.lang)),
    );
    setState(() {
      isLoading = false;
    });
  }

  void validation(context) {
    if (email.text.isEmpty &&
        password.text.isEmpty &&
        userName.text.isEmpty &&
        birthController.text.isEmpty &&
        age! < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "All Fields are Empty"
              : 'Tous les champs sont vides'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "Invalid Email"
              : 'Adresse e-mail invalide'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (age! < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "You are not eligible"
              : 'Vous n\'êtes pas éligible'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "Invalid Email"
              : 'Adresse e-mail invalide'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "Invalid Password"
              : 'Mot de passe incorrect'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else if (userName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "Invalid Username"
              : 'Nom d\'utilisateur invalide'),
          duration: Duration(seconds: 3),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'en'
              ? "Password is too short!"
              : 'Le mot de passe est trop court!'),
          duration: Duration(milliseconds: 300),
        ),
      );
    } else {
      submit();
    }
  }
}
