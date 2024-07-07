import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutBackend {
  static Future<Map<String, String>?> loadAddress() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        final addressData = docSnapshot.data() as Map<String, dynamic>;
        return {
          'fullName': addressData['fullName'],
          'phoneNumber': addressData['phoneNumber'],
          'address': addressData['address'],
        };
      }
    } catch (e) {
      print('Lỗi khi tải thông tin địa chỉ từ Firestore: $e');
    }
    return null;
  }
}
