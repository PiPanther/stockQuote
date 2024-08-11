import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/providers/watchListProvider.dart';

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    // Access the list of StockQuote using the computed provider
    final quotes = ref.watch(watchlistQuotesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Watchlist',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: quotes.isEmpty
          ? const Center(child: Text('No stocks in the watchlist'))
          : ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                if (index < 0 || index >= quotes.length) {
                  // Handle out-of-bounds access
                  return const SizedBox.shrink();
                }

                final stock = quotes[index];
                return Column(
                  children: [
                    Card(
                      color: Colors.grey.shade100,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: ListTile(
                        title: Text(
                          stock.symbol,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                            'Price: \$${stock.price.substring(0, stock.price.length - 2)}'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Remove the stock from the watchlist
                            ref.read(watchlistProvider).removeQuote(stock);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
