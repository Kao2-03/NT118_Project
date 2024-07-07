import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/ui/cart/profile_pic.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserPage extends StatefulWidget {
  static String userId = 'NgSNTazXm2ZTG3NAjWrGeMr82Yx1';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _userDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(UserPage.userId) 
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _userDoc,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Connection error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
            children: [
              ProfilePic(),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  showCursor: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFFF5F6F9),
                    hintText: data['fullName']??'',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  showCursor: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFFF5F6F9),
                    hintText: data['email']??'' ,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  showCursor: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFFF5F6F9),
                    hintText: data['password']??'',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(150, 60)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF653A6)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Save Change',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(150, 60)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
                    ),
                    onPressed: () {},
                    child: Text(
                      'log out',
                      style: TextStyle(color: Colors.red),
                    )),
              ),
            ],
          );
          }),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Profile',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          // hàm xử lí logic
          print('Lonely Pony');
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}
