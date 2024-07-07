import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductDetail.dart'; // Import trang chi tiết sản phẩm

class Bouquets {
  final String image;
  final String title;
  final double price;
  final int rating;

  Bouquets(this.image, this.title, this.price, this.rating);
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Bouquets> displayList;
  late List<Bouquets> allBouquets;

  TextEditingController _searchController = TextEditingController();

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
        bouquets.add(Bouquets(
          doc['image'],
          doc['title'],
          doc['price'].toDouble(),
          doc['rating'],
        ));
      });
      setState(() {
        allBouquets = bouquets;
        displayList = bouquets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bạn muốn tìm gì?",
              style: TextStyle(
                color: Color.fromARGB(255, 234, 33, 100),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              style: TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 252, 203, 219),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Nhập từ khóa",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.pink,
              ),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToProductDetail(context, displayList[index]);
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.network(
                              displayList[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              displayList[index].title,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: List.generate(
                                displayList[index].rating,
                                (index) => Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                            trailing: Text(
                              '\$${displayList[index].price}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    List<Bouquets> searchResults = allBouquets
        .where((bouquet) =>
            bouquet.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayList = searchResults;
    });
  }

  void navigateToProductDetail(BuildContext context, Bouquets bouquet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productName: bouquet.title,
          productPrice: '\$${bouquet.price}',
          productDescription: 'Mô tả sản phẩm: ${bouquet.title}',
        ),
      ),
    );
  }
}
