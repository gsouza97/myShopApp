import 'dart:math';

import 'package:flutter/material.dart';

import 'product.dart';

// como as classes tao muito ligadas entre si, coloquei no msm arquivo
class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {}; //chave é o string id, valor é o cartitem

  Map<String, CartItem> get items {
    return {..._items}; //retornando um map clonado
  }

  int get itemsCount {
    return _items.length; //mostrar a quantidade de itens no carrinho
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      //pega cada um dos itens
      total += cartItem.price * cartItem.quantity;
      //pega o preço de cada item e multiplica pela quantidade
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      //se ja contem o item
      _items.update(
        product.id,
        (existingItem) {
          //atualiza o item adicionando mais um
          return CartItem(
            id: existingItem.id, //retorna o mesmo id
            productId: existingItem.id, //retorna o id do produto
            title: existingItem.title, //retorna o mesmo preço
            quantity: existingItem.quantity + 1, //adiciona mais um
            price: existingItem.price,
          );
        },
      );
    } else {
      _items.putIfAbsent(product.id, () {
        //incluir se não tiver presente
        return CartItem(
          //retorna um novo produto
          id: Random().nextDouble().toString(), //adiciona com um id randomico
          productId: product.id,
          title: product.title, //adiciona o titulo do produto
          quantity: 1, //adiciona 1 quantidade
          price: product.price, //adiciona o preço do produto
        );
      });
    }
    notifyListeners(); //notifica os ouvintes
  }

  void removeSingleItem(productId) {
    // se nao tiver dentro dos items nao tiver productId
    // ou seja, tentando remover um prod que n tá presente
    if (!_items.containsKey(productId)) {
      return; //só sai do metodo. n faz nada
    }
    // se os itens tem qntidade igual a 1
    if (_items[productId].quantity == 1) {
      _items.remove(productId); //  remove o produto
      // caso contrário
    } else {
      //atualiza o produto existente
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id, //mesmo id
          productId: existingItem.productId, // mesmo productId
          title: existingItem.title, //mesmo titulo
          quantity: existingItem.quantity - 1, //qnt atual menos 1
          price: existingItem.price, //mesmo preço
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    //remove o produto baseado na chave que é o id do produto
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
