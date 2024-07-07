import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cart/CartPage.dart';

class ProductDetailPage extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productDescription;
  final String productImage;
  final int productRating;

  ProductDetailPage({
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImage,
    required this.productRating,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  void _loadCartItemCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot cartSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cartItems')
          .get();
      setState(() {
        cartItemCount = cartSnapshot.docs.length;
      });
    }
  }

  void addToCart(String productName, double productPrice, String productImage) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cartItems')
            .where('productName', isEqualTo: productName)
            .get();

        if (querySnapshot.size > 0) {
          querySnapshot.docs.forEach((doc) async {
            int currentQuantity = doc['quantity'];
            await _firestore.collection('users').doc(user.uid).collection('cartItems').doc(doc.id).update({
              'quantity': currentQuantity + 1,
            });
          });
        } else {
          await _firestore.collection('users').doc(user.uid).collection('cartItems').add({
            'productName': productName,
            'price': productPrice,
            'quantity': 1,
            'imageUrl': productImage,
          });
        }

        setState(() {
          cartItemCount += 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm vào giỏ hàng')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm vào giỏ hàng: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.productImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 246, 83, 116)),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        'Giá: ',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${widget.productPrice.toString()}',
                        style: TextStyle(fontSize: 18.sp, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        'Đánh giá: ',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(
                          widget.productRating,
                          (index) => Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Mô tả: ',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.productDescription,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(widget.productName, widget.productPrice, widget.productImage);
                      },
                      child: Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h), backgroundColor: Colors.pink,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
