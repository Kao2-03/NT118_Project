import 'package:flutter_project/ui/authentication/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ux/auth/auth_service.dart';
import 'homepage.dart';
import 'register_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _usernameValid = false;
  bool _passwordValid = false;
  bool _rememberMe = false;
  bool _showPassword = false;
  late final AuthService _authService;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _authService = AuthService(); // Khởi tạo AuthService
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('rememberMe') ?? false) {
      setState(() {
        _usernameController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
        _rememberMe = true;
      });
    }
  }

  void _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty; // Bạn có thể thêm các quy tắc kiểm tra mật khẩu khác ở đây nếu cần
  }

  Future<void> _handleLogin() async {
    setState(() {
      _usernameValid = _isValidEmail(_usernameController.text);
      _passwordValid = _isValidPassword(_passwordController.text);
    });

    if (_usernameValid && _passwordValid) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );
        // Đăng nhập thành công
        _saveUserInfo();
        _navigateToHome(context);
      } catch (e) {
        _showAlertDialog("Thông báo", "Email hoặc mật khẩu không đúng");
      }
    } else {
      _showAlertDialog("Thông báo", "Vui lòng nhập đầy đủ và hợp lệ email và mật khẩu");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              Constants.titleTwo,
              style: TextStyle(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Constants.titleThree,
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Constants.basicColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    Constants.titleFour,
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Constants.kemColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 50.sp,
                color: Constants.basicColor,
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Nhập email',
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
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
            SizedBox(height: 10.h),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                const Text(
                  'Ghi nhớ tài khoản',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _navigateToForgotPassword(context);
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15.h)),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.grey),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'Hoặc đăng nhập bằng',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.facebook, Colors.blue, _signInWithFacebook),
                SizedBox(width: 20.w),
                _buildSocialIcon(FontAwesomeIcons.google, Colors.red, _signInWithGoogle),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bạn chưa có tài khoản?',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton.icon(
                  onPressed: () {
                    _navigateToRegister(context);
                  },
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: const Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
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

  Widget _buildSocialIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 40.sp,
        color: color,
      ),
    );
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword()));
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterForm()));
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Hàm đăng nhập bằng Google
  void _signInWithGoogle() async {
    try {
      // Gọi hàm signInWithGoogle từ AuthService
      final userCredential = await _authService.signInWithGoogle();

      // Hiển thị popup thông báo đăng nhập thành công
      _showAlertDialog("Success", "Đăng nhập thành công");

      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Google: $e");
      // Hiển thị popup thông báo lỗi
      _showAlertDialog("Error", "Đăng nhập bằng Google thất bại\nLỗi đăng nhập: $e");
    }
  }

  // Hàm xử lý đăng nhập bằng Facebook
  void _signInWithFacebook() async {
    try {
      // Gọi hàm signInWithFacebook từ AuthService
      final userCredential = await _authService.signInWithFacebook();

      // Hiển thị popup thông báo đăng nhập thành công
      _showAlertDialog("Success", "Đăng nhập thành công");

      // Nếu đăng nhập thành công, chuyển đến trang Home
      _navigateToHome(context);
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Facebook: $e");
      // Hiển thị popup thông báo lỗi
      _showAlertDialog("Error", "Đăng nhập bằng Facebook thất bại\nLỗi đăng nhập: $e");
    }
  }
}
