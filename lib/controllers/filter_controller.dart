import 'package:get/get.dart';
import 'package:do_an_mobile/services/filter_service.dart';

class FilterController extends GetxController {
  // 🔹 FILTER STATE
  final RxString selectedGender = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedSort = ''.obs;
  
  // 🔹 COLOR FILTERS
  final RxMap<String, bool> colorFilters = <String, bool>{
    'Brown': false,
    'Black': false,
    'Bright Green': false,
    'Red': false,
    'White': false,
    'White&Black': false,
    'Orange': false,
  }.obs;
  
  // 🔹 MATERIAL FILTERS
  final RxMap<String, bool> materialFilters = <String, bool>{
    'Leather': false,
    'Canvas': false,
    'GC selected': false,
  }.obs;

  // 🔹 LOADING STATE
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> filteredProducts = <Map<String, dynamic>>[].obs;

  // 🔹 THÊM FLAG ĐỂ KIỂM SOÁT AUTO APPLY
  final RxBool _hasManuallyAppliedFilters = false.obs;

  // 🔹 GETTER FOR SELECTED COLORS
  List<String> get selectedColors {
    return colorFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  // 🔹 GETTER FOR SELECTED MATERIALS
  List<String> get selectedMaterials {
    return materialFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  // 🔹 CHECK IF ANY FILTER IS ACTIVE
  bool get hasActiveFilters {
    return selectedGender.value.isNotEmpty ||
           selectedCategory.value.isNotEmpty ||
           selectedSort.value.isNotEmpty ||
           colorFilters.containsValue(true) ||
           materialFilters.containsValue(true);
  }

  // 🔹 CHECK IF USER HAS MANUALLY APPLIED FILTERS
  bool get hasManuallyAppliedFilters => _hasManuallyAppliedFilters.value;

  // 🔹 RESET ALL FILTERS
  void resetFilters() {
    selectedGender.value = '';
    selectedCategory.value = '';
    selectedSort.value = '';
    
    // Reset colors
    final resetColors = <String, bool>{};
    for (String key in colorFilters.keys) {
      resetColors[key] = false;
    }
    colorFilters.assignAll(resetColors);
    
    // Reset materials
    final resetMaterials = <String, bool>{};
    for (String key in materialFilters.keys) {
      resetMaterials[key] = false;
    }
    materialFilters.assignAll(resetMaterials);
    
    // 🔹 CLEAR FILTERED PRODUCTS VÀ RESET FLAG
    filteredProducts.clear();
    _hasManuallyAppliedFilters.value = false;
    
    print('🔄 All filters reset');
  }

  // 🔹 INIT FILTERS WITHOUT APPLYING (FOR INITIAL SETUP)
  void initFilters({String? gender, String? category}) {
    if (gender != null) {
      selectedGender.value = gender;
      print('🔧 Init gender: $gender (no auto apply)');
    }
    if (category != null) {
      selectedCategory.value = category;
      print('🔧 Init category: $category (no auto apply)');
    }
    // 🔹 KHÔNG SET _hasManuallyAppliedFilters = true
  }

  // 🔹 TOGGLE COLOR FILTER
  void toggleColorFilter(String color) {
    colorFilters[color] = !(colorFilters[color] ?? false);
    print('🎨 Color filter toggled: $color = ${colorFilters[color]}');
  }

  // 🔹 TOGGLE MATERIAL FILTER
  void toggleMaterialFilter(String material) {
    materialFilters[material] = !(materialFilters[material] ?? false);
    print('🧵 Material filter toggled: $material = ${materialFilters[material]}');
  }

  // 🔹 SET GENDER (WITH MANUAL APPLY)
  void setGender(String gender) {
    selectedGender.value = gender;
    print('👤 Gender set: $gender');
  }

  // 🔹 SET CATEGORY (WITH MANUAL APPLY)
  void setCategory(String category) {
    selectedCategory.value = category;
    print('📂 Category set: $category');
  }

  // 🔹 SET SORT (WITH MANUAL APPLY)
  void setSort(String sort) {
    selectedSort.value = sort;
    print('🔄 Sort set: $sort');
  }

  // 🔹 APPLY FILTERS - CHỈ KHI USER MANUALLY TRIGGER
  Future<void> applyFilters() async {
    try {
      isLoading.value = true;
      _hasManuallyAppliedFilters.value = true; // 🔹 ĐÁNH DẤU ĐÃ APPLY MANUAL
      
      // 🔹 MAPPING GENDER ĐẾN CATEGORY
      String? categoryParam;
      if (selectedGender.value == 'Men') {
        categoryParam = "Men's";
      } else if (selectedGender.value == 'Women') {
        categoryParam = "Women's";
      }

      // 🔹 MAPPING CATEGORY ĐẾN BRAND
      String? brandParam;
      switch (selectedCategory.value) {
        case 'All':
          brandParam = null;
          break;
        case "Men's Bags":
          brandParam = 'Bags';
          break;
        case 'HandBags': 
        case 'Handbags': 
          brandParam = 'Handbags';
          break;
        case 'Shoes':
          brandParam = 'Shoes';
          break;
        default:
          brandParam = selectedCategory.value;
      }

      // 🔹 MAPPING SORT
      String? sortParam;
      switch (selectedSort.value) {
        case 'Best Selling':
          sortParam = 'best_selling';
          break;
        case 'Price: High to Low':
          sortParam = 'price_desc';
          break;
        case 'Price: Low to High':
          sortParam = 'price_asc';
          break;
        default:
          sortParam = null;
      }

      print('🔍 Applying filters:');
      print('  - Category: $categoryParam');
      print('  - Brand: $brandParam');
      print('  - Sort: $sortParam');
      print('  - Colors: $selectedColors');
      print('  - Materials: $selectedMaterials');

      final results = await FilterService.getFilteredProducts(
        category: categoryParam,
        brand: brandParam,
        sortOrder: sortParam,
        colors: selectedColors.isNotEmpty ? selectedColors : null,
        materials: selectedMaterials.isNotEmpty ? selectedMaterials : null,
      );

      // 🔹 LUÔN CẬP NHẬT KẾT QUẢ (KỂ CẢ KHI TRỐNG)
      filteredProducts.value = List<Map<String, dynamic>>.from(results);
      print('✅ Filter applied: ${filteredProducts.length} products found');
      
    } catch (e) {
      print('❌ Apply filters error: $e');
      // 🔹 NẾU CÓ LỖI, ĐẶT THÀNH DANH SÁCH TRỐNG
      filteredProducts.value = [];
      Get.snackbar('Error', 'Failed to apply filters: $e');
    } finally {
      isLoading.value = false;
    }
  }
}