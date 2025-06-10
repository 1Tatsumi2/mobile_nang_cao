import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/http/interface/request_base.dart';

class ProfileNotification extends StatelessWidget{

  final List<Map<String, dynamic>> notifications = [
    {
      'type':  'order',
      'title': 'Order Delivered',
      'message': 'Your order #1234 has been delivered successfully!',
      'time': '2 mins ago',
      'read': false,
      'icon' : Icons.local_shipping_outlined,
      'iconColor': TColors.success,
    },

    {
      'type':  'promo',
      'title': 'Special Offer',
      'message': 'Get 50% OFF on all electronics this weekend!',
      'time': '1 hours ago',
      'read': false,
      'icon' : Icons.local_offer_outlined,
      'iconColor': TColors.primary,
    },

    {
      'type':  'payment',
      'title': 'Payment Successful',
      'message': 'Payment of \$2999.99 was successfully.',
      'time': '3 hours ago',
      'read': false,
      'icon' : Icons.payment_outlined,
      'iconColor': TColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                title: Text("Notifications",
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
                          color: TColors.light.withOpacity(0.1),
                        ),
                      ), 
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {}, 
                icon: Icon(
                  Icons.done_all,
                  color: TColors.light,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: notification['read'] ?  Colors.white54 : TColors.light,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.dark.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],  
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (notification['iconColor'] as Color).withOpacity(0.1),
                          ),
                          child: Icon(
                            notification['icon'] as IconData,
                            color: notification['iconColor'] as Color,
                            size: TSizes.iconLg,
                          ),
                        ),
                        if(!notification['read'])
                        Positioned(
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
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
                        fontWeight: notification['read'] ? TSizes.fontWeightNormal: TSizes.fontWeightBold,
                        color: TColors.primary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(notification['message'] as String,
                          style: TextStyle(
                            color: TColors.textPrimary,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(notification['time'] as String,
                          style: TextStyle(
                            color: TColors.textPrimary,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(context: context, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.mark_email_read_outlined),
                                  title: Text("Mark as read"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete_outlined),
                                  title: Text("Delete notification"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.block_outlined),
                                  title: Text("Turn off notification"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
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