import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCartItems() {
    return _firestore.collection('cartItems').snapshots();
  }

  void deleteCartItem(String productId) {
    _firestore.collection('cartItems').doc(productId).delete();
  }

  void increaseCartItemQuantity(String productId) {
    _firestore.collection('cartItems').doc(productId).update({
      'quantity': FieldValue.increment(1),
    });
  }

  void decreaseCartItemQuantity(String productId) {
    _firestore.collection('cartItems').doc(productId).update({
      'quantity': FieldValue.increment(-1),
    });
  }

  Future<double> calculateTotalPrice() async {
    double totalPrice = 0;

    try {
      QuerySnapshot snapshot = await _firestore.collection('cartItems').get();
      List<DocumentSnapshot> docs = snapshot.docs;

      docs.forEach((doc) {
        double price = (doc['price'] as num).toDouble();
        int quantity = (doc['quantity'] as num).toInt();
        totalPrice += price * quantity;
      });
    } catch (e) {
      print("Error calculating total price: $e");
    }

    return totalPrice;
  }
}
