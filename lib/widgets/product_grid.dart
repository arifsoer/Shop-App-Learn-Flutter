import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';

import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (cts, ind) => ProductItem(
        products[ind].id,
        products[ind].title,
        products[ind].imageUrl,
      ),
    );
  }
}
