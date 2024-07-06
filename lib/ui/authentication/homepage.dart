import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import '../cart/CartPage.dart';
import '../search/SearchPage.dart';
import 'package:flutter/painting.dart';
import '../cart/user_account.dart';
import '../search/ProductDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    }
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(Constants.titleFive, style: TextStyle(color: Constants.primaryColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Constants.basicColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _navigateToSearchPage,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Constants.basicColor),
                      SizedBox(width: 10),
                      Text(
                        "Tìm kiếm",
                        style: TextStyle(color: Constants.basicColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Danh mục", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  _CategoryCard(categoryName: "Lãng mạn"),
                  _CategoryCard(categoryName: "Tiệc cưới"),
                  _CategoryCard(categoryName: "Sinh nhật"),
                  _CategoryCard(categoryName: "Hoa mừng"),
                ],
              ),
            ),
            CreateYourOwnBouquet(),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                _ProductCard(
                  productName: "Combo hoa phấn",
                  productPrice: 125000,
                  productImage: "assets/images/flower1.jpg",
                ),
                _ProductCard(
                  productName: "Combo gì sẵn",
                  productPrice: 48000,
                  productImage: "assets/images/flower2.jpg",
                ),
                _ProductCard(
                  productName: "Tulip",
                  productPrice: 400000,
                  productImage: "assets/images/flower3.jpg",
                ),
              ],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: Color.fromARGB(255, 226, 98, 188),
        onTap: _onItemTapped,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;

  const _CategoryCard({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(categoryName),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}

class CreateYourOwnBouquet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage("assets/images/flower1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          "Create your own Bouquet\nexpress yourself by create your own unique bouquet",
          style: TextStyle(
            color: Color.fromARGB(255, 224, 223, 223),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String productImage;

  const _ProductCard({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 13,
                child: InkWell(
                  onTap: () {
                    navigateToProductDetail(
                      context,
                      Bouquets(
                        productImage,
                        productName,
                        productPrice,
                        5, // Adjust as necessary
                      ),
                    );
                  },
                  child: Image.asset(productImage, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${productPrice.toString()}', style: TextStyle(color: Constants.primaryColor)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {
                // Handle button press
              },
            ),
          ),
        ],
      ),
    );
  }
}

void navigateToProductDetail(BuildContext context, Bouquets bouquet) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(
        productName: bouquet.title,
        productPrice: bouquet.price,
        productDescription: 'Mô tả sản phẩm: ${bouquet.description}',
        productImage: bouquet.image,
        productRating: bouquet.rating
      ),
    ),
  );
}