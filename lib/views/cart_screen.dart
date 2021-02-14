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
    final cartItems = cart.items.values.toList();

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
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
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
                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(cart);
                            setState(() {
                              _isLoading = false;
                            });
                            cart.clear();
                          },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, index) => CartItemWidget(
                cartItems[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
