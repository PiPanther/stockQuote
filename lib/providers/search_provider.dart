import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/models/search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SymbolSearchResponse {
  final List<SearchModel> symbols;
  SymbolSearchResponse({required this.symbols});

  factory SymbolSearchResponse.fromJson(Map<String, dynamic> json) {
    return SymbolSearchResponse(
        symbols: (json['bestMatches'] as List)
            .map((symbol) => SearchModel.fromJson(symbol))
            .toList());
  }
}



final symbolSearchProvider =
    FutureProvider.family<SymbolSearchResponse, String>((ref, keyword) async {
  const apiKey = 'B6JT4374B4DBW5RD';
  final url =
      'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keyword&apikey=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return SymbolSearchResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load data');
  }
});
