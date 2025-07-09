import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class WarrantyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> warranty;

  const WarrantyDetailScreen({super.key, required this.warranty});

  @override
  State<WarrantyDetailScreen> createState() => _WarrantyDetailScreenState();
}

class _WarrantyDetailScreenState extends State<WarrantyDetailScreen> {
  late Map<String, dynamic> warrantyData;

  @override
  void initState() {
    super.initState();
    warrantyData = Map<String, dynamic>.from(widget.warranty);
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
          'Warranty Details',
          style: TextStyle(
            color: TColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: TColors.primary),
            onPressed: () => _copyWarrantyCode(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarrantyHeader(),
            const SizedBox(height: 24),
            _buildProductInfo(),
            const SizedBox(height: 24),
            _buildWarrantyStatus(),
            const SizedBox(height: 24),
            _buildTimeline(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantyHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.shield_tick,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warranty Code',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      warrantyData['warrantyCode'] ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _copyWarrantyCode,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusChip(),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final status = warrantyData['status'] as int;
    final statusName = warrantyData['statusName'] as String;
    final statusColor = _getStatusColor(warrantyData['statusColor']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusName,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TColors.light,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: warrantyData['productImage'] != null
                      ? Image.network(
                          'http://localhost:5139/media/products/${warrantyData['productImage']}',
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
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warrantyData['productName'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TColors.dark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Warranty Coverage',
                        style: TextStyle(
                          fontSize: 12,
                          color: TColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          _buildInfoRow('Reason', warrantyData['reason'] ?? 'N/A'),
          if (warrantyData['warrantyExpirationDate'] != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              'Warranty Expires',
              _formatDate(warrantyData['warrantyExpirationDate']),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: TColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: TColors.dark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarrantyStatus() {
    final status = warrantyData['status'] as int;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildStatusInfo(status),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(int status) {
    String statusDescription = '';
    String actionText = '';
    Color statusColor = TColors.darkGrey;
    
    switch (status) {
      case 0:
        statusDescription = 'Your warranty request is being reviewed by our team.';
        actionText = 'Please wait for approval';
        statusColor = Colors.orange;
        break;
      case 1:
        statusDescription = 'Your warranty has been approved!';
        actionText = '📦 Please send your defective product to the store';
        statusColor = Colors.green;
        break;
      case 2:
        statusDescription = 'We have received your defective product.';
        actionText = 'Product is being inspected';
        statusColor = Colors.blue;
        break;
      case 3:
        statusDescription = 'Your product has been repaired successfully.';
        actionText = '✅ Please visit the store to collect your repaired product';
        statusColor = Colors.purple;
        break;
      case 4:
        statusDescription = 'Warranty service completed successfully.';
        actionText = 'Thank you for using our service';
        statusColor = Colors.green;
        break;
      case 5:
        statusDescription = 'Your warranty request has been rejected.';
        actionText = 'Please contact support for more information';
        statusColor = Colors.red;
        break;
      case 6:
        statusDescription = 'Warranty request has been cancelled.';
        actionText = 'You can submit a new request if needed';
        statusColor = Colors.red;
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (actionText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    actionText,
                    style: TextStyle(
                      fontSize: 13,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTimelineItem(
            'Request Created',
            _formatDate(warrantyData['createdDate']),
            true,
            Icons.create,
          ),
          
          if (warrantyData['updatedDate'] != warrantyData['createdDate'])
            _buildTimelineItem(
              'Last Updated',
              _formatDate(warrantyData['updatedDate']),
              false,
              Icons.update,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, bool isFirst, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isFirst ? TColors.primary : TColors.darkGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TColors.dark,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: TColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final status = warrantyData['status'] as int;
    final canCancel = warrantyData['canCancel'] as bool;
    
    if (!canCancel && status != 1 && status != 3) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: [
        if (canCancel)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCancelDialog(),
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        
        if (status == 1) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              children: [
                const Icon(Icons.local_shipping, color: Colors.orange, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'Send Your Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please ship your defective product to our service center',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: TColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        if (status == 3) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'Collect Your Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your product is ready for pickup at our store',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: TColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _copyWarrantyCode() {
    final warrantyCode = warrantyData['warrantyCode'] ?? '';
    Clipboard.setData(ClipboardData(text: warrantyCode));
    Get.snackbar(
      'Copied!',
      'Warranty code copied to clipboard',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Warranty Request'),
        content: const Text(
          'Are you sure you want to cancel this warranty request? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelWarranty();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _cancelWarranty() {
    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loading
      Get.back(); // Go back to warranty list
      Get.snackbar(
        'Success',
        'Warranty request has been cancelled',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
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
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}