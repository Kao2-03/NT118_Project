import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ux/payment_methods/user_location.dart';

class SetAddressScreen extends StatefulWidget {
  @override
  _SetAddressScreenState createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  final UserLocationService _locationService = UserLocationService();
  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _wards = [];

  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoadingProvinces = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingWards = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() {
      _isLoadingProvinces = true;
    });
    try {
      final List<dynamic> provinces = await _locationService.getProvinces();
      setState(() {
        _provinces = provinces;
      });
    } finally {
      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  Future<void> _loadDistricts(String provinceId) async {
    setState(() {
      _isLoadingDistricts = true;
    });
    try {
      final List<dynamic> districts = await _locationService.getDistricts(provinceId);
      setState(() {
        _districts = districts;
      });
    } finally {
      setState(() {
        _isLoadingDistricts = false;
      });
    }
  }

  Future<void> _loadWards(String districtId) async {
    setState(() {
      _isLoadingWards = true;
    });
    try {
      final List<dynamic> wards = await _locationService.getWards(districtId);
      setState(() {
        _wards = wards;
      });
    } finally {
      setState(() {
        _isLoadingWards = false;
      });
    }
  }

  void _saveAddress() async {
    final selectedProvince = _provinces.firstWhere((province) => province['province_id'].toString() == _selectedProvince, orElse: () => {'province_name': ''})['province_name'];
    final selectedDistrict = _districts.firstWhere((district) => district['district_id'].toString() == _selectedDistrict, orElse: () => {'district_name': ''})['district_name'];
    final selectedWard = _wards.firstWhere((ward) => ward['ward_id'].toString() == _selectedWard, orElse: () => {'ward_name': ''})['ward_name'];

    final addressData = {
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': '$selectedWard, $selectedDistrict, $selectedProvince, ${_addressController.text}',
    };

    // Lưu thông tin vào Firestore
    await saveAddressToFirestore(addressData);

    Navigator.pop(context, addressData);
  }

  Future<void> saveAddressToFirestore(Map<String, dynamic> addressData) async {
    try {
      await Firebase.initializeApp();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final email = FirebaseAuth.instance.currentUser?.email;
      final password = FirebaseAuth.instance.currentUser?.providerData.first.providerId;

      await firestore.collection('users').doc(userId).set({
        'fullName': addressData['fullName'],
        'phoneNumber': addressData['phoneNumber'],
        'address': addressData['address'],
        'email': email,
        'password': password,
      });
      print('Đã lưu thông tin địa chỉ vào Firestore thành công!');
    } catch (e) {
      print('Lỗi khi lưu thông tin địa chỉ vào Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt Địa Chỉ', style: TextStyle(fontSize: 20.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15.h),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(Icons.person, size: 20.sp),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                border: const OutlineInputBorder(),
                labelText: 'Họ và tên người nhận',
                hintText: 'Nhập họ tên',
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(Icons.phone, size: 20.sp),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                border: const OutlineInputBorder(),
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại',
              ),
            ),
            SizedBox(height: 20.h),
            if (_isLoadingProvinces)
              Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tỉnh/Thành Phố',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    value: _selectedProvince,
                    hint: Text('Chọn Tỉnh/Thành Phố', style: TextStyle(fontSize: 14.sp)),
                    items: _provinces.map((province) {
                      return DropdownMenuItem<String>(
                        value: province['province_id'].toString(),
                        child: Text(province['province_name'], style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProvince = value;
                        _selectedDistrict = null;
                        _selectedWard = null;
                        _districts.clear();
                        _wards.clear();
                        if (value != null) {
                          _loadDistricts(value);
                        }
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20.h),
            if (_isLoadingDistricts)
              Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quận/Huyện',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    value: _selectedDistrict,
                    hint: Text('Chọn Quận/Huyện', style: TextStyle(fontSize: 14.sp)),
                    items: _districts.map((district) {
                      return DropdownMenuItem<String>(
                        value: district['district_id'].toString(),
                        child: Text(district['district_name'], style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDistrict = value;
                        _selectedWard = null;
                        _wards.clear();
                        if (value != null) {
                          _loadWards(value);
                        }
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20.h),
            if (_isLoadingWards)
              Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phường/Xã',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    value: _selectedWard,
                    hint: Text('Chọn Phường/Xã', style: TextStyle(fontSize: 14.sp)),
                    items: _wards.map((ward) {
                      return DropdownMenuItem<String>(
                        value: ward['ward_id'].toString(),
                        child: Text(ward['ward_name'], style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWard = value;
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20.h),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(Icons.home, size: 20.sp),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                border: const OutlineInputBorder(),
                labelText: 'Nhập địa chỉ nhà',
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Constants.primaryColor,
                ),
                child: TextButton.icon(
                  onPressed: _saveAddress,
                  icon: Icon(Icons.save, size: 20.sp, color: Colors.white),
                  label: Text(
                    'Lưu Địa Chỉ',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
