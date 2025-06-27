// LIST OF Constants used in APIs

class ApiConstants {
  static const String tSecretAPIKey = "tSecretAPIKey";
  static const String baseUrl = 'http://localhost:5139/';
  static const String productApi = '${baseUrl}api/ProductApi';
  static const String accountApi = '${baseUrl}api/AccountApi';
  static const String cartApi = '${baseUrl}api/CartApi';
  static const String checkoutApi = '${baseUrl}api/ApiCheckout';
  static const String productMediaUrl = '${baseUrl}media/products/';
  static const String variationMediaUrl = '${baseUrl}media/variations/';
  static const String avatarMediaUrl = '${baseUrl}media/avatars/';

  // Address endpoints
  static const String getUserProfile = '${accountApi}/GetProfile';
  static const String updateAvatar = '${accountApi}/UpdateAvatar';
  static const String addAddress = '${accountApi}/AddAddress';
  static const String getUserAddresses = '${accountApi}/GetUserAddresses';
  static const String updateAddress = '${accountApi}/UpdateAddress';
  static const String deleteAddress = '${accountApi}/DeleteAddress';
  static const String setDefaultAddress = '${accountApi}/SetDefaultAddress';
}
