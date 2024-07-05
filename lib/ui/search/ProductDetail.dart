
import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productDescription;

  // Danh sách các thành phần bó hoa
  final List<Map<String, dynamic>> bouquetComponents = [
    {"image": "assets/images/flower1.jpg", "quantity": 5},
    {"image": "assets/images/flower2.jpg", "quantity": 3},
    {"image": "assets/images/flower3.jpg", "quantity": 2},
    // Thêm các thành phần khác nếu cần
  ];

  ProductDetailPage({
    Key? key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Constants.basicColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: screenHeight * 0.4,
                child: PageView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      child: Image.asset(
                        "assets/images/flower${index + 1}.jpg",
                        fit: BoxFit.cover,
                        width: screenWidth,
                        height: screenHeight * 0.4,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  productName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                productPrice,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Color.fromARGB(255, 105, 105, 105),
                ),
              ),
            ),
            // Hiển thị thành phần bó hoa
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thành phần bó hoa:",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Danh sách các thành phần
                  Column(
                    children: bouquetComponents.map((component) {
                      return Row(
                        children: [
                          Image.asset(
                            component['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "x ${component['quantity']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                productDescription,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Thêm vào giỏ hàng - 300.000vnd'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12, vertical: screenHeight * 0.015),
                  textStyle: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder_rounded), label: 'My order'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: Color.fromARGB(255, 226, 98, 188),
        onTap: (int index) {},
      ),
    );
  }
}