import 'package:flutter/material.dart';
import 'package:flutter_project/model/wish_list_model.dart';
import 'package:flutter_svg/svg.dart';

class wishList extends StatefulWidget {
  @override
  State<wishList> createState() => _wishListState();
}

class _wishListState extends State<wishList> {
  List<WishListModel> wishlists = [];

  void _getWishList() {
    wishlists = WishListModel.getWishList();
  }

  @override
  Widget build(BuildContext context) {
    _getWishList();
    return Scaffold(
      appBar: appBar(context),
      body: wishListComponent(),
    );
  }

  ListView wishListComponent() {
    return ListView.builder(
        itemCount: wishlists.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                        wishlists[index].imgPath, // Đường link ảnh của bạn
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
                                padding:
                                  const  EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Align(
                                  alignment: Alignment
                                      .bottomLeft, // Căn chỉnh văn bản
                                  child: Text(
                                    wishlists[index].name,
                                    style: const TextStyle(
                                        color:
                                            Colors.black, // Đổi màu văn bản
                                        fontSize: 20.0,
                                        fontWeight: FontWeight
                                            .w500 // Kích thước văn đậm văn bản
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Align(
                                  alignment: Alignment
                                      .bottomLeft, // Căn chỉnh văn bản
                                  child: Text(
                                    wishlists[index].describe,
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
                              wishlists[index].price,
                              style: const TextStyle(
                                color: Colors.black, // Đổi màu văn bản
                                fontSize: 20.0, // Kích thước văn bản
                                fontWeight: FontWeight.bold, // Độ đậm văn bản
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
}
