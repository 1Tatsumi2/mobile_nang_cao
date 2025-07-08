import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_order_screen.dart';
import 'package:do_an_mobile/navigation_menu.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen ({ super.key });

  Widget _buildTimelineItem({
    required String status,
    required String date,
    required String description,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                if(!isFirst)
                Container(
                  width: 2,
                  height: 30,
                  color: isCompleted 
                  ? TColors.primary 
                  : TColors.textSecondary.withOpacity(0.2),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? TColors.primary : TColors.light,
                    border: Border.all(
                      width: 2,
                      color: isCompleted 
                      ? TColors.primary 
                      : TColors.textSecondary,
                    ),
                  ),
                  child: isCompleted ? Icon(
                    Icons.check, 
                    size: 16, 
                    color: TColors.light
                    ) : null,
                ),
                if(isFirst)
                Container(
                  width: 2,
                  height: 50,
                  color: isCompleted 
                  ? TColors.primary 
                  : TColors.textSecondary.withOpacity(0.2),
                ),
                if(!isLast)
                Container(
                  width: 2,
                  height: 30,
                  color: isCompleted 
                  ? TColors.primary 
                  : TColors.textSecondary.withOpacity(0.2),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: TSizes.fontWeightBold,
                      color: isCompleted 
                      ? TColors.primary 
                      : TColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: TColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: TColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: TColors.dark,
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
                  "Track Order",
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: TSizes.fontWeightBold,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColors.white,
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
                    children: [
                      Text(
                        "Estimated Delivery",
                        style: TextStyle(
                          fontSize: TSizes.fontSizeSm,
                          color: TColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "June 1, 2025",
                        style: TextStyle(
                          fontSize: TSizes.fontSizeLg,
                          fontWeight: TSizes.fontWeightBold,
                          color: TColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
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
                            fontWeight: TSizes.fontWeightBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColors.white,
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
                    children: [
                      _buildTimelineItem(
                        status: "Order Placed",
                        date: "June 1, 2025 - 10:30 AM",
                        description: "Your order has been confirmed and is being processed.",
                        isCompleted: true,
                        isFirst: true,
                      ),
                      _buildTimelineItem(
                        status: "Order Processed",
                        date: "June 1, 2025 - 10:30 AM",
                        description: "Your order has been prepared for shipping.",
                        isCompleted: true,
                      ),
                      _buildTimelineItem(
                        status: "In Transit",
                        date: "June 1, 2025 - 10:30 AM",
                        description: "Your order is on its way to you.",
                        isCompleted: true,
                      ),
                      _buildTimelineItem(
                        status: "Out for Delivery",
                        date: "Expected June 2, 2025",
                        description: "Your order will be delivered today.",
                        isCompleted: false,
                      ),
                      _buildTimelineItem(
                        status: "Delivered",
                        date: "Expected June 2, 2025",
                        description: "Your order has been delivered.",
                        isCompleted: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
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
                      Text(
                        "Delivery Details",
                        style: TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          fontWeight: TSizes.fontWeightBold,
                          color: TColors.textPrimary,
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
                              Icons.local_shipping_outlined,
                              color: TColors.primary,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tracking Number",
                                  style: TextStyle(
                                    fontSize: TSizes.fontSizeSm,
                                    color: TColors.textSecondary
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "MRD123456789",
                                  style: TextStyle(
                                    fontSize: TSizes.fontSizeSm,
                                    fontWeight: TSizes.fontWeightBold,
                                    color: TColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {}, 
                            icon: Icon(
                              Icons.copy,
                              color: TColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
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
                              Icons.location_on_outlined,
                              color: TColors.primary,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Address",
                                  style: TextStyle(
                                    fontSize: TSizes.fontSizeSm,
                                    color: TColors.textSecondary
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "828 Su Van Hanh, District 10 \nHo Chi Minh City \nVietnam",
                                  style: TextStyle(
                                    fontSize: TSizes.fontSizeSm,
                                    fontWeight: TSizes.fontWeightW500,
                                    color: TColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {}, 
                            icon: Icon(
                              Icons.copy,
                              color: TColors.primary,
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
                  text: "View Your Orders", 
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ProfileOrderScreen(),
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