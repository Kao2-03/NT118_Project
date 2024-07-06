import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách các mặt hàng trong giỏ hàng từ Firestore
  Stream<QuerySnapshot> getCartItems() {
    return _firestore.collection('cartItems').snapshots();
  }

  // Xóa mặt hàng khỏi giỏ hàng
  void deleteCartItem(String productId) {
    _firestore.collection('cartItems').doc(productId).delete();
  }

  // Cập nhật số lượng mặt hàng trong giỏ hàng
  void updateCartItem(String productId, int newQuantity) {
    _firestore.collection('cartItems').doc(productId).update({'quantity': newQuantity});
  }

  // Cập nhật trạng thái chọn mặt hàng trong giỏ hàng
  void updateCartItemSelection(String productId, bool isSelected) {
    _firestore.collection('cartItems').doc(productId).update({'isSelected': isSelected});
  }

  // Tính tổng tiền của giỏ hàng dựa trên các mặt hàng được chọn
  Future<double> calculateTotalPrice() async {
    double totalPrice = 0;

    try {
      QuerySnapshot snapshot = await _firestore.collection('cartItems').where('isSelected', isEqualTo: true).get();
      List<DocumentSnapshot> docs = snapshot.docs;

      for (var doc in docs) {
        double price = (doc['price'] as num).toDouble();
        int quantity = (doc['quantity'] as num).toInt();
        totalPrice += price * quantity;
      }
    } catch (e) {
      print("Error calculating total price: $e");
    }

    return totalPrice;
  }

  // Thêm mặt hàng vào giỏ hàng
  void addToCart(String productId, String productName, double price, String imageUrl) {
    _firestore.collection('cartItems').doc(productId).set({
      'productName': productName,
      'price': price,
      'quantity': 1,
      'imageUrl': imageUrl,
      'isSelected': false,
    });
  }
  // Reset trạng thái chọn sản phẩm trong giỏ hàng
  void resetCartSelection() {
    _firestore.collection('cartItems').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _firestore.collection('cartItems').doc(doc.id).update({'isSelected': false});
      });
    });
  }
}