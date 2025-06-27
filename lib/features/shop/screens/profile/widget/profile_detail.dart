// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_edit.dart';
import 'package:do_an_mobile/services/user_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await UserService.getUserProfile();
      if (mounted) {
        setState(() {
          userProfile = profile;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error loading profile: $e');
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: TSizes.fontSizeMd,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: TSizes.iconMd,
              color: TColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: TSizes.fontSizeSm,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? TColors.primary,
                  ),
                ),
              ],
            ),
          ), // ← THÊM DẤU PHẨY TẠI ĐÂY
        ],
      ),
    );
  }

  String _getDiscountPercentage(dynamic discountRate) {
    if (discountRate == null) return "0.0";

    try {
      double rate = 0.0;
      if (discountRate is num) {
        rate = discountRate.toDouble();
      } else if (discountRate is String) {
        rate = double.tryParse(discountRate) ?? 0.0;
      }
      return (rate * 100).toStringAsFixed(1);
    } catch (e) {
      return "0.0";
    }
  }

  Color _getTierColor(String? tier) {
    switch (tier?.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: TColors.light,
        body: Center(
          child: CircularProgressIndicator(color: TColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColors.primary,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: TColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
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
                      color: TColors.light.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: TColors.light,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Personal Details",
                          style: TextStyle(
                            color: TColors.light,
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: TColors.light,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileDetailEdit(
                                userProfile: userProfile,
                                onProfileUpdated: (updates) {
                                  // 🔹 UPDATE LOCAL STATE IMMEDIATELY
                                  setState(() {
                                    userProfile?.addAll(updates);
                                  });
                                  print('Profile updated in detail: ${updates.keys}');
                                },
                              ),
                            ),
                          );

                          // 🔹 REFRESH PROFILE DATA AFTER EDIT
                          if (result == true) {
                            _loadUserProfile();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: TColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: TColors.light, width: 4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: userProfile?['avatar'] != null &&
                              userProfile!['avatar'] != "https://via.placeholder.com/100" &&
                              userProfile!['avatar'].toString().isNotEmpty
                          ? Image.network(
                              userProfile!['avatar'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: TColors.light,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                              color: TColors.light,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.dark.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          "Personal Information",
                          [
                            _buildInfoRow(
                              icon: Icons.person,
                              label: "Full Name",
                              value: userProfile?['userName']?.toString() ?? "N/A",
                            ),
                            _buildInfoRow(
                              icon: Icons.mail,
                              label: "Email",
                              value: userProfile?['email']?.toString() ?? "N/A",
                            ),
                            _buildInfoRow(
                              icon: Icons.phone,
                              label: "Phone",
                              value: userProfile?['phoneNumber']?.toString() ?? "N/A",
                            ),
                          ],
                        ),
                        _buildSection(
                          "Membership Information",
                          [
                            _buildInfoRow(
                              icon: Icons.star,
                              label: "Membership Tier",
                              value: userProfile?['membershipTier']?.toString() ?? "Basic",
                              valueColor: _getTierColor(userProfile?['membershipTier']?.toString()),
                            ),
                            _buildInfoRow(
                              icon: Icons.wallet,
                              label: "Points",
                              value: "${userProfile?['points'] ?? 0} pts",
                              valueColor: TColors.primary,
                            ),
                            _buildInfoRow(
                              icon: Icons.discount,
                              label: "Discount Rate",
                              value: "${_getDiscountPercentage(userProfile?['discountRate'])}%",
                              valueColor: Colors.green,
                            ),
                          ],
                        ),
                        _buildSection(
                          "Statistics",
                          [
                            _buildInfoRow(
                              icon: Icons.shopping_bag,
                              label: "Total Orders",
                              value: "${userProfile?['orderCount'] ?? 0}",
                              valueColor: Colors.blue,
                            ),
                            _buildInfoRow(
                              icon: Icons.favorite,
                              label: "Wishlist Items",
                              value: "${userProfile?['wishlistCount'] ?? 0}",
                              valueColor: Colors.red,
                            ),
                            _buildInfoRow(
                              icon: Icons.local_shipping,
                              label: "Delivered Orders",
                              value: "${userProfile?['shippingCount'] ?? 0}",
                              valueColor: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}