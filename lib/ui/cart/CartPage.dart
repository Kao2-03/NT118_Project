import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cart/CartAppBar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> selectedItems = [];

  void _incrementQuantity(String docId, int currentQuantity) {
    _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').doc(docId).update({
      'quantity': currentQuantity + 1,
    });
  }

  void _decrementQuantity(String docId, int currentQuantity) {
    if (currentQuantity > 1) {
      _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').doc(docId).update({
        'quantity': currentQuantity - 1,
      });
    } else {
      _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').doc(docId).delete();
    }
  }

  void _removeItem(String docId) {
    _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').doc(docId).delete();
  }

  void _checkout() {
    // Implement the checkout logic here
  }

  void _toggleSelection(String docId) {
    setState(() {
      if (selectedItems.contains(docId)) {
        selectedItems.remove(docId);
      } else {
        selectedItems.add(docId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartAppBar(
        onClearSelection: _clearSelection,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data!.docs;

          double totalPrice = 0;
          cartItems.forEach((doc) {
            if (selectedItems.contains(doc.id)) {
              totalPrice += doc['price'] * doc['quantity'];
            }
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    bool isSelected = selectedItems.contains(cartItem.id);
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.network(
                                cartItem['imageUrl'],
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem['productName'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Price: ${cartItem['price']} vnd',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          _decrementQuantity(cartItem.id, cartItem['quantity']);
                                        },
                                      ),
                                      Text('${cartItem['quantity']}'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _incrementQuantity(cartItem.id, cartItem['quantity']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    _toggleSelection(cartItem.id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _removeItem(cartItem.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: isSelected ? Colors.grey.withOpacity(0.2) : Colors.white,
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'Tổng tiền: ${totalPrice.toStringAsFixed(2)} vnd',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _checkout,
                          child: Text(
                            'Thanh toán',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 246, 83, 116),
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
