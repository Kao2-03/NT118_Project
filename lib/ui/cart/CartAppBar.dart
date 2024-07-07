import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClearSelection;

  CartAppBar({this.onClearSelection});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.pink, size: 30.w),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Giỏ hàng",
        style: TextStyle(
          fontSize: 23.sp,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
      actions: [
        if (onClearSelection != null)
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.pink, size: 30.w),
            onPressed: onClearSelection,
          ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.pink, size: 30.w),
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
