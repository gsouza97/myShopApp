import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<Products>(context); //list produtos de provider
    final products = showFavoriteOnly
        ? productsProvider.favoriteItems
        : productsProvider.items; //item de cada produto
    return GridView.builder(
      //com o builder pra otimizar
      padding: const EdgeInsets.all(10),
      itemCount: products.length, //quantidade de elementos da grid
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        //quando esse produto mudar, reconstroi o child (ProductItem)
        value: products[index], //cria apenas um produto
        child: ProductGridItem(), //qnd o produto muda, reconstrói o componente
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //qnt fixa de elementos na linha
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, //espaçamento no eixo cruzado
        mainAxisSpacing: 10, //espaçamento no eixo vertical
      ),
    );
  }
}
