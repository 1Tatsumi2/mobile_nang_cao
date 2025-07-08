import 'package:flutter/material.dart';
import 'package:do_an_mobile/services/order_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/order_detail_screen.dart';

class ProfileOrderScreen extends StatefulWidget {
  const ProfileOrderScreen({super.key});

  @override
  State<ProfileOrderScreen> createState() => _ProfileOrderScreenState();
}

class _ProfileOrderScreenState extends State<ProfileOrderScreen> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> statusFilters = [
    'All',
    'New Order',
    'Confirmed', 
    'In Transit',
    'Delivered',
    'Completed',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orderList = await OrderService.getUserOrders();
      print('📦 Loaded ${orderList.length} orders');
      
      // 🔹 DEBUG: In ra status của từng order
      for (var order in orderList) {
        print('Order ${order['orderCode']}: status = "${order['statusName']}"');
      }
      
      setState(() {
        orders = orderList;
        filteredOrders = orderList;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading orders: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error loading orders: $e');
    }
  }

  void _filterOrders() {
    setState(() {
      filteredOrders = orders.where((order) {
        final statusName = order['statusName'] as String? ?? '';
        final orderCode = order['orderCode']?.toString() ?? '';
        
        // 🔹 SỬA LẠI FILTER LOGIC - TRIM VÀ LOWERCASE
        final matchesStatus = selectedFilter == 'All' || 
                             statusName.trim().toLowerCase() == selectedFilter.trim().toLowerCase();
        final matchesSearch = _searchController.text.isEmpty ||
                             orderCode.toLowerCase().contains(_searchController.text.toLowerCase());
        
        // 🔹 DEBUG
        if (selectedFilter != 'All') {
          print('Order ${order['orderCode']}: statusName="$statusName", selectedFilter="$selectedFilter", matches=$matchesStatus');
        }
        
        return matchesStatus && matchesSearch;
      }).toList();
      
      print('🔍 Filtered ${filteredOrders.length} orders from ${orders.length} total');
      print('🔍 Selected filter: "$selectedFilter"');
      print('🔍 Search text: "${_searchController.text}"');
    });
  }

  Future<void> _cancelOrder(String orderCode) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });

      final success = await OrderService.cancelOrder(orderCode);
      
      if (success) {
        _showSuccessSnackBar('Order canceled successfully');
        await _loadOrders();
      } else {
        _showErrorSnackBar('Failed to cancel order');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new order':
        return Colors.blue;
      case 'confirmed':
        return Colors.orange;
      case 'in transit':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'new order':
        return Icons.shopping_cart;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'in transit':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.home;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  // 🔹 SỬA LẠI: DropDown thay vì Chips
  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔹 ROW CHỨA SEARCH VÀ DROPDOWN
          Row(
            children: [
              // Search bar
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search by order code...",
                    hintStyle: const TextStyle(color: TColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: TColors.primaryBackground,
                    prefixIcon: const Icon(Icons.search, color: TColors.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: TColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              _filterOrders();
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update suffixIcon
                    _filterOrders();
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 🔹 STATUS DROPDOWN
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: TColors.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TColors.primary.withOpacity(0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: TColors.primary),
                      style: const TextStyle(
                        color: TColors.textPrimary,
                        fontSize: TSizes.fontSizeSm,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedFilter = newValue;
                          });
                          _filterOrders();
                        }
                      },
                      items: statusFilters.map<DropdownMenuItem<String>>((String value) {
                        final isSelected = value == selectedFilter;
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              if (value != 'All') ...[
                                Icon(
                                  _getStatusIcon(value),
                                  size: 16,
                                  color: _getStatusColor(value),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: isSelected ? TColors.primary : TColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: TSizes.fontSizeSm,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // 🔹 HIỂN THỊ KỂT QUẢ FILTER
          if (selectedFilter != 'All' || _searchController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: TColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Showing ${filteredOrders.length} of ${orders.length} orders',
                      style: const TextStyle(
                        color: TColors.primary,
                        fontSize: TSizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (selectedFilter != 'All' || _searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16, color: TColors.primary),
                      onPressed: () {
                        setState(() {
                          selectedFilter = 'All';
                          _searchController.clear();
                        });
                        _filterOrders();
                      },
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['statusName'] as String? ?? 'Unknown';
    final canCancel = order['canCancel'] as bool? ?? false;
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    // Handle data safely
    final orderCode = order['orderCode']?.toString() ?? 'N/A';
    final createdDate = order['createdDate']?.toString() ?? '';
    final paymentMethod = order['paymentMethod']?.toString() ?? 'Cash on Delivery';
    final itemCount = order['itemCount'] as int? ?? 0;
    final totalAmount = order['totalAmount'] as double? ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(
                orderCode: orderCode,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #$orderCode',
                      style: const TextStyle(
                        fontSize: TSizes.fontSizeMd,
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Order info
              Text(
                'Ordered on ${_formatDate(createdDate)}',
                style: const TextStyle(
                  fontSize: TSizes.fontSizeSm,
                  color: TColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: TColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    paymentMethod,
                    style: const TextStyle(
                      fontSize: TSizes.fontSizeSm,
                      color: TColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              
              // Items count and total
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: const TextStyle(
                  fontSize: TSizes.fontSizeSm,
                  color: TColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                  ),
                  Text(
                    "\$${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(
                              orderCode: orderCode,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TColors.primary,
                        side: const BorderSide(color: TColors.primary),
                      ),
                    ),
                  ),
                  
                  if (canCancel) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.cancel, size: 16),
                        label: const Text('Cancel'),
                        onPressed: () => _cancelOrder(orderCode),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: TColors.dark,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'My Orders',
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _loadOrders,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          _buildSearchAndFilterSection(),
                          const SizedBox(height: 24),
                          
                          if (filteredOrders.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 64,
                                      color: TColors.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      orders.isEmpty 
                                          ? 'No orders found'
                                          : 'No orders match your filter',
                                      style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd,
                                        color: TColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _loadOrders,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: TColors.primary,
                                        foregroundColor: TColors.light,
                                      ),
                                      child: const Text('Refresh'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...filteredOrders.map((order) => _buildOrderCard(order)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}