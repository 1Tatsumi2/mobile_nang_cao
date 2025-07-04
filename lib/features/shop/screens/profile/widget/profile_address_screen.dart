import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_screen.dart';
import 'package:do_an_mobile/services/user_service.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/features/shop/screens/profile/profile_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/custom_text_field.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD:lib/features/shop/screens/profile/widget/profile_address.dart
class ProfileAddress extends StatefulWidget {
  const ProfileAddress({super.key});

  @override
  State<ProfileAddress> createState() => _ProfileAddressState();
}

class _ProfileAddressState extends State<ProfileAddress> {
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;
  int selectedAddressIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final addressList = await UserService.getUserAddresses();
      setState(() {
        addresses = addressList;
        isLoading = false;
        // Tìm địa chỉ default
        for (int i = 0; i < addresses.length; i++) {
          if (addresses[i]['isDefault'] == true) {
            selectedAddressIndex = i;
            break;
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading addresses: $e');
    }
  }

  Future<void> _setDefaultAddress(int addressId, int index) async {
    try {
      final success = await UserService.setDefaultAddress(addressId);
      if (success) {
        setState(() {
          // Update local state
          for (int i = 0; i < addresses.length; i++) {
            addresses[i]['isDefault'] = (i == index);
          }
          selectedAddressIndex = index;
        });
        _showSuccessSnackBar('Default address updated');
      } else {
        _showErrorSnackBar('Failed to update default address');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _deleteAddress(int addressId, int index) async {
    try {
      final success = await UserService.deleteAddress(addressId);
      if (success) {
        setState(() {
          addresses.removeAt(index);
          if (selectedAddressIndex == index) {
            selectedAddressIndex = -1;
          } else if (selectedAddressIndex > index) {
            selectedAddressIndex--;
          }
        });
        _showSuccessSnackBar('Address deleted successfully');
      } else {
        _showErrorSnackBar('Failed to delete address');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAddressDialog(
        onAddressAdded: () {
          _loadAddresses(); // Reload addresses
        },
      ),
    );
  }

  void _showEditAddressDialog(Map<String, dynamic> address, int index) {
    showDialog(
      context: context,
      builder: (context) => EditAddressDialog(
        address: address,
        onAddressUpdated: () {
          _loadAddresses(); // Reload addresses
        },
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }


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
            onPressed: _showAddAddressDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No addresses found'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddAddressDialog,
                        child: Text('Add Address'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final isSelected = address['isDefault'] == true;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () => _setDefaultAddress(address['id'], index),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? TColors.primary : TColors.light,
                              border: Border.all(
                                color: TColors.primary,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(Icons.check, size: 12, color: TColors.light)
                                : null,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                address['fullName'] ?? '',
                                style: TextStyle(fontWeight: TSizes.fontWeightBold),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: TColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Default',
                                  style: TextStyle(
                                    color: TColors.light,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address['phoneNumber'] ?? ''),
                            SizedBox(height: 4),
                            Text(address['fullAddress'] ?? ''),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditAddressDialog(address, index);
                            } else if (value == 'delete') {
                              _showDeleteConfirmDialog(address['id'], index);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _setDefaultAddress(address['id'], index),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDeleteConfirmDialog(int addressId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAddress(addressId, index);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Dialog for adding new address
class AddAddressDialog extends StatefulWidget {
  final VoidCallback onAddressAdded;

  const AddAddressDialog({super.key, required this.onAddressAdded});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _wardController = TextEditingController();
  final _detailAddressController = TextEditingController();
  bool _isDefault = false;
  bool _isLoading = false;

  Future<void> _addAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = await AuthService.getCurrentUserEmail();
      if (email == null) {
        throw Exception('User email not found');
      }

      final success = await UserService.addAddress(
        email: email,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        city: _cityController.text,
        district: _districtController.text,
        ward: _wardController.text,
        detailAddress: _detailAddressController.text,
        isDefault: _isDefault,
      );

      if (success) {
        Navigator.pop(context);
        widget.onAddressAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to add address');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  prefixIcon: Icons.phone,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _cityController,
                  label: 'City',
                  prefixIcon: Icons.location_city,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _districtController,
                  label: 'District',
                  prefixIcon: Icons.map,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _wardController,
                  label: 'Ward',
                  prefixIcon: Icons.place,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _detailAddressController,
                  label: 'Detail Address',
                  prefixIcon: Icons.home,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Set as default address'),
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() {
                      _isDefault = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addAddress,
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dialog for editing address
class EditAddressDialog extends StatefulWidget {
  final Map<String, dynamic> address;
  final VoidCallback onAddressUpdated;

  const EditAddressDialog({
    super.key,
    required this.address,
    required this.onAddressUpdated,
  });

  @override
  State<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _wardController;
  late final TextEditingController _detailAddressController;
  late bool _isDefault;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address['fullName'] ?? '');
    _phoneController = TextEditingController(text: widget.address['phoneNumber'] ?? '');
    _cityController = TextEditingController(text: widget.address['city'] ?? '');
    _districtController = TextEditingController(text: widget.address['district'] ?? '');
    _wardController = TextEditingController(text: widget.address['ward'] ?? '');
    _detailAddressController = TextEditingController(text: widget.address['detailAddress'] ?? '');
    _isDefault = widget.address['isDefault'] ?? false;
  }

  Future<void> _updateAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = await AuthService.getCurrentUserEmail();
      if (email == null) {
        throw Exception('User email not found');
      }

      final success = await UserService.updateAddress(
        addressId: widget.address['id'],
        email: email,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        city: _cityController.text,
        district: _districtController.text,
        ward: _wardController.text,
        detailAddress: _detailAddressController.text,
        isDefault: _isDefault,
      );

      if (success) {
        Navigator.pop(context);
        widget.onAddressUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update address');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  prefixIcon: Icons.phone,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _cityController,
                  label: 'City',
                  prefixIcon: Icons.location_city,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _districtController,
                  label: 'District',
                  prefixIcon: Icons.map,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _wardController,
                  label: 'Ward',
                  prefixIcon: Icons.place,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CustomTextField(
                  controller: _detailAddressController,
                  label: 'Detail Address',
                  prefixIcon: Icons.home,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Set as default address'),
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() {
                      _isDefault = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateAddress,
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}