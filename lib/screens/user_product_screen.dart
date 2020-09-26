import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../providers/products.dart';

import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProducrScreen extends StatelessWidget {
  static const routeName = "/user-prioducts";

  Future<void> _onRefreshProduct(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productDatas = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _onRefreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productDatas.items.length,
            itemBuilder: (_, i) => UserProductItem(
              productDatas.items[i].id,
              productDatas.items[i].title,
              productDatas.items[i].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
