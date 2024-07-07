import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/ui/cart/CartAppBar.dart';

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
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                cartItem['imageUrl'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem['productName'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price: ${cartItem['price']} vnd',
                                    style: TextStyle(
                                      fontSize: 14,
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
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tiền: ${totalPrice.toStringAsFixed(2)} vnd',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _checkout,
                      child: Text(
                        'Thanh toán',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
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
