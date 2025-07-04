// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, unused_element
import 'package:do_an_mobile/features/shop/screens/cart/widgets/order_detail_screen.dart';
import 'package:do_an_mobile/features/shop/screens/cart/widgets/order_tracking_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileOrderScreen extends StatelessWidget {
  const ProfileOrderScreen({super.key});

  final List<Map<String, dynamic>> orders = const [
    {
      'orderId': '12345',
      'date': 'June 1, 2025',
      'status': 'In Transit',
      'items': ['Merdi Bag (2x)', 'Merdi Handbag (1x)'],
      'total': 159.99,
    },
    {
      'orderId': '12346',
      'date': 'June 1, 2025',
      'status': 'Delivered',
      'items': ['Merdi Bag (2x)', 'Merdi Handbag (1x)'],
      'total': 159.99,
    },
    {
      'orderId': '12347',
      'date': 'June 1, 2025',
      'status': 'Cancelled',
      'items': ['Merdi Bag (2x)', 'Merdi Handbag (1x)'],
      'total': 159.99,
    },
    {
      'orderId': '12348',
      'date': 'June 1, 2025',
      'status': 'Processing',
      'items': ['Merdi Bag (2x)', 'Merdi Handbag (1x)'],
      'total': 159.99,
    },
  ];
  
  Color _getStatusColor(String status){
    switch(status.toLowerCase()) {
      case "delivered":
        return TColors.success;
      case "in transit":
        return TColors.warning;
      case "processing":
        return TColors.primary;
      case "cancelled":
        return TColors.error;
      default:
        return TColors.secondary;
    }
  }

  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required String status,
    required List<String> items,
    required double total,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order #$orderId',
                    style: const TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: TSizes.fontWeightBold,
                      color: TColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: TSizes.fontWeightBold,
                        fontSize: TSizes.fontSizeSm,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Ordered on $date',
                style: const TextStyle(
                  fontSize: TSizes.fontSizeSm,
                  color: TColors.dark,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                '${items.length} ${items.length == 1 ? 'item' : 'items'}:',
                style: const TextStyle(
                  fontSize: TSizes.fontSizeSm,
                  color: TColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                items.join(', '),
                style: const TextStyle(
                  fontSize: TSizes.fontSizeSm,
                  color: TColors.dark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: TSizes.fontWeightBold,
                      color: TColors.primary,
                    ),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: TSizes.fontWeightBold,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.local_shipping_outlined, size: TSizes.iconSm),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const OrderTrackingScreen())
                      );
                    }, 
                    label: const Text("Track Order"),
                    style: TextButton.styleFrom(
                      foregroundColor: TColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text('My Orders',
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: TSizes.fontWeightBold,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search orders...",
                              hintStyle: const TextStyle(
                                color: TColors.textSecondary,
                              ),
                              border: InputBorder.none,
                              icon: const Icon(
                                Icons.search,
                                color: TColors.textSecondary,
                              ),
                              suffixIcon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: TColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.filter_list,
                                  color: TColors.primary,
                                ),
                              ),
                            ),  
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...orders.map(
                    (order) => _buildOrderCard(
                      orderId: order['orderId'] as String, 
                      date: order['date'] as String, 
                      status: order['status'] as String, 
                      items: List<String>.from(order['items']), 
                      total: order['total'] as double, 
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const OrderDetailScreen()
                          )
                        );
                      }, 
                      context: context,
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
}