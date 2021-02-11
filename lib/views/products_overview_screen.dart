import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import '../utils/app_routes.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //carregar os produtos
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    }); //chama o carregamento dos produtos
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context);
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorite) {
                _showFavoriteOnly = true;
              } else {
                _showFavoriteOnly = false;
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh:  () => _refreshProducts(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showFavoriteOnly),
      ),
      drawer: AppDrawer(),
    );
  }
}
