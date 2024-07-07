import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/ui/authentication/homepage.dart';
import 'package:flutter_project/ui/search/ProductDetailPage.dart';
import 'package:flutter_svg/svg.dart';

class wishList extends StatefulWidget {
  @override
  State<wishList> createState() => _wishListState();
}

class _wishListState extends State<wishList> {
  User? user = FirebaseAuth.instance.currentUser;

  late final _wishlistStream = FirebaseFirestore.instance
      .collection("wishlist")
      .where('userID', isEqualTo: user?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: StreamBuilder(
        stream: _wishlistStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          var docs = snapshot.data!.docs;
          // return Text('${docs.length}');
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      // Hàm xử lý logic khi nhấn vào một item
                      navigateToProductDetailPage(context, docs[index]['imgURL']);
                    },     
                  child: Container(
                    width: 882,
                    height: 158,
                    decoration: BoxDecoration(
                      color: Color(0xffFAF6F6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),

                            // color: Colors.green,
                            child: Image.network(
                              docs[index]['imgURL'], // Đường link ảnh của bạn
                              fit: BoxFit
                                  .cover, // Điều chỉnh cách ảnh hiển thị trong Container
                            ),
                          ),
                        ),
                        Container(
                          width: 350,
                          height: 150,
                          child: Column(
                            children: [
                              Container(
                                width: 350,
                                height: 110,
                                //! color: Colors.blue[200],
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: Align(
                                        alignment: Alignment
                                            .bottomLeft, // Căn chỉnh văn bản
                                        child: Text(
                                          docs[index]['title'],
                                          style: const TextStyle(
                                              color: Colors
                                                  .black, // Đổi màu văn bản
                                              fontSize: 20.0,
                                              fontWeight: FontWeight
                                                  .w500 // Kích thước văn đậm văn bản
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Align(
                                        alignment: Alignment
                                            .bottomLeft, // Căn chỉnh văn bản
                                        child: Text(
                                          docs[index]['description'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 5.0),
                                child: Align(
                                  alignment:
                                      Alignment.bottomLeft, // Căn chỉnh văn bản
                                  child: Text(
                                    docs[index]['price'],
                                    style: const TextStyle(
                                      color: Colors.black, // Đổi màu văn bản
                                      fontSize: 20.0, // Kích thước văn bản
                                      fontWeight:
                                          FontWeight.bold, // Độ đậm văn bản
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteWishlist(docs[index].id);
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ));
              });
        },
      ),
    );
  }

  Future<void> deleteWishlist(String wishlistId) async {
    await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(wishlistId)
        .delete();
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Wish List',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          // hàm xử lí logic

          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
  
Bouquets bouquetFromSnapshot(DocumentSnapshot snapshot) {
  return Bouquets(
    snapshot['image'],
    snapshot['title'],
    snapshot['price'],
    snapshot['rating'],
    snapshot['description'],
    snapshot['type'],
  );
}

  void navigateToProductDetailPage(BuildContext context, String imgURL) {
  // Truy vấn trong collection bouquets để lấy ra đối tượng Bouquets tương ứng
  FirebaseFirestore.instance
      .collection('bouquets')
      .where('image', isEqualTo: imgURL)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      // Tạo đối tượng Bouquets từ đối tượng DocumentSnapshot
      final Bouquets bouquet = bouquetFromSnapshot(querySnapshot.docs[0]);
      
      // Truyền đối tượng Bouquets vào trang chi tiết sản phẩm
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
    } else {
      // Xử lý khi không tìm thấy đối tượng Bouquets
      print('Không tìm thấy sản phẩm với URL $imgURL');
    }
  });
}
}
