import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/ui/payment/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constants.dart';
import '../../ux/payment_methods/paypal.dart';
import '../payment/set_address.dart';
class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  const Checkout({Key? key, required this.selectedProducts}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}
double convertVNDToUSD(double amountInVND) {
  // Giả sử tỷ giá hối đoái là 1 VND = 0.000043 USD (thay bằng tỷ giá thực tế của bạn)
  double exchangeRate = 0.000039;
  return amountInVND * exchangeRate;
}
class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;
  double _totalPrice = 0.0;
  List<Map<String, dynamic>> _products = [];
  Map<String, String>? _addressData;

  @override
  void initState() {
    super.initState();
    _products = widget.selectedProducts;
    _calculateTotalPrice();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        final addressData = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _addressData = {
            'fullName': addressData['fullName'],
            'phoneNumber': addressData['phoneNumber'],
            'address': addressData['address'],
          };
        });
      }
    } catch (e) {
      print('Lỗi khi tải thông tin địa chỉ từ Firestore: $e');
    }
  }
  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = _products.fold(
        0.0,
            (sum, item) => sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)),
      );
    });
  }
  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _selectedPaymentMethod = value;
    });
  }
  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPaymentMethod == 'PayPal') {
        try {
          // Đổi tổng tiền từ VND sang USD
          double totalAmountUSD = convertVNDToUSD(_totalPrice);
          // Tạo và mở URL thanh toán PayPal
          final paypalUrl = await createPaypalUrl(
            clientId: 'AZaIIPy1RnDDomT5lOi7859mf5-g6bBEUTAPUPi0JkwL30A6trvo9CGA5kx7BluzmuPQM9H0Bdll9FOh',
            secretKey: 'ECCT-wZEua3qTJNyf7hzvdBid5Lxk0ojL4DfmnX1tFPd40oPrewwDWXprxDdIl-yjRhyP0SNxJ-rnqDa',
            currencyCode: 'USD',
            intent: 'sale',
            amount: totalAmountUSD,
            returnUrl: 'https://flutter-39a22.web.app',
            cancelUrl: 'https://flutter-39a22.web.app',
            baseUrl: 'https://api.sandbox.paypal.com/v1/payments/payment',
          );
          _openPaymentUrl(paypalUrl);
          // Xóa giỏ hàng sau khi thanh toán thành công
          _clearCart();
        } catch (e) {
          print('Lỗi khi thực hiện thanh toán PayPal: $e');
          _showErrorDialog();
        }
      } else if (_selectedPaymentMethod == 'Cash') {
        _handleCashPayment();
        // Lưu thông tin đơn hàng và thanh toán vào Firestore
        await _saveOrderToFirestore('Cash');
        // Xóa giỏ hàng sau khi thanh toán thành công
        _clearCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phương thức thanh toán không hợp lệ')),
        );
      }
    }
  }
  Future<void> _saveOrderToFirestore(String paymentMethod) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Tạo một document mới trong collection 'orders'
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();

      // Lấy thông tin địa chỉ của người dùng
      final docSnapshot = await userRef.get();
      final addressData = docSnapshot.data() as Map<String, dynamic>;

      // Lấy danh sách sản phẩm trong đơn hàng
      final List<Map<String, dynamic>> products = [];
      _products.forEach((product) {
        products.add({
          'productName': product['productName'],
          'quantity': product['quantity'],
          'price': product['price'],
          'imageUrl': product['imageUrl'],
        });
      });

      // Tạo dữ liệu đơn hàng
      final orderData = {
        'userId': userId,
        'address': {
          'fullName': addressData['fullName'],
          'phoneNumber': addressData['phoneNumber'],
          'address': addressData['address'],
        },
        'products': products,
        'totalPrice': _totalPrice,
        'paymentMethod': paymentMethod,
        'timestamp': FieldValue.serverTimestamp(), // Thêm timestamp
      };

      // Lưu thông tin đơn hàng vào Firestore
      await orderRef.set(orderData);

      // Hiển thị thông báo thanh toán thành công
      _showSuccessDialog();

      // Xóa giỏ hàng sau khi thanh toán thành công (nếu có logic xóa giỏ hàng)
      // _clearCart(); // Đây là hàm xóa giỏ hàng, bạn có thể triển khai theo yêu cầu của dự án
    } catch (e) {
      print('Lỗi khi lưu đơn hàng vào Firestore: $e');
      _showErrorDialog();
    }
  }
  void _clearCart() {
    // Triển khai logic xóa giỏ hàng ở đây, ví dụ:
    _products.clear(); // Xóa các sản phẩm trong giỏ hàng local
    setState(() {
      _totalPrice = 0.0; // Cập nhật tổng giá trị giỏ hàng
    });
  }
  void _handleCashPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thanh toán bằng tiền mặt chưa được triển khai')),
    );
  }
  Future<void> _openPaymentUrl(String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayPalWebView(url: url),
      ),
    ).then((paymentSuccess) {
      if (paymentSuccess) {
        // Lưu thông tin đơn hàng và thanh toán vào Firestore
        _saveOrderToFirestore('PayPal');
      }
    });
  }
  Future<void> _editAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetAddressScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _addressData = Map<String, String>.from(result);
      });
    }
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thanh toán thành công'),
        content: Text('Đơn hàng của bạn đã được thanh toán thành công.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thanh toán thất bại'),
        content: Text('Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh Toán', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCustomerInformation(),
              SizedBox(height: 16.h),
              _buildProductList(),
              SizedBox(height: 16.h),
              _buildPaymentMethods(),
              SizedBox(height: 16.h),
              _buildTotalPrice(),
              SizedBox(height: 16.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInformation() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Địa chỉ nhận hàng',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editAddress,
                ),
              ],
            ),
            if (_addressData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tên: ${_addressData!['fullName']}', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 4.h),
                  Text('Số điện thoại: ${_addressData!['phoneNumber']}', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 4.h),
                  Text('Địa chỉ: ${_addressData!['address']}', style: TextStyle(fontSize: 16.sp)),
                ],
              )
            else
              Text('Không có thông tin địa chỉ', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: Image.network(product['imageUrl'] ?? '', width: 50.w, height: 50.h, fit: BoxFit.cover),
                  title: Text(product['productName'] ?? '', style: TextStyle(fontSize: 16.sp)),
                  subtitle: Text(
                    '${product['quantity']} x ${product['price']}đ',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phương thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children: [
                RadioListTile(
                  title: Text('PayPal'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  tileColor: Colors.transparent,
                  activeColor: Constants.primaryColor,
                  value: 'PayPal',
                  groupValue: _selectedPaymentMethod,
                  onChanged: _onPaymentMethodChanged,
                  secondary: FaIcon(
                    FontAwesomeIcons.bank,
                    color: Colors.blue,
                  ),
                ),
                RadioListTile(
                  title: Text('Tiền mặt'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  tileColor: Colors.transparent,
                  activeColor: Constants.primaryColor,
                  value: 'Cash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: _onPaymentMethodChanged,
                  secondary: FaIcon(
                    FontAwesomeIcons.moneyBillWave,
                    color: Colors.green,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng thanh toán',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              '${_totalPrice.toStringAsFixed(0)}đ',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Text(
            'Thanh Toán',
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}


