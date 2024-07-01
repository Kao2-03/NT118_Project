import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  // Hàm gửi yêu cầu cập nhật mật khẩu
  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showAlertDialog("Success", "Một email đã được gửi đến địa chỉ của bạn. Vui lòng kiểm tra hộp thư đến để cập nhật mật khẩu.");
    } catch (e) {
      print("Lỗi gửi email cập nhật mật khẩu: $e");
      _showAlertDialog("Error", "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
    }
  }

  // Hàm hiển thị thông báo
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nhập địa chỉ email của bạn để cập nhật mật khẩu:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gửi yêu cầu cập nhật mật khẩu
                _resetPassword(_emailController.text);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15)),
              ),
              child: Text('Gửi yêu cầu',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
