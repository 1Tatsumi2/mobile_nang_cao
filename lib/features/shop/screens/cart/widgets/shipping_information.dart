import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/location_item.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart';
import 'package:do_an_mobile/services/auth_service.dart';

class ShippingInformation extends StatefulWidget {
  final void Function(double)? onShippingPriceChanged;
  final void Function(bool)? onShippingSubmitted;
  final void Function(ShippingAddressData)? onShippingAddressChanged;

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
  // Location data
  List<LocationItem> cities = [];
  List<LocationItem> districts = [];
  List<LocationItem> wards = [];

  LocationItem? selectedCity;
  LocationItem? selectedDistrict;
  LocationItem? selectedWard;
  final TextEditingController addressController = TextEditingController();

  // Shipping data
  double? shippingPrice;
  bool isShippingSubmitted = false;

  // 🔹 THÊM CÁC BIẾN CHO SAVED ADDRESSES
  List<Map<String, dynamic>> savedAddresses = [];
  Map<String, dynamic>? selectedSavedAddress;
  bool isUsingSavedAddress = false;
  bool isLoadingAddresses = false;
  
  // 🔹 THÊM RADIO BUTTON STATE
  String addressInputMethod = 'saved'; // 'saved' hoặc 'manual'

  @override
  void initState() {
    super.initState();
    fetchCities();
    _loadSavedAddresses(); // 🔹 TẢI DANH SÁCH ĐỊA CHỈ ĐÃ LƯU
  }

  // 🔹 TẢI DANH SÁCH ĐỊA CHỈ ĐÃ LƯU
  Future<void> _loadSavedAddresses() async {
    setState(() {
      isLoadingAddresses = true;
    });

    try {
      final userEmail = await AuthService.getCurrentUserEmail();
      if (userEmail == null) {
        print('User not logged in');
        setState(() {
          isLoadingAddresses = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetUserAddresses?email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      print('GetUserAddresses response: ${response.statusCode}');
      print('GetUserAddresses body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            savedAddresses = List<Map<String, dynamic>>.from(data['addresses']);
            isLoadingAddresses = false;
            
            // 🔹 TỰ ĐỘNG CHỌN ĐỊA CHỈ DEFAULT NẾU CÓ
            final defaultAddress = savedAddresses.firstWhere(
              (addr) => addr['isDefault'] == true,
              orElse: () => {},
            );
            
            if (defaultAddress.isNotEmpty) {
              selectedSavedAddress = defaultAddress;
              _applySelectedAddress();
            }
          });
        }
      }
    } catch (e) {
      print('Error loading saved addresses: $e');
      setState(() {
        isLoadingAddresses = false;
      });
    }
  }

  // 🔹 ÁP DỤNG ĐỊA CHỈ ĐÃ CHỌN
  void _applySelectedAddress() {
    if (selectedSavedAddress != null) {
      setState(() {
        // Reset location dropdowns
        selectedCity = null;
        selectedDistrict = null;
        selectedWard = null;
        districts = [];
        wards = [];
        
        // Set address text
        addressController.text = selectedSavedAddress!['detailAddress'] ?? '';
        
        // Set flag
        isUsingSavedAddress = true;
      });
      
      // Tìm và set city
      _findAndSetLocationFromAddress();
    }
  }

