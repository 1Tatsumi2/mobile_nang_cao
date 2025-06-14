import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/features/shop/screens/cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final List<String>? images;
  final String? description; // thêm trường này

  const ProductDetailScreen({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.images,
    this.description,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  int currentIndex = 0;
  bool isFavorite = false;
  bool showDetails = false; // Thêm vào State
  bool showMaterials = false; // Thêm vào State
  bool showPayment = false; // Thêm vào State
  bool showPackaging = false; // Thêm vào State

  List<String> get images => widget.images ?? [widget.image];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Thanh tiêu đề và icon trái tim
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    const Text(
                      'Merdi Collection',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // 2. Ảnh sản phẩm với mũi tên trái/phải
              SizedBox(
                height: 350, // hoặc chiều cao bạn muốn
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          color: const Color(0xFFE7E7E7),
                          alignment: Alignment.center,
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 320,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                          ),
                        );
                      },
                    ),
                    // Mũi tên trái
                    if (images.length > 1 && currentIndex > 0)
                      Positioned(
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 28),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                    // Mũi tên phải
                    if (images.length > 1 && currentIndex < images.length - 1)
                      Positioned(
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 28),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // 3. Số thứ tự ảnh
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  '${currentIndex + 1} / ${images.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // 4. Tên và giá sản phẩm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 5. AVAILABLE và mô tả giao hàng
              const Text(
                'AVAILABLE',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Enjoy complimentary delivery or Collect In Store',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 18),
              // 6. Nút ADD TO SHOPPING BAG
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                      // Xử lý thêm vào giỏ hàng
                    },
                    child: const Text(
                      'ADD TO SHOPPING BAG',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Thêm vào dưới nút ADD TO SHOPPING BAG, trong Column của bạn
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showDetails = !showDetails;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'PRODUCT DETAILS',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            showDetails ? Icons.remove : Icons.add,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Nếu đang đóng thì underline nằm ngay dưới chữ
                    if (!showDetails)
                      Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                        width: double.infinity,
                      ),
                    // AnimatedSize cho nội dung chi tiết và underline
                    AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child:
                            showDetails
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Style 841341 FAE0J 9867\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'The Ophidia collection evokes the House’s heritage with the signature Web stripe and Double G emblem in light gold-toned finish. The styles are crafted from soft GG Monogram coated fabric, featuring green cotton lining inside.',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(height: 12),
                                          // Danh sách chi tiết
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '• Beige and dark brown GG Monogram coated fabric',
                                              ),
                                              Text('• Brown leather trim'),
                                              Text(
                                                '• Light gold-toned hardware',
                                              ),
                                              Text('• Green cotton lining'),
                                              Text('• Double G'),
                                              Text('• Web'),
                                              Text('• Inside: 1 open pocket'),
                                              Text(
                                                '• Adjustable handle drop: 6.7" - 9.1"; length: 14.2" - 18.5"',
                                              ),
                                              Text(
                                                '• Detachable and adjustable leather shoulder strap drop 20.1" - 23.2"; length: 40.2" - 46.5"',
                                              ),
                                              Text('• 10.2"W x 5.9"H x 2.6"D'),
                                              Text(
                                                '• Weight: 0.8lbs approximately',
                                              ),
                                              Text('• Made in Italy'),
                                              Text(
                                                '• Fits iPhone Pro Max/Plus, Airpods, long wallet, and lipstick',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Khi mở, underline nằm dưới cùng nội dung
                                    Container(
                                      height: 1,
                                      color: const Color(0xFFE0E0E0),
                                      width: double.infinity,
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // MATERIALS AND CARE section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showMaterials = !showMaterials;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'MATERIALS AND CARE',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            showMaterials ? Icons.remove : Icons.add,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!showMaterials)
                      Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                        width: double.infinity,
                      ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child:
                            showMaterials
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Gucci products are made with carefully selected materials. Please handle with care for longer product life.\n',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          // Danh sách chi tiết
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '• Protect from direct light, heat and rain. Should it become wet, dry it immediately with a soft cloth',
                                              ),
                                              Text(
                                                '• Fill the bag with tissue paper to help maintain its shape and absorb humidity, and store in the provided flannel bag',
                                              ),
                                              Text(
                                                '• Do not carry heavy products that may affect the shape of the bag',
                                              ),
                                              Text(
                                                '• Clean with a soft, dry cloth',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Underline khi mở
                                    Container(
                                      height: 1,
                                      color: Color(0xFFE0E0E0),
                                      width: double.infinity,
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // PAYMENT OPTIONS section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPayment = !showPayment;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'PAYMENT OPTIONS',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            showPayment ? Icons.remove : Icons.add,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!showPayment)
                      Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                        width: double.infinity,
                      ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child:
                            showPayment
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Merdi accepts the following forms of payment for online purchases:',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(height: 16),
                                          // Hiển thị các payment options theo 2 hàng
                                          Wrap(
                                            spacing: 24,
                                            runSpacing: 12,
                                            children:
                                                paymentOptions.map((option) {
                                                  return SizedBox(
                                                    width: 140,
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          option['icon'],
                                                          width: 28,
                                                          height: 18,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(option['label']),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                          const SizedBox(height: 18),
                                          const Text(
                                            'New: Shop on Merdi.com with monthly payments.',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'PayPal may not be used to purchase Made to Order Décor or DIY items.',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'The full transaction value will be charged to your credit card after we have verified your card details, received credit authorisation, confirmed availability and prepared your order for shipping. For Made To Order, DIY, personalised and selected Décor products, payment will be taken at the time the order is placed.',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Underline khi mở
                                    Container(
                                      height: 1,
                                      color: const Color(0xFFE0E0E0),
                                      width: double.infinity,
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // MERDI PACKAGING section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPackaging = !showPackaging;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'MERDI PACKAGING',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            showPackaging ? Icons.remove : Icons.add,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!showPackaging)
                      Container(
                        height: 1,
                        color: const Color(0xFFE0E0E0),
                        width: double.infinity,
                      ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child:
                            showPackaging
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Hình ảnh gift
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    'https://media.gucci.com/content/WrappingPdp_Standard_528x398/1713444326/WrappingPdp_Packaging-Gucci-Ancora-Apr2024-05_001_Default.jpg',
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    'https://media.gucci.com/content/WrappingPdp_Standard_528x398/1713444327/WrappingPdp_Packaging-Gucci-Ancora-Apr2024-07_001_Default.jpg',
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'SIGNATURE PACKAGING',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            "The House’s signature packaging in Rosso Ancora red. At checkout, personalize your order by selecting one of our distinct packaging options. Please note, images are representative.",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Underline khi mở
                                    Container(
                                      height: 1,
                                      color: const Color(0xFFE0E0E0),
                                      width: double.infinity,
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> paymentOptions = [
  {
    'label': 'Visa',
    'icon': 'assets/icons/visa.png', // Đặt icon riêng cho từng loại
  },
  {'label': 'MasterCard', 'icon': 'assets/icons/mastercard.png'},
  {'label': 'Apple Pay', 'icon': 'assets/icons/apple_pay.png'},
  {'label': 'Amazon Pay', 'icon': 'assets/icons/amazon_pay.png'},
  {'label': 'Amex', 'icon': 'assets/icons/amex.png'},
  {'label': 'Paypal', 'icon': 'assets/icons/paypal.png'},
  {'label': 'Discover', 'icon': 'assets/icons/discover.png'},
  {'label': 'JCB', 'icon': 'assets/icons/jcb.png'},
];
