import 'package:do_an_mobile/features/shop/screens/profile/profile_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileAddressScreen extends StatelessWidget{
  const ProfileAddressScreen ({ super.key });
  
  static final ValueNotifier<int> selectedAddressIndex = ValueNotifier<int> (0);
  final List<Map<String, String>> addresses = const [
    {
      'name': 'Vo Tan Dung',
      'phone': '+84 942 084 320',
      'address': 'abcxyz'
    },
    {
      'name': 'Vo Tan Dung',
      'phone': '+84 123 456 789',
      'address': 'defghi'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address', style: TextStyle(fontWeight: TSizes.fontWeightBold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () { 
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ProfileScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedAddressIndex, 
        builder: (context, selectedIndex, _) {
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              final isSelected = selectedIndex == index;

              return ListTile(
                leading: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ?  TColors.dark : TColors.light,
                    border: Border.all(
                      color: TColors.dark,
                      width: 2,
                    ),
                  ),
                ),
                title: Text(
                  address['name']!,
                  style: TextStyle(fontWeight: TSizes.fontWeightBold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address['phone']!),
                    SizedBox(height: 4),
                    Text(address['address']!)
                  ],
                ),
                onTap: () { selectedAddressIndex.value = index; },
              );
            },
          );
        }
      ),
    );
  }
}