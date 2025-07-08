import 'package:do_an_mobile/features/shop/screens/cart/widgets/order_tracking_screen.dart';
import 'package:do_an_mobile/features/shop/screens/home/home.dart';
import 'package:do_an_mobile/navigation_menu.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen ({ super.key });

  Widget _buildOrderItem( {
    required String image,
    required String name,
    required String variant,
    required double price,
    required int quantity,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    color: TColors.dark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  variant,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    color: TColors.dark,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeMd,
                        color: TColors.primary,
                      ),
                    ),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(
                        color: TColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isPrimary = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: TSizes.fontSizeMd,
              color: TColors.primary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: TSizes.fontSizeMd,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              color: isPrimary ? TColors.primary : TColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: TColors.light,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: TColors.dark,
            foregroundColor: TColors.light,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'Order Details',
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order #12345",
                              style: TextStyle(
                                fontSize: TSizes.fontSizeLg,
                                fontWeight: FontWeight.bold,
                                color: TColors.dark,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: TColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "In Transit",
                                style: TextStyle(
                                  color: TColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Ordered on June 1, 2025",
                          style: TextStyle(
                            color: TColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Items",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                      color: TColors.dark,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildOrderItem(
                    image: 'assets/images/wishlist/gucci_bag.png', 
                    name: 'Premium Merdi Bag', 
                    variant: 'Color: Brown | Material: Leather', 
                    price: 1000, 
                    quantity: 2,
                  ),
                  _buildOrderItem(
                    image: 'assets/images/wishlist/gucci_bag.png', 
                    name: 'Premium Merdi Bag ver 2', 
                    variant: 'Color: Black | Material: Leather', 
                    price: 1000.00, 
                    quantity: 2,
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                            color: TColors.dark,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDetailItem("Subtotal", '\$2000.00'),
                        _buildDetailItem('Shipping', '\$5.00'),
                        Divider(height: 24),
                        _buildDetailItem('Total', '\$2005.00', isPrimary: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shipping Details",
                          style: TextStyle(
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                            color: TColors.dark,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDetailItem('Name', 'Vo Tan Dung'),
                        _buildDetailItem('Phong', '+84 942 084 320'),
                        _buildDetailItem('Address', '828 Su Van Hanh, District 10 \nHo Chi Minh City \nVietnam'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                            color: TColors.dark,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.credit_card,
                                color: TColors.primary,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stripe",
                                    style: TextStyle(
                                      fontSize: TSizes.fontSizeMd,
                                      color: TColors.dark,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "**** **** **** 4242",
                                    style: TextStyle(
                                      color: TColors.dark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColors.light,
          boxShadow: [
            BoxShadow(
              color: TColors.dark.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: "Tracking Order", 
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => OrderTrackingScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GradientButton(
                  text: "Home", 
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => NavigationMenu()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}