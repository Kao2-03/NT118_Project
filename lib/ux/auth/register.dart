import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/ui/authentication/signin_page.dart';

class Register {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register(BuildContext context, String username, String email, String password, String confirmPassword) async {
    try {
      // Kiểm tra xem email đã tồn tại trong Firestore chưa
      bool emailExists = await _isEmailExists(email);
      if (emailExists) {
        _showDialog(context, "Địa chỉ email đã được sử dụng bởi một tài khoản khác");
        return;
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        Map<String, dynamic> userData = {
          'name': username,
          'email': email,
          'password': password,
          'img_Link': null,
        };

        // Thêm thông tin người dùng vào Firestore
        await _firestore.collection('users').doc(user.uid).set(userData);

        _showDialog(context, "Đăng ký thành công!");
        await Future.delayed(Duration(seconds: 5)); // Đợi 10 giây trước khi điều hướng
        _navigateToSignin(context); // Điều hướng sang trang đăng nhập sau khi đăng ký thành công
      } else {
        _showDialog(context, "Đăng ký không thành công");
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        _showDialog(context, "Địa chỉ email đã được sử dụng bởi một tài khoản khác");
      } else {
        _showDialog(context, "Lỗi đăng ký: $error");
      }
    } catch (error) {
      _showDialog(context, "Lỗi đăng ký: $error");
    }
  }

  Future<bool> _isEmailExists(String email) async {
    QuerySnapshot query = await _firestore.collection('users').where('email', isEqualTo: email).get();
    return query.docs.isNotEmpty;
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

void _navigateToSignin(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => SignIn()), // Chuyển đến trang đăng nhập
  );
}
