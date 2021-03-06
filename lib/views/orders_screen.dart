import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orders.items.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum pedido adicionado',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        orders.itemsCount,
                    itemBuilder: (ctx, index) => OrderWidget(
                      orders.items[index],
                    ),
                  ),
      ),
    );
  }
}
