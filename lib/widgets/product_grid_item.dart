import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context,
        listen: false); //recebe o produto a partir do provider

    final Cart cart =
        Provider.of<Cart>(context, listen: false); //provider do carrinho

    return ClipRRect(
      borderRadius: BorderRadius.circular(10), //coloca borda arredondada na img
      child: GridTile(
        child: GestureDetector(
          //envolvendo a imagem pra ser clicavel
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL, //rota que vai ser navegada
              arguments: product, // argumento passado pra ProductDetailScreen
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          //barra com o favorito, titulo e carrinho
          backgroundColor: Colors.black87, //cor de fundo
          leading: Consumer<Product>(
            //consumer na parte que vai sofrer alteração
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavorite(); //função do favorito
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title, //texto com o titulo
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart), //icone de carrinho
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product); //add item ao carrinho
              Scaffold.of(context)
                  .hideCurrentSnackBar(); //esconde a snackbar atual
              //mostra a proxima snackbar
              Scaffold.of(context).showSnackBar(
                //chama o scaffold pra mostrar o snackbar
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  duration: Duration(seconds: 2), //msg exibida por 2 segs
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      cart.removeSingleItem(
                          product.id); //função qnd apertar desfazer
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
