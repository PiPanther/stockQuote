import 'package:flutter/material.dart';
import 'package:stock_quote/models/stock_model.dart';

class StockPage extends StatefulWidget {
  String name;
  StockQuote quote;
  StockPage({super.key, required this.quote, required this.name});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    double change = double.parse(widget.quote.change);
    // double percentage = double.parse(widget.quote.changePercent);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stock Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name),
                Text(
                  change.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.quote.symbol),
                Text(
                  widget.quote.changePercent,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
