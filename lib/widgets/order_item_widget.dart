import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemWidget(this.orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _expanded
          ? min(widget.orderItem.products.length * 20.0 + 130, 300)
          : 120,
      child: Card(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: _expanded
                  ? min(widget.orderItem.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.orderItem.products
                    .map(
                      (pro) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pro.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${pro.quantity}x \$${pro.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
