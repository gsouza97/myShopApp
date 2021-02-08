import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    //alterna entre marcar favorito e desmarcar
    isFavorite = !isFavorite; //vdd passa a ser falso e falso passa a ser vdd
    notifyListeners(); //notifica todos os interessados qnd muda
  }

  Future<void> toggleFavorite() async {
    _toggleFavorite();

    try {
      final url =
          '${Constants.BASE_API_URL}/products/$id.json';

      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
