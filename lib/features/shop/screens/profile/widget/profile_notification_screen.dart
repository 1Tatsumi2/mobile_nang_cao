// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, unnecessary_import

import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileNotificationScreen extends StatelessWidget {
  const ProfileNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'order',
        'title': 'Order Delivered',
        'message': 'Your order #1234 has been delivered successfully!',
        'time': '2 mins ago',
        'read': false,
        'icon': Icons.local_shipping_outlined,
        'iconColor': TColors.success,
      },
      {
        'type': 'promo',
        'title': 'Special Offer',
        'message': 'Get 50% OFF on all electronics this weekend!',
        'time': '1 hours ago',
        'read': false,
        'icon': Icons.local_offer_outlined,
        'iconColor': TColors.primary,
      },
      {
        'type': 'payment',
        'title': 'Payment Successful',
        'message': 'Payment of \$2999.99 was successful.',
        'time': '3 hours ago',
        'read': true,
        'icon': Icons.payment_outlined,
        'iconColor': TColors.primary,
      },
    ];

    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                title: const Text("Notifications",
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: TSizes.fontWeightBold,
                    fontSize: TSizes.fontSizeLg,
                  ),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: TColors.light.withValues(alpha: 0.2),
                        ),
                      ), 
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Mark all as read functionality
                }, 
                icon: const Icon(
                  Icons.done_all,
                  color: TColors.light,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: notification['read'] ? TColors.light.withValues(alpha: 0.8) : TColors.light,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.dark.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],  
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (notification['iconColor'] as Color).withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            notification['icon'] as IconData,
                            color: notification['iconColor'] as Color,
                            size: TSizes.iconMd,
                          ),
                        ),
                        if(!notification['read'])
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: TColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      notification['title'] as String,
                      style: TextStyle(
                        fontWeight: notification['read'] ? TSizes.fontWeightNormal : TSizes.fontWeightBold,
                        color: TColors.primary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notification['message'] as String,
                          style: const TextStyle(
                            color: TColors.textPrimary,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(notification['time'] as String,
                          style: const TextStyle(
                            color: TColors.textSecondary,
                            fontSize: TSizes.fontSizeXs,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context, 
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.mark_email_read_outlined),
                                  title: const Text("Mark as read"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete_outlined),
                                  title: const Text("Delete notification"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.block_outlined),
                                  title: const Text("Turn off notification"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        color: TColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}