import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:wecloppeapp/style/toast.dart';

import '../../screens/FriendsScreen.dart';
import '../../screens/NotificationScreen.dart';
import '../../screens/ProfileScreen.dart';
import '../../screens/SmookersNearbyScreen.dart';
import '../../screens/conversationScreen.dart';

class bottomNavigationBar extends StatefulWidget {
  var lang;
  bottomNavigationBar(this.lang);

  // final RouteLogin=true;
  @override
  bottomNavigationBarState createState() => bottomNavigationBarState();
}

class bottomNavigationBarState extends State<bottomNavigationBar> {
  // @override
  var smallHeading = 15.0;
  var largeHeading = 20.0;
  static var selectedIndex = 2;
  int notificationCount = 0;
  int requestCount = 0;
  int chatCount = 0;

  // String? lang2;

  isOnline() async {
    print("Is onineeeeeeeeee");
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      FirebaseFirestore.instance
          .collection('userInfo1')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': true});
      // var lang = LanguagePreferences.getLanguage();
      // setState(() {
      //   lang2 = lang;
      // });
    } else {
      showToastShort('No Internet Connection', Colors.red);
    }
  }

  getChatCount() async {
    var user = FirebaseAuth.instance.currentUser!.uid;

    print("Userrrr iddddddd" + user.toString());

    var userData = await FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(user)
        .get();

    int count = userData['chatCount'];

    chatCount = count;

    print("Chatttttttttt Lengthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh" +
        chatCount.toString());
    setState(() {});
    return count;
  }

  getRequestCount() async {
    var user = FirebaseAuth.instance.currentUser!.uid;

    print("Userrrr iddddddd" + user.toString());

    int count = await FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(user)
        .collection('requests')
        .where('status', isEqualTo: 'sent')
        .get()
        .then((value) => value.size);

    requestCount = count;

    print("Requesttttttt Lengthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh" +
        requestCount.toString());
    setState(() {});
    return count;
  }

  getNotificationData() async {
    var user = FirebaseAuth.instance.currentUser!.uid;

    print("Userrrr iddddddd" + user.toString());

    int count = await FirebaseFirestore.instance
        .collection('userInfo1')
        .doc(user)
        .collection('notifications')
        .get()
        .then((value) => value.size);

    notificationCount = count;

    print("Document Lengthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh" +
        notificationCount.toString());
    setState(() {});
    return count;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationData();
    getRequestCount();
    getChatCount();
    isOnline();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      FriendsScreen(widget.lang),
      ConversationListScreens(widget.lang),
      SmookerNearby(widget.lang),
      NotificationScreen(widget.lang),
      ProfileScreen(widget.lang),
    ];
    bool showHome = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !showHome,
        child: GestureDetector(
          onTap: () {
            print('pressed');
            // setState(() {
            //   selectedIndex == 2;
            // });
            _onTap(2);
            _widgetOptions.elementAt(2);
          },
          child: Container(
            height: 70.h,
            width: 70.w,
            child: Image.asset('assets/images/home.png'),
            decoration: BoxDecoration(
                color: Color(0xffE99A25),
                borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        // color: Colors.black,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            unselectedItemColor: Color(0xffE99A25).withOpacity(0.4),
            selectedItemColor: Color(0xffE99A25),
            onTap: _onTap,
            currentIndex: selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: '',
                icon: selectedIndex == 0
                    ? Image.asset(
                        'assets/nav/friendS.png',
                        width: 26,
                      )
                    : requestCount == 0
                        ? Image.asset('assets/nav/FriendsU.png')
                        : Container(
                            child: Stack(
                              children: [
                                Image.asset('assets/nav/FriendsU.png'),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        requestCount.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: selectedIndex == 1
                    ? Image.asset(
                        'assets/nav/chatS.png',
                        width: 26,
                      )
                    : chatCount == 0
                        ? Image.asset(
                            'assets/nav/chat_iconU.png',
                            width: 26,
                          )
                        : Container(
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/nav/chat_iconU.png',
                                  width: 26,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        chatCount.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                // label: "Basket"
              ),
              BottomNavigationBarItem(
                icon: SizedBox(),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: selectedIndex == 3
                    ? Image.asset(
                        'assets/nav/bellS.png',
                        width: 26,
                      )
                    : notificationCount == 0
                        ? Image.asset(
                            'assets/nav/notification_iconU.png',
                            width: 26,
                          )
                        : Container(
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/nav/notification_iconU.png',
                                  width: 26,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        notificationCount.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                // : Image.asset(
                //     'assets/nav/notification_iconU.png',
                //     width: 26,
                //   ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: selectedIndex == 4
                    ? Image.asset(
                        'assets/nav/profileS.png',
                        width: 26,
                      )
                    : Image.asset(
                        'assets/nav/profile_iconU.png',
                        width: 26,
                      ),
                label: "",
              ),
            ],
          ),
        ),
      ),
      body: _widgetOptions.elementAt(selectedIndex),
    );
  }

  void _onTap(int index) {
    selectedIndex = index;
    setState(() {});
  }
}
