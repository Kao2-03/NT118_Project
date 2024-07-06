import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h), // Sử dụng ScreenUtil cho padding
        height: 150.h, // Tăng chiều cao của Container
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r, // Sử dụng ScreenUtil cho blur radius
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tổng cộng:",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 10.sp, // Sử dụng ScreenUtil cho kích thước text
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.h), // Sử dụng ScreenUtil cho khoảng cách
                Text(
                  "\$250",
                  style: TextStyle(
                    fontSize: 12.sp, // Sử dụng ScreenUtil cho kích thước text
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý sự kiện nhấn nút "Chốt đơn"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r), // Sử dụng ScreenUtil cho border radius
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h), // Sử dụng ScreenUtil cho padding
              ),
              child: Text(
                "Chốt đơn",
                style: TextStyle(
                  fontSize: 12.sp, // Sử dụng ScreenUtil cho kích thước text
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}