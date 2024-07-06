import 'package:flutter/material.dart';
import 'package:flutter_project/ux/cart/FirebaseService.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final bool isSelected;
  final FirebaseService firebaseService;
  final VoidCallback onQuantityChanged;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.isSelected,
    required this.firebaseService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl), // Sử dụng hình ảnh từ Firebase
          radius: 30,
        ),
        title: Text(productName),
        subtitle: Text('$price vnd x $quantity'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                if (value != null) {
                  firebaseService.updateCartItemSelection(productId, value);
                  onQuantityChanged();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (quantity > 1) {
                  firebaseService.updateCartItem(productId, quantity - 1);
                } else {
                  firebaseService.deleteCartItem(productId);
                }
                onQuantityChanged();
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                firebaseService.updateCartItem(productId, quantity + 1);
                onQuantityChanged();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                firebaseService.deleteCartItem(productId);
                onQuantityChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}