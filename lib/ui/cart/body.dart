import "../cart/profile_pic.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePic(),
        SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            showCursor: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFFF5F6F9),
              hintText: 'Nguyen Van A',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            showCursor: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFFF5F6F9),
              hintText: 'Account',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            showCursor: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFFF5F6F9),
              hintText: 'neheeeeee',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(150, 60)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFF653A6)),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              onPressed: () {},
              child: Text(
                'Save Change',
                style: TextStyle(color: Colors.white),
              )),
        ),
        SizedBox(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(150, 60)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFF5F6F9)),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              onPressed: () {},
              child: Text(
                'log out',
                style: TextStyle(color: Colors.red),
              )),
        ),
      ],
    );
  }
}