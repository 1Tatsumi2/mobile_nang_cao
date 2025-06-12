import 'package:flutter/material.dart';

class ShippingInformation extends StatefulWidget {
  const ShippingInformation({super.key});

  @override
  State<ShippingInformation> createState() => _ShippingInformationState();
}

class _ShippingInformationState extends State<ShippingInformation> {
  String? selectedCity = 'Tỉnh Thành';
  String? selectedDistrict = 'Quận Huyện';
  String? selectedSubDistrict = 'Phường Xã';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHIPPING INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),

        // Choose City
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose City',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCity,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    DropdownMenuItem(
                      value: 'Tỉnh Thành',
                      child: Text('Tỉnh Thành'),
                    ),
                    DropdownMenuItem(value: 'Hà Nội', child: Text('Hà Nội')),
                    DropdownMenuItem(
                      value: 'Hồ Chí Minh',
                      child: Text('Hồ Chí Minh'),
                    ),
                    DropdownMenuItem(value: 'Đà Nẵng', child: Text('Đà Nẵng')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Choose District
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose District',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDistrict,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    DropdownMenuItem(
                      value: 'Quận Huyện',
                      child: Text('Quận Huyện'),
                    ),
                    DropdownMenuItem(value: 'Quận 1', child: Text('Quận 1')),
                    DropdownMenuItem(value: 'Quận 2', child: Text('Quận 2')),
                    DropdownMenuItem(value: 'Quận 3', child: Text('Quận 3')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Choose Sub-district
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Sub-district',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSubDistrict,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    DropdownMenuItem(
                      value: 'Phường Xã',
                      child: Text('Phường Xã'),
                    ),
                    DropdownMenuItem(
                      value: 'Phường 1',
                      child: Text('Phường 1'),
                    ),
                    DropdownMenuItem(
                      value: 'Phường 2',
                      child: Text('Phường 2'),
                    ),
                    DropdownMenuItem(
                      value: 'Phường 3',
                      child: Text('Phường 3'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSubDistrict = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Detailed Address
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Address:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
