import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/models/stock_model.dart';

class StockQuoteResponse {
  final StockQuote stockQuote;

  StockQuoteResponse({required this.stockQuote});

  // Factory method to create a StockQuoteResponse from a JSON map
  factory StockQuoteResponse.fromJson(Map<String, dynamic> json) {
    return StockQuoteResponse(
      stockQuote: StockQuote.fromJson(json['Global Quote']),
    );
  }
}

final stockQuoteProvider =
    FutureProvider.family<StockQuoteResponse, String>((ref, symbol) async {
  const apiKey = 'B6JT4374B4DBW5RD';
  final url =
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return StockQuoteResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load data');
  }
});