  // 🔹 TÌM VÀ SET LOCATION TỪ ĐỊA CHỈ ĐÃ LƯU
  Future<void> _findAndSetLocationFromAddress() async {
    if (selectedSavedAddress == null) return;

    try {
      final cityName = selectedSavedAddress!['city'];
      final districtName = selectedSavedAddress!['district'];
      final wardName = selectedSavedAddress!['ward'];

      // Tìm city
      final city = cities.firstWhere(
        (c) => c.name.toLowerCase().contains(cityName.toLowerCase()),
        orElse: () => LocationItem(id: '', name: ''),
      );

      if (city.id.isNotEmpty) {
        setState(() {
          selectedCity = city;
        });
        
        // Load districts
        await fetchDistricts(city.id);
        
        // Tìm district
        final district = districts.firstWhere(
          (d) => d.name.toLowerCase().contains(districtName.toLowerCase()),
          orElse: () => LocationItem(id: '', name: ''),
        );

        if (district.id.isNotEmpty) {
          setState(() {
            selectedDistrict = district;
          });
          
          // Load wards
          await fetchWards(district.id);
          
          // Tìm ward
          final ward = wards.firstWhere(
            (w) => w.name.toLowerCase().contains(wardName.toLowerCase()),
            orElse: () => LocationItem(id: '', name: ''),
          );

          if (ward.id.isNotEmpty) {
            setState(() {
              selectedWard = ward;
            });
          }
        }
      }
    } catch (e) {
      print('Error setting location from saved address: $e');
    }
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
    
    String cityName, districtName, wardName, detailAddress;
    
    if (isUsingSavedAddress && selectedSavedAddress != null) {
      // 🔹 SỬ DỤNG ĐỊA CHỈ ĐÃ LƯU
      cityName = selectedSavedAddress!['city'] ?? '';
      districtName = selectedSavedAddress!['district'] ?? '';
      wardName = selectedSavedAddress!['ward'] ?? '';
      detailAddress = selectedSavedAddress!['detailAddress'] ?? '';
    } else {
      // 🔹 SỬ DỤNG ĐỊA CHỈ NHẬP TAY
      cityName = selectedCity?.name ?? '';
      districtName = selectedDistrict?.name ?? '';
      wardName = selectedWard?.name ?? '';
      detailAddress = addressController.text;
    }
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tinh': cityName,
          'quan': districtName,
          'phuong': wardName,
          'detailAddress': detailAddress,
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
          
          // 🔹 TẠO VÀ GỬI SHIPPING ADDRESS DATA
          final shippingAddressData = ShippingAddressData(
            city: cityName,
            district: districtName,
            ward: wardName,
            detailAddress: detailAddress,
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

  // 🔹 WIDGET CHO SAVED ADDRESSES
  Widget _buildSavedAddressSelection() {
    if (isLoadingAddresses) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (savedAddresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Column(
          children: [
            Icon(Icons.location_off, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              'No saved addresses found',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'You can add addresses in your profile',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...savedAddresses.map((address) {
          final isSelected = selectedSavedAddress?['id'] == address['id'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.blue[50] : Colors.white,
            ),
            child: ListTile(
              leading: Radio<Map<String, dynamic>>(
                value: address,
                groupValue: selectedSavedAddress,
                onChanged: (value) {
                  setState(() {
                    selectedSavedAddress = value;
                    isUsingSavedAddress = true;
                  });
                  _applySelectedAddress();
                },
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      address['fullName'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (address['isDefault'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
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
                  const SizedBox(height: 4),
                  Text(
                    address['fullAddress'] ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  selectedSavedAddress = address;
                  isUsingSavedAddress = true;
                });
                _applySelectedAddress();
              },
            ),
          );
        }),
        if (savedAddresses.isNotEmpty)
          TextButton(
            onPressed: () {
              // Navigate to add new address screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Go to Profile > Address to add new address')),
              );
            },
            child: const Text('+ Add New Address'),
          ),
      ],
    );
  }

  // 🔹 WIDGET CHO MANUAL INPUT
  Widget _buildManualAddressInput() {
    return Column(
      children: [
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
              isUsingSavedAddress = false;
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
              isUsingSavedAddress = false;
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
              isUsingSavedAddress = false;
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
          onChanged: (value) {
            setState(() {
              isUsingSavedAddress = false;
            });
          },
        ),
      ],
    );
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

        // 🔹 THÊM RADIO BUTTONS ĐỂ CHỌN PHƯƠNG THỨC NHẬP ĐỊA CHỈ
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Saved Addresses'),
                value: 'saved',
                groupValue: addressInputMethod,
                onChanged: (value) {
                  setState(() {
                    addressInputMethod = value!;
                    if (value == 'saved' && selectedSavedAddress != null) {
                      _applySelectedAddress();
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Enter Manually'),
                value: 'manual',
                groupValue: addressInputMethod,
                onChanged: (value) {
                  setState(() {
                    addressInputMethod = value!;
                    selectedSavedAddress = null;
                    isUsingSavedAddress = false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 🔹 HIỂN THỊ WIDGET TƯƠNG ỨNG VỚI LỰA CHỌN
        if (addressInputMethod == 'saved')
          _buildSavedAddressSelection()
        else
          _buildManualAddressInput(),

        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              bool canSubmit = false;
              
              if (addressInputMethod == 'saved' && selectedSavedAddress != null) {
                canSubmit = true;
              } else if (addressInputMethod == 'manual') {
                canSubmit = selectedCity != null &&
                    selectedDistrict != null &&
                    selectedWard != null &&
                    addressController.text.isNotEmpty;
              }
              
              if (!canSubmit) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please complete your address information!')),
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

        // Hiển thị shipping price sau khi submit
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

        // 🔹 HIỂN THỊ ĐỊA CHỈ ĐÃ CHỌN
        if (isShippingSubmitted && (selectedSavedAddress != null || selectedCity != null)) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Address:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  isUsingSavedAddress && selectedSavedAddress != null 
                    ? selectedSavedAddress!['fullAddress'] ?? ''
                    : '${addressController.text}, ${selectedWard?.name ?? ''}, ${selectedDistrict?.name ?? ''}, ${selectedCity?.name ?? ''}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
