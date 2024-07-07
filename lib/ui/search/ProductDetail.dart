import 'package:flutter/material.dart';
import '/../constants.dart';

class ProductDetailPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productDescription;

  // Danh sách các thành phần bó hoa
  final List<Map<String, dynamic>> bouquetComponents = [
    {"name": "Hoa hồng", "image": "assets/images/flower1.jpg", "quantity": 5},
    {"name": "Hoa lan", "image": "assets/images/flower2.jpg", "quantity": 3},
    {"name": "Hoa cúc", "image": "assets/images/flower3.jpg", "quantity": 2},
    // Thêm các thành phần khác nếu cần
  ];

  ProductDetailPage({
    Key? key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int quantity = 1; // Số lượng sản phẩm

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    child: PageView.builder(
                      controller: _pageController,
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
                  Positioned(
                    bottom: 10.0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ngày đặt trước:     1 ngày", // Thay đổi nếu có thêm logic xử lý ngày đặt
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Giá niêm yết:",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Color.fromARGB(255, 105, 105, 105),
                    ),
                  ),
                  Text(
                    "${widget.productPrice}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Color.fromARGB(255, 105, 105, 105),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                widget.productDescription,
                style: TextStyle(fontSize: screenWidth * 0.04),
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
                      color: Color.fromARGB(255, 226, 98, 188),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Danh sách các thành phần
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.bouquetComponents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          widget.bouquetComponents[index]['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          widget.bouquetComponents[index]['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          "x ${widget.bouquetComponents[index]['quantity']}",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        onTap: () {
                          // Xử lý khi người dùng chọn một thành phần bó hoa
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Thêm vào giỏ hàng - ${widget.productPrice}vnd'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 226, 98, 188),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.12,
                      vertical: screenHeight * 0.015),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.reorder_rounded), label: 'My order'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 226, 98, 188),
        unselectedItemColor: Color.fromARGB(255, 226, 98, 188),
        onTap: (int index) {},
      ),
    );
  }
}
