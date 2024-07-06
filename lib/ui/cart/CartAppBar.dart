import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.pink, size: 30.w), // Sử dụng ScreenUtil cho kích thước icon
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Cart",
        style: TextStyle(
          fontSize: 23.sp, // Sử dụng ScreenUtil cho kích thước text
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.pink, size: 30.w), // Sử dụng ScreenUtil cho kích thước icon
          onPressed: () {
            // Handle more options here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}