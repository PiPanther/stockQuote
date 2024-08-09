import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/providers/quoteProvider.dart';
import 'package:stock_quote/providers/search_provider.dart';
import 'package:stock_quote/stockpage/stock_page.dart';
import 'package:stock_quote/theme.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  Future<SymbolSearchResponse?>? symbolSearchFuture;
  Future<StockQuoteResponse?>? symbolQuote;

  Future<SymbolSearchResponse> fetchData(String keyword, WidgetRef ref) {
    return ref.read(symbolSearchProvider(keyword).future);
  }

  Future<StockQuoteResponse?> fetchStockQuote(
      String symbol, WidgetRef ref) async {
    try {
      return ref.read(stockQuoteProvider(symbol).future);
    } catch (e) {
      print('Error fetching stock quote: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            stretch: true,
            floating: false,
            pinned: false,
            snap: false,
            onStretchTrigger: () async {},
            stretchTriggerOffset: 300.0,
            expandedHeight: 200.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Some Name IG'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SearchBar(
                controller: controller,
                autoFocus: true,
                elevation: const WidgetStatePropertyAll(2.0),
                hintText: 'Search stocks',
                enabled: true,
                trailing: [
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        // Trigger the API call and assign it to the future
                        symbolSearchFuture = fetchData(
                            controller.text.toLowerCase().trim(), ref);
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<SymbolSearchResponse?>(
            future: symbolSearchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (snapshot.hasData) {
                final symbols = snapshot.data?.symbols ?? [];

                if (symbols.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('No results found.')),
                  );
                }

                return SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ListTile(
                          onTap: () async {
                            final symbolQuote = await fetchStockQuote(
                                symbols[index].symbol, ref);
                            if (symbolQuote != null) {
                              // Navigate to the stock detail page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StockPage(
                                        quote: symbolQuote.stockQuote,
                                        name: symbols[index].name),
                                  ));
                              print(
                                symbolQuote.stockQuote,
                              );
                            } else {
                              print('Error fetching stock quote');
                            }
                            // print(stockQuoteResponse);
                          },
                          title: Text(symbols[index].symbol),
                          subtitle: Text(symbols[index].name),
                        );
                      },
                      childCount: symbols.length,
                    ),
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No results found.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
