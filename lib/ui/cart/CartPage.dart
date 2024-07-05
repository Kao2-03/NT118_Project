import './CartAppBar.dart';
import './CartBottomNavBar.dart';
import './CartItemSamples.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Màu nền tổng thể
      appBar: CartAppBar(),
      body: ListView(
        padding: EdgeInsets.only(bottom: 120.h), // Sử dụng ScreenUtil cho padding
        children: [
          Container(
            padding: EdgeInsets.all(20.w), // Sử dụng ScreenUtil cho padding
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r), // Sử dụng ScreenUtil cho border radius
                topRight: Radius.circular(35.r), // Sử dụng ScreenUtil cho border radius
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.r, // Sử dụng ScreenUtil cho blur radius
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Cart',
                  style: TextStyle(
                    fontSize: 24.sp, // Sử dụng ScreenUtil cho kích thước text
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10.h), // Sử dụng ScreenUtil cho khoảng cách
                CartItemSamples(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(),
    );
  }
}
