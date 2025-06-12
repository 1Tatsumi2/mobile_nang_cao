import 'package:flutter/material.dart';

class ProductSelection extends StatefulWidget {
  const ProductSelection({super.key});

  @override
  State<ProductSelection> createState() => _ProductSelectionState();
}

class _ProductSelectionState extends State<ProductSelection> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'YOUR SELECTIONS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),

        // Product Layout - Image on top, details below
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/category/category_1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Product Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Women's G75 sneaker",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Style# Leather - Brown",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Variation: Brown - Leather",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Status and Actions Row
                      Row(
                        children: [
                          // Available Status
                          const Text(
                            'AVAILABLE',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Divider
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 16),

                          // Remove Button
                          TextButton(
                            onPressed: () {
                              // Remove item action
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'REMOVE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Quantity and Price Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Quantity Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedQuantity,
                          isDense: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: List.generate(10, (index) {
                            final value = index + 1;
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedQuantity = value ?? 1;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Price
                    const Text(
                      '\$920',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
