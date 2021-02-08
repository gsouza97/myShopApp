import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM, //navega pra rota do formulario
                  arguments: product, //passa o produto como argumento
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Excluir produto'), //titulo do alerta
                          content: Text(
                              'Deseja realmente excluir o produto?'), //texto do alerta
                          actions: [
                            FlatButton(
                              child: Text('Não'), //opção não
                              onPressed: () {
                                Navigator.of(ctx)
                                    .pop(false); //nao retornar o valor
                              },
                            ),
                            FlatButton(
                              child: Text('Sim'), //opção sim
                              onPressed: () {
                                Navigator.of(ctx).pop(true); //retornar o valor
                                Provider.of<Products>(context, listen: false)
                                    .deleteProduct(
                                        product.id); //deleta o produto
                              },
                            )
                          ],
                        ));
              },
            )
          ],
        ),
      ),
    );
  }
}
