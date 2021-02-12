import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id), //o que vai ser removido
      direction: DismissDirection.endToStart, //direção do movimento
      confirmDismiss: (_) {
        return showDialog(
          //para confirmar a exclusão
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem Certeza?'), //titulo do alerta
            content: Text('Quer remover o item do carrinho?'), //texto
            actions: [
              FlatButton(
                child: Text('Não'), //opção nao
                onPressed: () {
                  Navigator.of(ctx).pop(false); //nao retornar o valor
                },
              ),
              FlatButton(
                child: Text('Sim'), //opção sim
                onPressed: () {
                  Navigator.of(ctx).pop(true); //retornar o valor, remove
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId); //remove o item
      },
      background: Container(
        //background quando arrastar
        color: Theme.of(context).errorColor, //cor de fundo
        child: Icon(
          Icons.delete, //icone de fundo
          color: Colors.white, //cor do icone
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20), //espaçamento pra n ficar grudado
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        color: Color(0xfff5f0e1),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${cartItem.price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(
              cartItem.title,
            ),
            subtitle: Text(
                'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
