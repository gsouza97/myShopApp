import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_screen.dart';
import './utils/app_routes.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './views/cart_screen.dart';
import './views/orders_screen.dart';
import './views/product_detail_screen.dart';
import './views/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //cria o changenotifier (provider). Multi pq são multiplos providers
      //provider envolvendo a aplicação
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new Products(), //cria o produto
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Cart(), //cria o carrinho
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Orders(), //cria o pedido
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        //home: ProductOverviewScreen(), //  products overview passa a ser a home
        routes: {
          AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS_MANAGEMENT: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
