import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController _passwordController;
  bool _passwordValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập Nhật Mật Khẩu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Icon(
              FontAwesomeIcons.lock,
              size: 100,
              color: Colors.yellow,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Nhập mật khẩu mới:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu mới của bạn',
              ),
              onChanged: (value) {
                setState(() {
                  _passwordValid = value.length >= 8;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _passwordValid ? _updatePassword : null,
              child: const Text('Cập Nhật Mật Khẩu'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePassword() async {
    try {
      // Lấy reference đến collection "users"
      CollectionReference users = FirebaseFirestore.instance.collection('user');

      // Thực hiện cập nhật mật khẩu cho người dùng có email tương ứng
      QuerySnapshot<Object?> snapshot = await users.where('email', isEqualTo: widget.email).get();
      if (snapshot.docs.isNotEmpty) {
        String userId = snapshot.docs.first.id;
        await users.doc(userId).update({'password': _passwordController.text}); // Cập nhật trường mật khẩu

        // Hiển thị thông báo cập nhật mật khẩu thành công
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thông báo'),
            content: const Text('Cập nhật mật khẩu thành công'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Xử lý trường hợp không tìm thấy người dùng với địa chỉ email đã cho
        print('User not found for email: ${widget.email}');
      }
    } catch (e) {
      // Xử lý các trường hợp ngoại lệ
      print('Error: $e');
    }
  }
}