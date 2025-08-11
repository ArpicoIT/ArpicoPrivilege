
import 'data/models/product.dart';
import 'shared/components/cards/voucher_card.dart';

class TestData {

  final List<String> promoBanners = [
    "assets/promotions/1.jpg",
    "assets/promotions/2.jpg",
    "assets/promotions/3.jpg",
    "assets/promotions/4.jpg",
  ];

  List<Review> get ratingsAndReviews => [
    Review(
        userId: '001',
        userName: "Gayan Chanaka",
        // profilePic: ,
        review: 'Good product',
        // comment: ,
        // reply: ,
        // reportAbuse: '',
        rating: 3.5,
        like: 0,
        datetime: 1736248514988,
        images: [
          'http://192.168.1.141:2000/products/30523.JPG'
        ],
    ),
    Review(
        userId: '002',
        userName: "Sudeep Nishara",
        review: 'Not grade quality, but worth for the price',
        rating: 2.5,
        like: 0,
        datetime: 1736248514988,
        images: [
          "http://192.168.1.141:2000/products/30568.JPG"
        ],
    ),
    Review(
        userId: '003',
        userName: "Sampath Dissanayake",
        review: 'Good quality',
        rating: 4.5,
        like: 0,
        datetime: 1736248514988,
        images: [
          "http://192.168.1.141:2000/products/17336.jpg",
          "http://192.168.1.141:2000/products/17363.jpg"
        ],
    ),
    Review(
      userId: '004',
      userName: "Lakkantha Dananjaya",
      review: 'Supiriyak Thamai',
      rating: 3.8,
      like: 0,
      datetime: 1736248514988,
      images: [],
    ),
    Review(
      userId: '005',
      userName: "Pulasthi Bandara",
      review: 'Meloo rahak naa. Ganna epa',
      rating: 1,
      like: 0,
      datetime: 1736248514988,
      images: [],
    )
  ];

  final String highlights = "\u2022 pull up load and pull down refresh"
      "\n\n\u2022 It's almost fit for all Scroll witgets,like GridView,ListView..."
      "\n\n\u2022 provide global setting of default indicator and property"
      "\n\n\u2022 provide some most common indicators"
      "\n\n\u2022 Support Android and iOS default ScrollPhysics,the overScroll distance can be controlled,custom spring animate,damping,speed."
      "\n\n\u2022 horizontal and vertical refresh,support reverse ScrollView also(four direction)";

  final String description = "if one of your SmartRefresher behaves differently from the rest of the world, you can use RefreshConfiguration.copyAncestor() to copy attributes from your ancestor RefreshConfiguration and replace attributes that are not empty.";

  List<Product> get discountItems => [
    Product(
        imageUrl: ['https://image.made-in-china.com/226f3j00zoWaQbTEBgcL/Single-Hand-Plastic-Supermarket-Shopping-Basket.webp'],
        itemDesc: 'Muesli Fitness Nutritious Energy, Gluten Free (500g)',
        // description: 'Up to 70% off on select items',
        currency: 'Rs',
        itemPrice: 1599,
        itemDisPrice: 4999,
        // rating: 4.0,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,
    ),
    Product(
        imageUrl: ['https://images-eu.ssl-images-amazon.com/images/G/31/img22/Grocery/CatPage/SBC/Grocery_SBC_Oats.jpg'],
        itemDesc: 'Oats',
        currency: 'Rs',
        itemPrice: 1298.4,
        itemDisPrice: 260,
        // rating: 2.5,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://img.freepik.com/premium-photo/grocery-cart-alone-white-background_908985-19766.jpg'],
        itemDesc: 'Shoping Cart',
        currency: 'Rs',
        itemPrice: 2400,
        itemDisPrice: 1499,
        // rating: 5.0,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://newindiansupermarket.com/cdn/shop/products/TOPRAMENMASALASINGLE.jpg?v=1642321825&width=1214'],
        itemDesc: 'TOP RAMEN MASALA SINGLE',
        currency: 'Rs',
        itemPrice: 34500,
        itemDisPrice: 27699,
        // rating: 3.8,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://m.media-amazon.com/images/I/61QRFWqWSNL._AC_UF894,1000_QL80_.jpg'],
        itemDesc: 'Multifunctional ABS',
        currency: 'Rs',
        itemPrice: 210.50,
        itemDisPrice: 2799.99,
        // rating: 2.6,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://www.shutterstock.com/image-illustration/mattresses-stacked-isolated-on-white-260nw-1486986278.jpg'],
        itemDesc: 'Arpico Hybrid Mattress (5 inch)',
        currency: 'Rs',
        itemPrice: 100077,
        itemDisPrice: 2400,
        // rating: 4.2,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbSuPn9brn-cL9Kwuwh-J-ny1cpSIriaRW4g&s'],
        itemDesc: 'GARRY – SINGLE SEATER',
        currency: 'Rs',
        itemPrice: 4250,
        itemDisPrice: 4249,
        // rating: 1.5,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
    Product(
        imageUrl: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRA0H7fdgWoT08AJSlHS0NZWU_0rB_-cckDQ&s'],
        itemDesc: 'Arpico Centrifugal Water Pumps 1 HP, 220V/50Hz | Powerton',
        currency: 'Rs',
        itemPrice: 225,
        itemDisPrice: 3,
        // rating: 4.8,
        reviews: ratingsAndReviews,
        proHighlights: highlights,
        proDescription: description,

    ),
  ];

  List<VoucherData> get voucherItems => [
    VoucherData(
      type: "Birthday Offer",
      title: "15%OFF",
      subTitle: "Any Product",
      minSpend: 9999,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-01",
    ),
    VoucherData(
      type: "VOUCHER MAX",
      title: "12%OFF",
      subTitle: "Selected Product",
      minSpend: 4999,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
    VoucherData(
      type: "Xmas",
      title: "Rs. 500",
      subTitle: "Selected Product",
      minSpend: 2000,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
    VoucherData(
      type: "Arpico Voucher",
      title: "Rs. 1000",
      subTitle: "Selected Product",
      minSpend: 5000,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
    VoucherData(
      type: "VOUCHER MAX",
      title: "9%OFF",
      subTitle: "Selected Product",
      minSpend: 2999,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
    VoucherData(
      type: "Birthday Offer",
      title: "15%OFF",
      subTitle: "Any Product",
      minSpend: 9999,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-01",
    ),
    VoucherData(
      type: "Arpico Voucher",
      title: "Rs. 500",
      subTitle: "Selected Product",
      minSpend: 2000,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
    VoucherData(
      type: "Arpico Voucher",
      title: "Rs. 1000",
      subTitle: "Selected Product",
      minSpend: 5000,
      currency: 'Rs',
      startDate: "2024-10-30",
      expData: "2024-11-30",
    ),
  ];
}