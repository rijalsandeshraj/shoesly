import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  List<Map<String, dynamic>> products;
  String paymentMethod;
  String address;
  GeoPoint geoPoint;
  DateTime orderedDateTime;
  double shippingCharge;
  double grandTotal;

  Order({
    required this.products,
    required this.paymentMethod,
    required this.address,
    required this.geoPoint,
    required this.orderedDateTime,
    required this.shippingCharge,
    required this.grandTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'products': products,
      'paymentMethod': paymentMethod,
      'address': address,
      'geoPoint': geoPoint,
      'orderedDateTime': orderedDateTime,
      'shippingCharge': shippingCharge,
      'grandTotal': grandTotal,
    };
  }
}
