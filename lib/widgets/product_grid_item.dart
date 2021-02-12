import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
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

    final Auth auth = Provider.of<Auth>(context, listen: false);

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
          child: Hero(
            tag: product.id, //pode ser qlquer nome. Colocar no destino tambem
            // animação fade da imagem
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite(auth.token, auth.userId);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Produto adicionado com sucesso!',
                  ),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
