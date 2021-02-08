import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList(); //itens do carrinho

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('COMPRAR'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: cart.totalAmount == 0
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            //cria um pedido com o carrinho
                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(cart);
                            setState(() {
                              _isLoading = false;
                            });
                            cart.clear(); //limpa os pedidos do carrinho
                          },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            //ocupa o resto da tela inteira
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, index) => CartItemWidget(cartItems[
                  index]), //pega cada item da lista de itens do carrinho
            ),
          ),
        ],
      ),
    );
  }
}
