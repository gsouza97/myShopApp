import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';

  List<Order> _items = [];
  String _token;
  String _userId;

  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response = await http.get('$_baseUrl/$_userId.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        _items.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                price: item['price'],
                productId: item['productId'],
                quantity: item['quantity'],
                title: item['title'],
              );
            }).toList(),
          ),
        );
      });
      notifyListeners();
    }
    _items = _items.reversed.toList();
  }

  Future<void> addOrder(Cart cart) async {
    final response = await http.post(
      '$_baseUrl/$_userId.json?auth=$_token',
      body: json.encode({
        'total': cart.totalAmount,
        'date': DateTime.now().toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      ),
    );
  }

  notifyListeners();
}
