import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:flutter_project/ui/myOrder/my_order.dart';
import 'package:flutter_project/ui/profile/user_account.dart';
import 'package:flutter_project/ui/wishlist/wish_list.dart';
import '../cart/CartPage.dart';
import '../search/SearchPage.dart';
import 'package:flutter/painting.dart';
// import '../cart/user_account.dart';
import '../search/ProductDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Current index for BottomNavigationBar

  // Function to handle navigation logic
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      // Assuming index 3 is 'Profile'
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyOrder()),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => wishList()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(Constants.titleFive,
            style: TextStyle(color: Constants.primaryColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Constants.basicColor),
            onPressed: () {
              // Add your shopping cart functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the SearchPage when the search bar is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          Icon(Icons.search, color: Constants.basicColor),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Danh mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Example categories
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
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                _ProductCard(
                    productName: "Combo hoa phấn",
                    productPrice: 125000.0,
                    productImage: "assets/images/flower2.jpg",
                    productRating: 5,
                    productDescription:
                        "Một bó hoa tươi tắn với sắc màu nhẹ nhàng."),
                _ProductCard(
                    productName: "Combo hoa sẵn",
                    productPrice: 48000.0,
                    productImage: "assets/images/flower2.jpg",
                    productRating: 4,
                    productDescription: "Một bó hoa đẹp sẵn sàng cho mọi dịp."),
                _ProductCard(
                    productName: "Tulip",
                    productPrice: 400000.0,
                    productImage: "assets/images/flower2.jpg",
                    productRating: 5,
                    productDescription: "Những bông hoa Tulip rực rỡ sắc màu."),
              ],
            )
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
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: const Color.fromARGB(255, 226, 98, 188),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image:
              AssetImage("assets/images/flower1.jpg"), // Background image asset
          fit: BoxFit.cover,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          "Create your own Bouquet\nexpress yourself by create your own unique bouquet",
          style: TextStyle(
            color: Colors.black,
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
  final int productRating;
  final String productDescription;

  const _ProductCard({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productRating,
    required this.productDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          navigateToProductDetail(
            context,
            productName,
            productPrice,
            productDescription,
            productImage,
            productRating,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  productImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${productPrice.toString()}",
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Handle button press
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToProductDetail(
    BuildContext context,
    String productName,
    double productPrice,
    String productDescription,
    String productImage,
    int productRating) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(
        productName: productName,
        productPrice: productPrice,
        productDescription: productDescription,
        productImage: productImage,
        productRating: productRating,
      ),
    ),
  );
}

void navigateToSearchPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SearchPage()),
  );
}
