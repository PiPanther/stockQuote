import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/models/chart_data_model.dart';
import 'package:stock_quote/models/stock_model.dart';
import 'package:stock_quote/providers/watchListProvider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockPage extends ConsumerStatefulWidget {
  final String name;
  final StockQuote quote;
  const StockPage({super.key, required this.quote, required this.name});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  bool buttonDisplay = false;

  @override
  Widget build(BuildContext context) {
    final quotes = ref.watch(watchlistQuotesProvider);
    final flag = ref.watch(watchlistProvider);

    double change = double.tryParse(widget.quote.change) ?? 0.0;
    String formattedChange = change.toStringAsFixed(2);
    String formattedPercent = widget.quote.changePercent
        .substring(0, widget.quote.changePercent.length - 3);

    List<String> list = [
      "Open",
      "High",
      "Low",
      "Volumne",
      "Latest Trading Day",
      "Previous Close"
    ];
    StockQuote quote = widget.quote;
    List<String> values = [
      quote.open.substring(0, quote.open.length - 2),
      quote.high.substring(0, quote.high.length - 2),
      quote.low.substring(0, quote.low.length - 2),
      quote.volume,
      quote.latestTradingDay,
      quote.previousClose.substring(0, quote.previousClose.length - 2)
    ];
    String formattedPrice = double.parse(widget.quote.price).toStringAsFixed(2);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Stock Details',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (quotes.contains(quote)) {
                ref.watch(watchlistProvider).removeQuote(quote);
              } else {
                ref.watch(watchlistProvider).addQuotes(quote);
              }
            },
            icon: (!quotes.contains(quote))
                ? const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: (widget.quote.changePercent[0] == "-")
                      ? Colors.red
                      : Colors.green, // Border to enhance the glass effect
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name.substring(0, 25),
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "\$ ${formattedPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.quote.symbol,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (widget.quote.changePercent[0] == "-")
                            ? '▼${formattedChange} (${formattedPercent}%)'
                            : '▲${formattedChange} (${formattedPercent}%)',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: (widget.quote.changePercent[0] == "-")
                              ? Colors.red
                              : Colors.green,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            flag.displayFlag
                ? TextButton.icon(
                    onPressed: flag.invertFlag,
                    label: const Text('Generate Charts.'))
                : Container(
                    height: 200,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: (widget.quote.changePercent[0] == "-")
                            ? Colors.red
                            : Colors
                                .green, // Border to enhance the glass effect
                        width: 1.5,
                      ),
                    ),
                    child: SfCartesianChart(palette: const [
                      Colors.red,
                      Colors.green,
                      Colors.black
                    ], series: <CartesianSeries>[
                      CandleSeries<ChartData, double>(
                          showIndicationForSameValues: true,
                          dataSource: <ChartData>[
                            ChartData(
                                // Open and close values are same
                                x: 5,
                                open: 86.3593,
                                high: 88.1435,
                                low: 84.3914,
                                close: 86.3593),
                            ChartData(
                                // High and low values are same
                                x: 10,
                                open: 85.4425,
                                high: 86.4885,
                                low: 86.4885,
                                close: 87.001),
                            ChartData(
                                //High, low, open, and close values all are same
                                x: 15,
                                open: 86.4885,
                                high: 86.4885,
                                low: 86.4885,
                                close: 86.4885),
                          ],
                          xValueMapper: (ChartData data, _) => data.x,
                          highValueMapper: (ChartData data, _) => data.high,
                          lowValueMapper: (ChartData data, _) => data.low,
                          openValueMapper: (ChartData data, _) => data.open,
                          closeValueMapper: (ChartData data, _) => data.close)
                    ]),
                  ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "  Overview",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(146, 255, 255, 255)
                        .withOpacity(0.2), // Light shade with opacity
                    const Color.fromARGB(79, 176, 208, 231)
                        .withOpacity(0.1), // Lighter shade with opacity
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromARGB(
                      255, 49, 69, 103), // Border to enhance the glass effect
                  width: 1.5,
                ),
              ),
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list[index],
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          values[index].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
