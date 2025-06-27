// ignore: unused_import
// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/authentication/screens/login/login.dart';
import 'package:do_an_mobile/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_address_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_detail_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_notification_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_order_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  Widget _buildActionCard ({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }){
      return Expanded(child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            SizedBox(height: 8),
            Text(value,
              style: TextStyle(
                fontSize: TSizes.fontSizeXLg,
                fontWeight: TSizes.fontWeightBold,
                color: TColors.dark,
              ),
            ),
            SizedBox(height: 4),
            Text(title,
              style: TextStyle(
                fontSize: TSizes.fontSizeSm,
                color: TColors.dark,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection ({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: TSizes.fontSizeLg,
              fontWeight: TSizes.fontWeightBold,
              color: TColors.dark,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            boxShadow: [
              BoxShadow(
                color: TColors.dark.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
            )],
          ),
          child: Column(
            children: items,
            ),
        )
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isDestructive ? TColors.dark.withOpacity(0.1) : color.withOpacity(0.1),
              ),
              child: Icon(icon, 
              color: isDestructive ? TColors.dark : color,
              size: TSizes.iconMd,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: TSizes.fontWeightBold,
                      color: isDestructive ? TColors.dark : TColors.dark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: TSizes.fontSizeSm,
                      color: TColors.dark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: TSizes.iconMd,
              color: TColors.dark,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.light,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColors.primaryGradient,
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(TSizes.cardRadiusLg),
                  bottomRight: Radius.circular(TSizes.cardRadiusLg),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: TColors.light,
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.dark.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/avatar/profile.jpg'),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Vo Tan Dung",
                            style: TextStyle(
                              fontSize: TSizes.lg,
                              color: TColors.dark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "iamvotandung26@gmail.com",
                            style: TextStyle(
                              fontSize: TSizes.md,
                              fontWeight: TSizes.fontWeightNormal,
                              color: TColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildActionCard(
                            icon: Icons.shopping_bag_outlined, 
                            title: 'Orders', 
                            value: '12', 
                            color: TColors.buttonPrimary,
                          ),
                          SizedBox(width: 12),
                          _buildActionCard(
                            icon: Icons.favorite_border_outlined, 
                            title: 'Wishlist', 
                            value: '4', 
                            color: TColors.buttonPrimary,
                          ),
                          SizedBox(width: 12),
                          _buildActionCard(
                            icon: Icons.local_shipping_outlined, 
                            title: 'Shipping', 
                            value: '2', 
                            color: TColors.buttonPrimary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildSection(
                          title: 'Account Setting', 
                          items: [
                            _buildMenuItem(
                              icon: Icons.person_outlined, 
                              title: 'Personal Details', 
                              subtitle: "Update your personal infomation", 
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProfileDetailScreen()),
                                );
                              }, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.lock_outlined, 
                              title: 'Change Password', 
                              subtitle: "Update your password",
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ForgetPassword()),
                                );
                              }, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.notifications_outlined, 
                              title: 'Notifiaction', 
                              subtitle: "Manage your notification", 
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>ProfileNotificationScreen()),
                                );
                              }, 
                              color: TColors.primary
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildSection(
                          title: 'Shopping Preferences', 
                          items: [
                            _buildMenuItem(
                              icon: Icons.shopping_bag_outlined, 
                              title: 'Your Orders', 
                              subtitle: "View your orders history", 
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProfileOrderScreen()),
                                );
                              }, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.location_on_outlined, 
                              title: 'Shipping Address', 
                              subtitle: "Manage your delivery addresses",
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProfileAddressScreen()),
                                );
                              }, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.payment_outlined, 
                              title: 'Payment Methods', 
                              subtitle: "Manage your payment options", 
                              onTap: () {}, 
                              color: TColors.primary
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildSection(
                          title: 'More', 
                          items: [
                            _buildMenuItem(
                              icon: Icons.settings_outlined, 
                              title: 'Settings', 
                              subtitle: "App preferences and settings", 
                              onTap: () {}, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.help_outlined, 
                              title: 'Help & Support', 
                              subtitle: "Get help and contact us",
                              onTap: () {}, 
                              color: TColors.primary
                              ),
                              _buildMenuItem(
                              icon: Icons.logout, 
                              title: 'Log Out', 
                              subtitle: "Sign out from your account", 
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              }, 
                              color: TColors.dark,
                              isDestructive: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100)
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}