import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';
import 'product.dart';
import '../data/dummy_data.dart';

//http aqui porque daqui a gente consegue adicionar um produto, editar um produto,
//deletar um produto, etc...

//objetivo de encapsular a lista de produtos já que é uma lista que vai ser bastante utilizada
//changenotifier está completamente relacionado com o padrão observer
//é um notificador de mudanças. qnd uma mudança acontece, ele vai notificar todos os interessados.
//quando um produto for excluido da lista, ele vai notificar, assim como qnd adicionar
// se atualiza de acordo com a mudança
class Products with ChangeNotifier {
  final String _baseUrl =
      '${Constants.BASE_API_URL}/products'; //pra inserir, alterar, incluir

//  List<Product> _items = DUMMY_PRODUCTS;
  List<Product> _items = [];

  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      //se _showFavoriteOnly é vdd
      return _items
          .where((prod) => prod.isFavorite)
          .toList(); //retorna apenas os produtos favs
    }
    return [..._items]; //senão retorna a lista inteira de itens
  }

  //preenche a lista de produtos (_items) diretamente do firebase
  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json');
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear(); //limpa a lista pra nao duplicar
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId, //pega o id que foi gerado no firebase
          title: productData['title'], //pega o title que foi gerado no firebase
          description: productData['description'],
          price: productData['price'], //pega o price que foi gerado no firebase
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }

  //mostra apenas os favoritos
  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners(); //notifica todos os interessados qnd a mudança acontecer
  }

  //mostra todos os itens
  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners(); //notifica todos os interessados qnd a mudança acontecer
  }

  //adicionar produto do formulário à lista
  Future<void> addProduct(Product newProduct) async {
    //url utilizada para inserir dados no backend

    final response = await http.post(
      "$_baseUrl.json",
      //usa o json encode para transformar o produto passado dentro de um map para json.
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'], //pega o id que foi gerado no firebase
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners(); //notifica todos os interessados qnd a mudança acontecer
  }

  Future<void> updateProduct(Product product) async {
    //se o produto nao estiver setado e o id nao estiver setado
    //se o produto for nulo ou o id for nulo
    if (product == null || product.id == null) {
      return; //nao faz nada
    }
    //procura o produto dentro da lista de produtos
    //verifica se o prod (que é o parametro recebido na função) .id
    //é igual ao product.id
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch('$_baseUrl/${product.id}.json',
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
            },
          ));
      _items[index] = product; //substitui a partir do indice o produto
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    //procura o produto dentro da lista de produtos
    final index = _items.indexWhere((prod) => prod.id == id);
    // se o produto existir
    if (index >= 0) {
      //remove onde o id do produto da lista é igual ao id passado no parametro
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete("$_baseUrl/${product.id}.json");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }

//      _items.removeWhere((prod) => prod.id == id);

    }
  }
}
