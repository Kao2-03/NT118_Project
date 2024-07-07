import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../search/SearchPage.dart'; // Import trang search để điều hướng khi tìm kiếm
import '../search/ProductDetailPage.dart'; // Import trang chi tiết sản phẩm
import '../cart/user_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Bouquets> displayList = [];
  late List<Bouquets> allBouquets = [];
  int _selectedIndex = 0; // Current index for BottomNavigationBar
  String _selectedType = 'All'; // Default type

  @override
  void initState() {
    super.initState();
    fetchBouquets();
  }

  void fetchBouquets() {
    FirebaseFirestore.instance
        .collection('bouquets')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<Bouquets> bouquets = [];
      snapshot.docs.forEach((DocumentSnapshot doc) {
        // Kiểm tra xem các trường cần thiết có tồn tại không
        if (doc.exists && doc.data() != null && doc['image'] != null && doc['title'] != null &&
            doc['price'] != null && doc['rating'] != null && doc['description'] != null && doc['type'] != null) {
          bouquets.add(Bouquets(
            doc['image'],
            doc['title'],
            (doc['price'] as num).toDouble(),
            (doc['rating'] as num).toInt(),
            doc['description'],
            doc['type'],
          ));
        }
      });
      setState(() {
        allBouquets = bouquets;
        displayList = bouquets; // Hiển thị tất cả sản phẩm ban đầu
      });
    });
  }

  void filterBouquetsByType(String type) {
    setState(() {
      _selectedType = type;
      if (type == 'All') {
        displayList = allBouquets; // Hiển thị tất cả sản phẩm nếu chọn 'All'
      } else {
        displayList = allBouquets.where((bouquet) => bouquet.type == type).toList();
      }
    });
  }

  void navigateToProductDetail(BuildContext context, Bouquets bouquet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productName: bouquet.title,
          productPrice: bouquet.price,
          productDescription: bouquet.description,
          productImage: bouquet.image,
          productRating: bouquet.rating,
        ),
      ),
    );
  }

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
  }

  void goToCartPage(BuildContext context) {
    // Navigate to cart page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()), // Replace with your actual cart page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Florish'),
        
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Color.fromARGB(255, 219, 91, 134),
            onPressed: () {
              goToCartPage(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Danh mục",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  _CategoryCard(typeName: "Hoa mừng", onTap: () => filterBouquetsByType("Bó Hoa")),
                  _CategoryCard(typeName: "Lãng mạn", onTap: () => filterBouquetsByType("Wedding")),
                  _CategoryCard(typeName: "Tiệc cưới", onTap: () => filterBouquetsByType("Birthday")),
                  _CategoryCard(typeName: "Sinh nhật", onTap: () => filterBouquetsByType("Congratulations")),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width , 
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/flower1.jpg"), // Your advertisement image asset
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                "Discover our new collection",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    navigateToProductDetail(context, displayList[index]);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              displayList[index].image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayList[index].title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  displayList[index].rating,
                                  (index) => Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$${displayList[index].price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Florish'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder_rounded), label: 'My Order'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink, // Set selected item color to pink
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        onTap: _onItemTapped,
      ),
    );
  }
}

class Bouquets {
  final String image;
  final String title;
  final double price;
  final int rating;
  final String description;
  final String type; // Thay đổi từ category thành type

  Bouquets(this.image, this.title, this.price, this.rating, this.description, this.type);
}

class _CategoryCard extends StatelessWidget {
  final String typeName;
  final VoidCallback onTap;

  const _CategoryCard({Key? key, required this.typeName, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(typeName),
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Color.fromARGB(255, 218, 114, 148), // Set the background color here
      ),
      body: Center(
        child: Text('Your Cart Items'),
      ),
    );
  }
}
