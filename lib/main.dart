import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/views/auth_home_screen.dart';
import 'package:shop/views/auth_screen.dart';
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
          create: (_) => new Auth(), //cria o auth
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (ctx, auth, previousProducts) => new Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ), //cria e atualiza o produto passando o token
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(), //cria o carrinho
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (ctx, auth, previousOrders) => new Orders(
            auth.token,
            auth.userId,
            previousOrders.items,
          ), //cria e atualiza o produto passando o token
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primaryColor: Color(0xff3b4d61),
          accentColor: Color(0xffe8d21d),
          cardColor: Color(0xfff5f0e1),
          canvasColor: Color(0xfff5f0e1),
          fontFamily: 'Lato',
        ),
        //home: ProductOverviewScreen(), //  products overview passa a ser a home
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomeScreen(),
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
