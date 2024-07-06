import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './CartAppBar.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').doc(_auth.currentUser!.uid).collection('cartItems').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data!.docs;

          double totalPrice = 0;
          cartItems.forEach((doc) {
            totalPrice += doc['price'] * doc['quantity'];
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(cartItem['imageUrl']),
                        title: Text(cartItem['productName']),
                        subtitle: Text('Price: \$${cartItem['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeItem(cartItem.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tiền: \$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _checkout,
                      child: Text('Thanh toán'),
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
