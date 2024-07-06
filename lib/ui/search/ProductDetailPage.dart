import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String productDescription;
  final String productImage;

  ProductDetailPage({
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImage,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addToCart(String productName, double productPrice, String productImage) {
    _firestore.collection('cartItems').add({
      'productName': productName,
      'price': productPrice,
      'quantity': 1,
      'imageUrl': productImage,
      'isSelected': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(productImage),
            SizedBox(height: 16),
            Text(
              productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text
(
              productDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addToCart(productName, productPrice, productImage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm vào giỏ hàng')),
                );
              },
              child: Text('Thêm vào giỏ hàng'),
            ),
          ],
        ),
      ),
    );
  }
}