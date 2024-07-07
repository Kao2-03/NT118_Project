import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserLocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  void updateUserInfo(String province, String district, String ward) async {
    try {
      // Lấy thông tin người dùng hiện tại từ Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Lấy ID của người dùng hiện tại
        String uid = user.uid;

        // Cập nhật thông tin tỉnh, quận, xã vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'province': province,
          'district': district,
          'ward': ward,
        });

        print('Thông tin đã được cập nhật thành công!');
      } else {
        print('Không tìm thấy người dùng hiện tại!');
      }
    } catch (e) {
      print('Lỗi khi cập nhật thông tin: $e');
    }
  }
  // Các hàm khác
  Future<List<dynamic>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('https://vapi.vnappmob.com/api/province'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['results'];
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print('Error loading provinces: $e');
      return [];
    }
  }

  Future<List<dynamic>> getDistricts(String provinceId) async {
    try {
      final response = await http.get(Uri.parse('https://vapi.vnappmob.com/api/province/district/$provinceId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['results'];
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      print('Error loading districts: $e');
      return [];
    }
  }

  Future<List<dynamic>> getWards(String districtId) async {
    try {
      final response = await http.get(Uri.parse('https://vapi.vnappmob.com/api/province/ward/$districtId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['results'];
      } else {
        throw Exception('Failed to load wards');
      }
    } catch (e) {
      print('Error loading wards: $e');
      return [];
    }
  }
}
