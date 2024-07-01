import 'dart:async';
import 'package:flutter_project/ui/authentication/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_project/constants.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Chuyển đến trang đăng nhập sau 10 giây
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 10), () {
        _navigateToLogin();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(
                image: 'assets/images/pic3.jpg',
                title: Constants.titleOne,
                description:Constants.descriptionOne,
              ),
            ],
          ),
          Positioned(
            bottom: 70,
            right: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _navigateToLogin();
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa nút mũi tên và chữ "Skip"
                InkWell(
                  onTap: () {
                    _navigateToLogin();
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm để chuyển đến trang đăng nhập
  void _navigateToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignIn()));
  }
}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const createPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 350,
            child: Image.asset(image),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Italianno',
              color: Constants.primaryColor,
              fontSize: 70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}