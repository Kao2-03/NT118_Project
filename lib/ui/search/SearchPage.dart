import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductDetailPage.dart'; // Import trang chi tiết sản phẩm

class Bouquets {
  final String image;
  final String title;
  final double price;
  final int rating;

  Bouquets(this.image, this.title, this.price, this.rating);

  get description => 'Mô tả sản phẩm: $title';
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Bouquets> displayList = [];
  List<Bouquets> allBouquets = [];

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
          (doc['price'] as num).toDouble(),
          (doc['rating'] as num).toInt(),
        ));
      });
      setState(() {
        allBouquets = bouquets;
        displayList = bouquets;
      });
    });
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
          productPrice: bouquet.price,
          productDescription: bouquet.description,
          productImage: bouquet.image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Tìm kiếm sản phẩm",
          style: TextStyle(
            color: Color.fromARGB(255, 234, 33, 100),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                prefixIcon: Icon(Icons.search, color: Colors.pink),
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
}
