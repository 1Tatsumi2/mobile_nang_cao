import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:do_an_mobile/features/authentication/screens/login/login.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_address_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_detail_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_notification_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_order_screen.dart';
import 'package:do_an_mobile/services/user_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/change_password_screen.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_warranty_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('App resumed - refreshing profile');
      _refreshProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      print('🔄 Loading user profile...');
      final profile = await UserService.getUserProfile(forceRefresh: true);
      
      if (mounted) {
        setState(() {
          userProfile = profile;
          isLoading = false;
        });
        print('✅ Profile loaded successfully: ${profile?['userName']}');
        print('Avatar URL: ${profile?['avatar']}');
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshProfile() async {
    try {
      print('🔄 Refreshing profile data...');
      final profile = await UserService.getUserProfile(forceRefresh: true);
      
      if (mounted && profile != null) {
        setState(() {
          userProfile = profile;
          isLoading = false;
        });
        print('✅ Profile refreshed: ${profile['userName']}');
        print('Avatar URL: ${profile['avatar']}');
      }
    } catch (e) {
      print('❌ Error refreshing profile: $e');
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Widget _buildHeaderSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: TColors.light.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TColors.light.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAvatarSection(),
          const SizedBox(height: 16),
          _buildUserNameSection(),
          const SizedBox(height: 8),
          _buildUserEmailSection(),
          const SizedBox(height: 12),
          _buildMembershipBadge(),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: TColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: TColors.light,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _buildAvatarImage(),
      ),
    );
  }

  Widget _buildAvatarImage() {
    final avatarUrl = userProfile?['avatar'];
    
    if (avatarUrl != null && 
        avatarUrl != "https://via.placeholder.com/100" &&
        avatarUrl.toString().isNotEmpty) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: TColors.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading avatar: $error');
          return Container(
            color: TColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.person,
              size: 50,
              color: TColors.primary,
            ),
          );
        },
      );
    }
    
    return Container(
      color: TColors.primary.withOpacity(0.1),
      child: const Icon(
        Icons.person,
        size: 50,
        color: TColors.primary,
      ),
    );
  }

  Widget _buildUserNameSection() {
    return Text(
      userProfile?['userName'] ?? "User Name",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: TColors.dark,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserEmailSection() {
    return Text(
      userProfile?['email'] ?? "email@example.com",
      style: TextStyle(
        fontSize: 14,
        color: TColors.dark.withValues(alpha: 0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMembershipBadge() {
    final tier = userProfile?['membershipTier'] ?? 'Basic';
    final points = userProfile?['points'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getTierGradient(tier),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getTierColor(tier).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTierIcon(tier),
            color: TColors.light,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$tier • $points pts',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: TColors.light,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders',
              value: '${userProfile?['orderCount'] ?? 0}',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_border_outlined,
              title: 'Wishlist',
              value: '${userProfile?['wishlistCount'] ?? 0}',
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_shipping_outlined,
              title: 'Shipping',
              value: '${userProfile?['shippingCount'] ?? 0}',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: TColors.dark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: TColors.dark,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(
              color: TColors.dark.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : TColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: TColors.dark.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: TColors.dark.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey;
      case 'bronze':
        return Colors.brown;
      default:
        return TColors.primary;
    }
  }

  List<Color> _getTierGradient(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
        return [Colors.amber, Colors.orange];
      case 'silver':
        return [Colors.grey, Colors.blueGrey];
      case 'bronze':
        return [Colors.brown, Colors.orange.shade800];
      default:
        return TColors.primaryGradient;
    }
  }

  IconData _getTierIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
        return Icons.star;
      case 'silver':
        return Icons.star_half;
      case 'bronze':
        return Icons.star_border;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: TColors.light,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: TColors.primary),
              const SizedBox(height: 16),
              const Text(
                'Loading profile...',
                style: TextStyle(
                  color: TColors.dark,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Cách 2: Wrap toàn bộ content trong SafeArea
    return Scaffold(
      backgroundColor: TColors.light,
      body: SafeArea( // 🔹 THÊM SAFEAREA
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          color: TColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                _buildHeaderSection(),
                
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                  ),
                  child: Column(
                    children: [
                      _buildUserInfoCard(),
                      
                      const SizedBox(height: 24),
                      
                      _buildStatisticsSection(),
                      
                      const SizedBox(height: 24),
                      
                      _buildMenuSection(
                        title: 'Account Settings',
                        items: [
                          _buildMenuItem(
                            icon: Icons.person_outlined,
                            title: 'Personal Details',
                            subtitle: 'Update your personal information',
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileDetailScreen(),
                                ),
                              );
                              await _refreshProfile();
                            },
                            color: TColors.primary,
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage your notifications',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileNotificationScreen(),
                                ),
                              );
                            },
                            color: TColors.primary,
                            isLast: true,
                          ),
                        ],
                      ),
                      
                      _buildMenuSection(
                        title: 'My Activity',
                        items: [
                          _buildMenuItem(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Your Orders',
                            subtitle: 'View your order history',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileOrderScreen(),
                                ),
                              );
                            },
                            color: Colors.blue,
                          ),
                          _buildMenuItem(
                            icon: Icons.location_on_outlined,
                            title: 'Addresses',
                            subtitle: 'Manage your addresses',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileAddressScreen(),
                                ),
                              );
                            },
                            color: Colors.green,
                          ),
                          _buildMenuItem(
                            icon: Icons.shield_outlined,
                            title: 'Warranties',
                            subtitle: 'Manage warranty requests',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileWarrantyScreen(),
                                ),
                              );
                            },
                            color: Colors.purple,
                            isLast: true,
                          ),
                        ],
                      ),
                      
                      _buildMenuSection(
                        title: 'More Options',
                        items: [
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            subtitle: 'App preferences and settings',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Settings feature coming soon!'),
                                ),
                              );
                            },
                            color: Colors.grey,
                          ),
                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            subtitle: 'Update your account password',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChangePasswordScreen(),
                                ),
                              );
                            },
                            color: Colors.orange,
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outlined,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact us',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Help & Support feature coming soon!'),
                                ),
                              );
                            },
                            color: Colors.grey,
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Log Out',
                            subtitle: 'Sign out from your account',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text('Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _logout();
                                      },
                                      child: const Text(
                                        'Log Out',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            color: Colors.red,
                            isDestructive: true,
                            isLast: true,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}