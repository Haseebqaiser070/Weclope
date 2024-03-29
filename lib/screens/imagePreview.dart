import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wecloppeapp/style/toast.dart';

import '../constant.dart';

class SendImage extends StatefulWidget {
  var myUsername, name, uid, myImg, image;
  File? _image;
  SendImage(this._image, this.uid, this.myUsername, this.name, this.image,
      this.myImg);
  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  @override
  void dispose() {
    super.dispose();
  }

  final picker = ImagePicker();
  bool isLoading = false;
  bool obscureText = true;
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  File? file;
  bool uploading = false;
  String? imageUrl;
  // File? _image;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close_outlined,
            color: kWhiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kGreyColor,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: kGreyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Upload Image
            GestureDetector(
              onTap: () {
                // takeImage(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(widget._image!),
                          fit: BoxFit.fitWidth),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(30.0),
            //     child: RawMaterialButton(
            //       elevation: 0,
            //       fillColor: const Color(0xFF2A99FF),
            //       onPressed: () {
            //         // if (widget._image == null || captionController.text.isEmpty) {
            //         //   showToast(
            //         //       'Fill All Fields');
            //         //   setState(() {
            //         //     isLoading = false;
            //         //   });
            //         // } else {
            //         uploadImageAndSaveItemInfo();
            //         showToastShort('Loading', Colors.red);
            //         // showToast('Loading');
            //         setState(() {
            //           isLoading = true;
            //         });
            //         // }
            //       },
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30.r),
            //       ),
            //       child: SizedBox(
            //         height: 40.h,
            //         width: 154.w,
            //         child: Center(
            //           child: isLoading
            //               ? CircularProgressIndicator()
            //               : Text('Send'),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 75.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: kGreyColor,
        child: CircleAvatar(
          backgroundColor: kOrangeColor,
          child: IconButton(
            onPressed: () {
              uploadImageAndSaveItemInfo();
              showToastShort('Loading', Colors.red);
              // showToast('Loading');
              setState(() {
                isLoading = true;
              });
            },
            icon: isLoading
                ? CircularProgressIndicator()
                : Icon(
                    Icons.send_outlined,
                    color: kGreyColor,
                  ),
          ),
        ),
      ),
    );
  }

  var ds = DateTime.now().toString();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> LikeList = [''];
  void saveStoreInfo(String downloadUrl) async {
    var ds = DateTime.now().toString();
    var docum = 'doc';
    List<String> member = [];
    member.add(FirebaseAuth.instance.currentUser!.uid);
    member.add(widget.uid.toString());

    // myUsername.compareTo(widget.name) > 0
    if (widget.myUsername.hashCode <= widget.name.hashCode) {
      docum = '${widget.myUsername}*${widget.name}';
    } else {
      docum = '${widget.name}*${widget.myUsername}';
    }
    FirebaseFirestore.instance.collection('chatRoom').doc(docum).set({
      'roomId': '${widget.myUsername}*${widget.name}',
      'members': member,
      'recieverImage': widget.image,
      'senderImage': widget.myImg,
      'name': widget.name,
      'uidd': widget.uid,
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
      'message': downloadUrl,
      'isImage': true,
    });

    Navigator.pop(context, downloadUrl);
  }

  ///Image upload
  Future<String> uploadItemImage(mImageFile) async {
    print('uploadItemImage');
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("userChat");

    UploadTask uploadTask =
        storageReference.child("chat_$productId.jpg").putFile(mImageFile);
    //TaskSnapshot taskSnapshot = await uploadTask.onComplete;
    ///todo Have to correct it if image not going to upload on firestore;
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  ///Uploading to firebase;
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(widget._image);
    print('uploadImageAndSaveItemInfo');
    print(imageDownloadUrl);
    saveStoreInfo(imageDownloadUrl);
  }
}
