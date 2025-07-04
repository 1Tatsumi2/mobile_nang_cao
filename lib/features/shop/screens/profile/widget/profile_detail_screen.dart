// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_edit_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatelessWidget{
  const ProfileDetailScreen ({ super.key });
  
  Widget _buildSection(String title, List<Widget> children){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: TSizes.fontSizeMd,
              fontWeight: TSizes.fontWeightBold,
            ),
          ),
          SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color ? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
              size: TSizes.iconMd,
              color: TColors.primary,
            ),
          ),
          SizedBox(width: 16),
          Expanded(child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeSm,
                    color: TColors.secondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(value,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: TSizes.fontWeightW500,
                    color: valueColor ?? TColors.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.only(
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
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Text("Peronal Details",
                          style: TextStyle(
                            color: TColors.light,
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: TSizes.fontWeightBold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: TColors.light,
                        onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => ProfileDetailEditScreen(),
                            )
                          );
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
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: TColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: TColors.light, width: 4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset('assets/images/avatar/profile.jpg'),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: TColors.light,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.dark.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        "Personanl Infomation",
                        [
                          _buildInfoRow(
                            icon: Icons.person, 
                            label: "Full Name", 
                            value: "Vo Tan Dung",
                          ),
                          _buildInfoRow(
                            icon: Icons.mail, 
                            label: "Email", 
                            value: "iamvotandung26@gmail.com",
                          ),
                          _buildInfoRow(
                            icon: Icons.phone, 
                            label: "Phone", 
                            value: "+84 942 084 320",
                          ),
                        ],
                      ),
                      _buildSection(
                        "More",
                        [
                          _buildInfoRow(
                            icon: Icons.calendar_today, 
                            label: "Date of Birth", 
                            value: "26 Sep 2004",
                          ),
                          _buildInfoRow(
                            icon: Icons.person, 
                            label: "Gender", 
                            value: "Male",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}