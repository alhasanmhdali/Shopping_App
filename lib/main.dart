//........ Import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//........ Import providers
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/order.dart';

//........ Import screens
import './screens/product_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/shopping_cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products.dart';
import './screens/edit_product.dart';

//.........Main function
void main() => runApp(MyApp());

//.........Main app screen
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        title: 'MobShop Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductScreen.routeName: (ctx) => ProductScreen(),
          ShoppingCartScreen.routeName: (ctx) => ShoppingCartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProducts.routeName: (ctx) => UserProducts(),
          EditProduct.routeName: (ctx) => EditProduct(),
        },
      ),
    );
  }
}
