import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_project/ux/auth/register.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final Register _register;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _usernameValid = true;
  bool _passwordValid = true;
  bool _emailValid = true;
  bool _confirmPasswordValid = true;
  bool _showPassword = false;
  bool _showConfirmPasswordError = false;

  @override
  void initState() {
    super.initState();
    _register = Register();
  }

  bool _isPasswordStrong(String password) {
    RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void _registerUser(BuildContext context) {
    setState(() {
      _usernameValid = _usernameController.text.isNotEmpty;
      _passwordValid = _isPasswordStrong(_passwordController.text);
      _emailValid = _emailController.text.isNotEmpty;
      _confirmPasswordValid = _confirmPasswordController.text.isNotEmpty && _confirmPasswordController.text == _passwordController.text;
      _showConfirmPasswordError = _confirmPasswordController.text.isNotEmpty && !_confirmPasswordValid;
    });

    // Kiểm tra và hiển thị lỗi mật khẩu không khớp
    if (!_confirmPasswordValid) {
      setState(() {
        _showConfirmPasswordError = true;
      });
      return;
    }

    if (_usernameValid && _passwordValid && _emailValid) {
      _register.register(
        context,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              Constants.titleTwo,
              style:  TextStyle(
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  Constants.titleThree,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Constants.basicColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 8),
                Text(
                  Constants.titleFour,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Constants.kemColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 70, color: Constants.basicColor),
              ],
            ),
            const SizedBox(height: 50.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Tên người dùng',
                hintText: 'Nhập tên người dùng',
                errorText: !_usernameValid ? 'Vui lòng nhập tên người dùng' : null,
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword && true,
              onChanged: (value) {
                setState(() {
                  _passwordValid = _isPasswordStrong(value);
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                errorText: !_passwordValid ? 'Mật khẩu ít nhất 8 kí tự bao gồm ít nhất một chữ và một số, không chứa khoảng trắng và kí tự đặc biệt' : null,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_showPassword && true,
              onChanged: (_) {
                setState(() {
                  _showConfirmPasswordError = false;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Xác nhận mật khẩu',
                errorText: _showConfirmPasswordError ? 'Mật khẩu không khớp' : null,
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Nhập email',
                errorText: !_emailValid ? 'Vui lòng nhập email' : null,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => _registerUser(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15)),
                    ),
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
