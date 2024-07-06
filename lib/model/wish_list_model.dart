class WishListModel {
  String name;
  String describe;
  String imgPath;
  String price;

  WishListModel({
    required this.name,
    required this.describe,
    required this.imgPath,
    required this.price,
  });

  static List<WishListModel> getWishList() {
    List<WishListModel> wishList = [];

    wishList.add(WishListModel(
        name: 'Hoa cam binh',
        describe: 'Giao hang mien phi',
        imgPath:
            'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-app-1669d.appspot.com/o/adbf19becd36d6108fe473171dacacaa.jpg?alt=media&token=2dd0ab35-5325-4495-b5b1-2388305a07e9',
        price: '500.000'));
    wishList.add(WishListModel(
        name: 'Hoa Cuoi',
        describe:
            'Với trình tạo văn bản trực tuyến , bạn có thể xử lý Lorem Ipsum cá nhân của mình, làm phon',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '20.000'));
    wishList.add(WishListModel(
        name: 'Hoa Tinh nhan',
        describe: 'Free ship extra',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '100.000'));
    wishList.add(WishListModel(
        name: 'Hoa lang man',
        describe: 'Lang man do do',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '3.000.000'));
    wishList.add(WishListModel(
        name: 'Hoa cam binh',
        describe: 'Giao hang mien phi',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '4.000.000'));
    wishList.add(WishListModel(
        name: 'Hoa cam binh',
        describe: 'Giao hang mien phi',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '4.000.000'));
    wishList.add(WishListModel(
        name: 'Hoa cam binh',
        describe: 'Giao hang mien phi',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '4.000.000'));
    wishList.add(WishListModel(
        name: 'Hoa cam binh',
        describe: 'Giao hang mien phi',
        imgPath:
            'https://drive.google.com/uc?export=view&id=1R77lbZOrrELgHAxzBwW_zNG6nxYTqIVo',
        price: '4.000.000'));
    return wishList;
  }
}
