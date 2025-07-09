import 'package:flutter/material.dart';
import 'package:do_an_mobile/services/warranty_service.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'warranty_detail_screen.dart';

class ProfileWarrantyScreen extends StatefulWidget {
  const ProfileWarrantyScreen({super.key});

  @override
  State<ProfileWarrantyScreen> createState() => _ProfileWarrantyScreenState();
}

class _ProfileWarrantyScreenState extends State<ProfileWarrantyScreen> {
  List<Map<String, dynamic>> warranties = [];
  bool isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadWarranties();
  }

  Future<void> _loadWarranties() async {
    try {
      userEmail = await AuthService.getCurrentUserEmail();
      if (userEmail == null) {
        Get.snackbar('Error', 'User session expired. Please login again.');
        return;
      }

      final warrantyList = await WarrantyService.getUserWarranties(userEmail!);
      
      if (mounted) {
        setState(() {
          warranties = warrantyList;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading warranties: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _cancelWarranty(int warrantyId) async {
    if (userEmail == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Warranty'),
        content: const Text('Are you sure you want to cancel this warranty request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await WarrantyService.cancelWarranty(
        email: userEmail!,
        warrantyId: warrantyId,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _loadWarranties(); // Refresh list
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showRequestWarrantyDialog() {
    final warrantyCodeController = TextEditingController();
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Request Warranty'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: warrantyCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Warranty Code',
                    hintText: 'Enter warranty code from your order',
                    prefixIcon: Icon(Iconsax.shield_tick),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter warranty code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    hintText: 'Describe the issue',
                    prefixIcon: Icon(Iconsax.document_text),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can find the warranty code in your order details after the order is completed.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : () async {
                if (formKey.currentState!.validate()) {
                  setDialogState(() {
                    isSubmitting = true;
                  });

                  final result = await WarrantyService.requestWarranty(
                    email: userEmail!,
                    warrantyCode: warrantyCodeController.text.trim(),
                    reason: reasonController.text.trim(),
                  );

                  Navigator.pop(context);

                  if (result['success'] == true) {
                    Get.snackbar(
                      'Success',
                      result['message'],
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    _loadWarranties(); // Refresh list
                  } else {
                    Get.snackbar(
                      'Error',
                      result['message'],
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              child: isSubmitting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit'),
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
      appBar: AppBar(
        backgroundColor: TColors.light,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: TColors.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Warranties',
          style: TextStyle(
            color: TColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: TColors.primary),
            )
          : warranties.isEmpty
              ? _buildEmptyState()
              : _buildWarrantyList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRequestWarrantyDialog,
        backgroundColor: TColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.shield_tick,
              size: 64,
              color: TColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Warranty Requests',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You haven\'t made any warranty requests yet.\nTap the + button to request warranty for your products.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: TColors.darkGrey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showRequestWarrantyDialog,
            icon: const Icon(Icons.add),
            label: const Text('Request Warranty'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarrantyList() {
    return RefreshIndicator(
      onRefresh: _loadWarranties,
      color: TColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: warranties.length,
        itemBuilder: (context, index) {
          final warranty = warranties[index];
          return _buildWarrantyCard(warranty);
        },
      ),
    );
  }

  Widget _buildWarrantyCard(Map<String, dynamic> warranty) {
    final status = warranty['status'] as int;
    final statusName = warranty['statusName'] as String;
    final statusColor = _getStatusColor(warranty['statusColor']);
    final canCancel = warranty['canCancel'] as bool;

    return GestureDetector(
      // 🔹 THÊM ONTAP ĐỂ NAVIGATE ĐẾN DETAIL SCREEN
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WarrantyDetailScreen(warranty: warranty),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Code: ${warranty['warrantyCode']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          statusName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 🔹 THÊM ARROW ICON ĐỂ CHỈ DẪN CÓ THỂ TAP
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: TColors.darkGrey,
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: TColors.light,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: warranty['productImage'] != null
                          ? Image.network(
                              'http://localhost:5139/media/products/${warranty['productImage']}',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: TColors.primary.withOpacity(0.1),
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('❌ Error loading warranty image: ${warranty['productImage']}, Error: $error');
                                return const Icon(
                                  Icons.image_not_supported,
                                  color: TColors.darkGrey,
                                );
                              },
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              color: TColors.darkGrey,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warranty['productName'] ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reason: ${warranty['reason']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: TColors.darkGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // 🔹 THÊM "TAP TO VIEW DETAILS"
                        Text(
                          'Tap to view details →',
                          style: TextStyle(
                            fontSize: 12,
                            color: TColors.primary,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created: ${_formatDate(warranty['createdDate'])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: TColors.darkGrey,
                          ),
                        ),
                        if (warranty['updatedDate'] != warranty['createdDate'])
                          Text(
                            'Updated: ${_formatDate(warranty['updatedDate'])}',
                            style: TextStyle(
                              fontSize: 12,
                              color: TColors.darkGrey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (canCancel)
                    TextButton(
                      onPressed: () => _cancelWarranty(warranty['id']),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                ],
              ),
              
              if (status == 1)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text(
                    '📦 Please send your defective product to the store',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              
              if (status == 3)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    '✅ Please visit the store to collect your repaired product',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'info':
        return Colors.blue;
      case 'primary':
        return TColors.primary;
      case 'dark':
        return TColors.dark;
      case 'danger':
        return Colors.red;
      default:
        return TColors.darkGrey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}