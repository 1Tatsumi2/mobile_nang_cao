import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/location_item.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart'; // 🔹 IMPORT ĐỂ SỬ DỤNG ShippingAddressData

class ShippingInformation extends StatefulWidget {
  final void Function(double)? onShippingPriceChanged;
  final void Function(bool)? onShippingSubmitted;
  final void Function(ShippingAddressData)? onShippingAddressChanged; // 🔹 SỬ DỤNG TỪ checkout_request.dart

  const ShippingInformation({
    super.key,
    this.onShippingPriceChanged,
    this.onShippingSubmitted,
    this.onShippingAddressChanged,
  });

  @override
  State<ShippingInformation> createState() => _ShippingInformationState();
}

class _ShippingInformationState extends State<ShippingInformation> {
  List<LocationItem> cities = [];
  List<LocationItem> districts = [];
  List<LocationItem> wards = [];

  LocationItem? selectedCity;
  LocationItem? selectedDistrict;
  LocationItem? selectedWard;
  final TextEditingController addressController = TextEditingController();
  double? shippingPrice;
  bool isShippingSubmitted = false;

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    final res = await http.get(Uri.parse('https://esgoo.net/api-tinhthanh/1/0.htm'));
    final data = jsonDecode(res.body);
    if (data['error'] == 0) {
      setState(() {
        cities = (data['data'] as List).map((e) => LocationItem.fromJson(e)).toList();
      });
    }
  }

  Future<void> fetchDistricts(String cityId) async {
    setState(() {
      districts = [];
      wards = [];
      selectedDistrict = null;
      selectedWard = null;
    });
    final res = await http.get(Uri.parse('https://esgoo.net/api-tinhthanh/2/$cityId.htm'));
    final data = jsonDecode(res.body);
    if (data['error'] == 0) {
      setState(() {
        districts = (data['data'] as List).map((e) => LocationItem.fromJson(e)).toList();
      });
    }
  }

  Future<void> fetchWards(String districtId) async {
    setState(() {
      wards = [];
      selectedWard = null;
    });
    final res = await http.get(Uri.parse('https://esgoo.net/api-tinhthanh/3/$districtId.htm'));
    final data = jsonDecode(res.body);
    if (data['error'] == 0) {
      setState(() {
        wards = (data['data'] as List).map((e) => LocationItem.fromJson(e)).toList();
      });
    }
  }

  Future<void> getShippingPrice() async {
    final url = Uri.parse('${ApiConstants.baseUrl}api/CartApi/GetShippingPrice');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tinh': selectedCity?.name ?? '',
          'quan': selectedDistrict?.name ?? '',
          'phuong': selectedWard?.name ?? '',
          'detailAddress': addressController.text,
        }),
      );
      
      print('URL: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.containsKey('shippingPrice')) {
          setState(() {
            shippingPrice = (data['shippingPrice'] as num).toDouble();
            isShippingSubmitted = true;
          });
          
          // 🔹 TẠO VÀ GỬI SHIPPING ADDRESS DATA - SỬ DỤNG TỪ checkout_request.dart
          final shippingAddressData = ShippingAddressData(
            city: selectedCity?.name ?? '',
            district: selectedDistrict?.name ?? '',
            ward: selectedWard?.name ?? '',
            detailAddress: addressController.text,
          );
          
          // Gọi callback để thông báo shipping đã submit
          if (widget.onShippingPriceChanged != null) {
            widget.onShippingPriceChanged!(shippingPrice!);
          }
          if (widget.onShippingSubmitted != null) {
            widget.onShippingSubmitted!(true);
          }
          if (widget.onShippingAddressChanged != null) {
            widget.onShippingAddressChanged!(shippingAddressData);
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Shipping price: \$${shippingPrice!.toStringAsFixed(0)}')),
          );
        } else {
          throw Exception('shippingPrice not found in response');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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

        // City Dropdown
        DropdownButtonFormField<LocationItem>(
          value: selectedCity,
          decoration: const InputDecoration(labelText: 'Choose City'),
          items: [
            const DropdownMenuItem<LocationItem>(
              value: null,
              child: Text('Tỉnh Thành'),
            ),
            ...cities.map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city.name),
                )),
          ],
          onChanged: (city) {
            setState(() {
              selectedCity = city;
              selectedDistrict = null;
              selectedWard = null;
              districts = [];
              wards = [];
            });
            if (city != null) fetchDistricts(city.id);
          },
        ),
        const SizedBox(height: 20),

        // District Dropdown
        DropdownButtonFormField<LocationItem>(
          value: selectedDistrict,
          decoration: const InputDecoration(labelText: 'Choose District'),
          items: [
            const DropdownMenuItem<LocationItem>(
              value: null,
              child: Text('Quận Huyện'),
            ),
            ...districts.map((d) => DropdownMenuItem(
                  value: d,
                  child: Text(d.name),
                )),
          ],
          onChanged: (district) {
            setState(() {
              selectedDistrict = district;
              selectedWard = null;
              wards = [];
            });
            if (district != null) fetchWards(district.id);
          },
        ),
        const SizedBox(height: 20),

        // Ward Dropdown
        DropdownButtonFormField<LocationItem>(
          value: selectedWard,
          decoration: const InputDecoration(labelText: 'Choose Sub-district'),
          items: [
            const DropdownMenuItem<LocationItem>(
              value: null,
              child: Text('Phường Xã'),
            ),
            ...wards.map((w) => DropdownMenuItem(
                  value: w,
                  child: Text(w.name),
                )),
          ],
          onChanged: (ward) {
            setState(() {
              selectedWard = ward;
            });
          },
        ),
        const SizedBox(height: 20),

        // Detailed Address
        TextFormField(
          controller: addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Detailed Address',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (selectedCity == null ||
                  selectedDistrict == null ||
                  selectedWard == null ||
                  addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please choose all options and enter address!')),
                );
                return;
              }
              await getShippingPrice();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              isShippingSubmitted ? 'UPDATE SHIPPING' : 'SUBMIT',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),

        // Chỉ hiển thị shipping price sau khi submit
        if (isShippingSubmitted && shippingPrice != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shipping Cost:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$${shippingPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// 🔹 XÓA CLASS ShippingAddressData Ở ĐÂY - ĐÃ CÓ TRONG checkout_request.dart
