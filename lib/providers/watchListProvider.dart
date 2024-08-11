import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/models/stock_model.dart';

// Create a ChangeNotifierProvider for WatchList
final watchlistProvider = ChangeNotifierProvider<WatchList>((ref) {
  return WatchList();
});

// Computed provider that extracts the list of quotes
final watchlistQuotesProvider = Provider<List<StockQuote>>((ref) {
  return ref.watch(watchlistProvider).quotes;
});

class WatchList extends ChangeNotifier {
  final List<StockQuote> quotes = [];
  bool _displayFlag = true;

  bool get displayFlag => _displayFlag;
  List<StockQuote> getItems() => quotes;

  void addQuotes(StockQuote quote) {
    quotes.add(quote);
    notifyListeners();
  }

  void removeQuote(StockQuote quote) {
    quotes.remove(quote);
    notifyListeners();
  }

  void invertFlag() {
    _displayFlag = !_displayFlag;
    notifyListeners();
  }
}
