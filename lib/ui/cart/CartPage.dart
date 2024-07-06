import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/ux/cart/FirebaseService.dart';
import 'CartItem.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final ValueNotifier<double> _totalPriceNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() async {
    double totalPrice = await _firebaseService.calculateTotalPrice();
    _totalPriceNotifier.value = totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getCartItems(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            _totalPriceNotifier.value = 0.0; // Cập nhật tổng tiền về 0 khi giỏ hàng trống
            return Center(child: Text("Giỏ hàng trống"));
          }

          List<CartItem> cartItems = snapshot.data!.docs.map((doc) {
            return CartItem(
              productId: doc.id,
              productName: doc['productName'],
              price: (doc['price'] as num).toDouble(),
              quantity: (doc['quantity'] as num).toInt(),
              imageUrl: doc['imageUrl'],
              isSelected: doc['isSelected'] ?? false,
              firebaseService: _firebaseService,
              onQuantityChanged: _calculateTotalPrice,
            );
          }).toList();

          return ListView(
            children: cartItems,
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<double>(
        valueListenable: _totalPriceNotifier,
        builder: (context, totalPrice, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng cộng:",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$$totalPrice",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Xử lý chốt đơn
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Chốt đơn",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
