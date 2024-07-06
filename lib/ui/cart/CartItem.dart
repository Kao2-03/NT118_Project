import 'package:flutter/material.dart';
import 'package:flutter_project/ux/cart/FirebaseService.dart';

class CartItem extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final FirebaseService firebaseService;
  final VoidCallback onQuantityChanged;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.firebaseService,
    required this.onQuantityChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
  }

  void _increaseQuantity() {
    setState(() {
      _currentQuantity++;
    });
    widget.firebaseService.increaseCartItemQuantity(widget.productId);
    widget.onQuantityChanged();
  }

  void _decreaseQuantity() {
    if (_currentQuantity > 1) {
      setState(() {
        _currentQuantity--;
      });
      widget.firebaseService.decreaseCartItemQuantity(widget.productId);
      widget.onQuantityChanged();
    } else {
      widget.firebaseService.deleteCartItem(widget.productId);
      widget.onQuantityChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
          radius: 30,
        ),
        title: Text(widget.productName),
        subtitle: Text('${widget.price} vnd x $_currentQuantity'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: _decreaseQuantity,
            ),
            Text('$_currentQuantity'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _increaseQuantity,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.firebaseService.deleteCartItem(widget.productId);
                widget.onQuantityChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}
