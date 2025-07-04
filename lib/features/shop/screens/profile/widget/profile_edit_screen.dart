import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:do_an_mobile/services/user_service.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/custom_text_field.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';

class ProfileDetailEdit extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final Function(Map<String, dynamic>)? onProfileUpdated; // 🔹 THÊM CALLBACK
  
  const ProfileDetailEdit({
    super.key, 
    this.userProfile,
    this.onProfileUpdated, // 🔹 THÊM PARAMETER
  });

  @override
  State<ProfileDetailEdit> createState() => _ProfileDetailEditState();
}

class _ProfileDetailEditState extends State<ProfileDetailEdit> {
  // Form key
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late final TextEditingController _userNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  // Image variables
  File? _selectedImage;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  // Loading states
  bool isLoading = false;
  bool isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _userNameController = TextEditingController(
      text: widget.userProfile?['userName'] ?? ''
    );
    _emailController = TextEditingController(
      text: widget.userProfile?['email'] ?? ''
    );
    _phoneController = TextEditingController(
      text: widget.userProfile?['phoneNumber'] ?? ''
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Image picker method
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );
      
      if (image != null) {
        if (kIsWeb) {
          // Web platform - use bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImage = File(image.path); // Path is blob URL on web
            _imageBytes = bytes;
          });
        } else {
          // Mobile platform - use file
          setState(() {
            _selectedImage = File(image.path);
          });
        }
        
        // Auto upload avatar when image is selected
        await _uploadAvatar();
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  // Upload avatar method - CẬP NHẬT
  Future<void> _uploadAvatar() async {
    if (_selectedImage == null || widget.userProfile?['email'] == null) return;

    setState(() {
      isUploadingAvatar = true;
    });

    try {
      String avatarUrl;
      
      if (kIsWeb && _imageBytes != null) {
        avatarUrl = await UserService.uploadAvatarBytes(
          widget.userProfile!['email'],
          _imageBytes!,
        );
      } else if (_selectedImage != null) {
        avatarUrl = await UserService.uploadAvatarFile(
          widget.userProfile!['email'],
          _selectedImage!,
        );
      } else {
        throw Exception('No image selected');
      }

      if (mounted && avatarUrl.isNotEmpty) {
        // Update local profile data
        setState(() {
          widget.userProfile?['avatar'] = avatarUrl;
        });
        
        // 🔹 NOTIFY PARENT ABOUT PROFILE UPDATE
        if (widget.onProfileUpdated != null) {
          widget.onProfileUpdated!({'avatar': avatarUrl});
        }
        
        _showSuccessSnackBar('Avatar updated successfully!');
        print('✅ Avatar uploaded: $avatarUrl');
      } else {
        _showErrorSnackBar('Failed to upload avatar');
        _resetImageSelection();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error uploading avatar: $e');
        _resetImageSelection();
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploadingAvatar = false;
        });
      }
    }
  }

  void _resetImageSelection() {
    setState(() {
      _selectedImage = null;
      _imageBytes = null;
    });
  }

  // Save profile method - CẬP NHẬT
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final email = widget.userProfile?['email'];
      if (email == null) {
        throw Exception('Email not found');
      }

      final success = await UserService.updateProfile(
        email: email,
        userName: _userNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      if (success && mounted) {
        // 🔹 NOTIFY PARENT ABOUT PROFILE UPDATE
        if (widget.onProfileUpdated != null) {
          widget.onProfileUpdated!({
            'userName': _userNameController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
          });
        }
        
        _showSuccessSnackBar('Profile updated successfully!');
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        _showErrorSnackBar('Failed to update profile. Please check your connection.');
      }
    } catch (e) {
      print('❌ Error in _saveProfile: $e');
      if (mounted) {
        _showErrorSnackBar('Error updating profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Snackbar methods
  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Build avatar widget
  Widget _buildAvatarSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColors.primaryGradient),
            shape: BoxShape.circle,
            border: Border.all(
              color: TColors.light,
              width: 4,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _buildAvatarImage(),
          ),
        ),
        if (isUploadingAvatar)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: TColors.light,
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: isUploadingAvatar ? null : _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: TColors.light,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: TColors.light,
                size: TSizes.iconLg,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    // Show selected image first
    if (_selectedImage != null) {
      if (kIsWeb) {
        return Image.network(
          _selectedImage!.path, // Path is blob URL on web
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 60,
              color: TColors.light,
            );
          },
        );
      } else {
        return Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        );
      }
    }

    // Show current avatar from profile
    if (widget.userProfile?['avatar'] != null && 
        widget.userProfile!['avatar'] != "https://via.placeholder.com/100" &&
        widget.userProfile!['avatar'].toString().isNotEmpty) {
      return Image.network(
        widget.userProfile!['avatar'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.person,
            size: 60,
            color: TColors.light,
          );
        },
      );
    }

    // Default avatar icon
    return const Icon(
      Icons.person,
      size: 60,
      color: TColors.light,
    );
  }

  // Build form section
  Widget _buildFormSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: TSizes.fontSizeMd,
                fontWeight: TSizes.fontWeightBold,
                color: TColors.dark,
              ),
            ),
            const SizedBox(height: 24),
            
            // Username field
            CustomTextField(
              controller: _userNameController,
              label: 'Username',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Email field (disabled)
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email,
              enabled: false, // Email cannot be edited
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Phone field
            CustomTextField(
              controller: _phoneController,
              label: 'Phone',
              prefixIcon: Icons.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            _buildMembershipSection(),
            const SizedBox(height: 24),
            
            // Save button
            GradientButton(
              text: isLoading ? "Saving..." : "Save Changes",
              onPressed: isLoading ? () {} : _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  // Build membership section
  Widget _buildMembershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Membership Information",
          style: TextStyle(
            fontSize: TSizes.fontSizeMd,
            fontWeight: TSizes.fontWeightBold,
            color: TColors.dark,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildMembershipRow(
                'Tier:',
                widget.userProfile?['membershipTier'] ?? 'Basic',
                TColors.primary,
              ),
              const SizedBox(height: 8),
              _buildMembershipRow(
                'Points:',
                '${widget.userProfile?['points'] ?? 0} pts',
                TColors.primary,
              ),
              const SizedBox(height: 8),
              _buildMembershipRow(
                'Discount:',
                '${((widget.userProfile?['discountRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: Stack(
        children: [
          // Header background
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
                // Decorative circle
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
                
                // App bar
                Positioned(
                  top: 48,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: TColors.light,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: TColors.light,
                          fontSize: TSizes.fontSizeLg,
                          fontWeight: TSizes.fontWeightBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAvatarSection(),
                  const SizedBox(height: 24),
                  _buildFormSection(),
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