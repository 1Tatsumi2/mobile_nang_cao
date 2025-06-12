import 'package:flutter/material.dart';
import 'widgets/cart_header.dart';
import 'widgets/product_selection.dart';
import 'widgets/shipping_information.dart';
import 'widgets/order_payment_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Banner
            const CartHeader(),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Product Selection Section
                  const ProductSelection(),
                  const SizedBox(height: 24),

                  // Divider
                  const Divider(color: Colors.grey, thickness: 0.5),
                  const SizedBox(height: 24),

                  // Shipping Information Section
                  const ShippingInformation(),
                  const SizedBox(height: 24),

                  // Divider
                  const Divider(color: Colors.grey, thickness: 0.5),
                  const SizedBox(height: 24),

                  // Order Summary and Payment Section
                  const OrderPaymentSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
