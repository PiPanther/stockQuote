class StockQuote {
  final String symbol;
  final String open;
  final String high;
  final String low;
  final String price;
  final String volume;
  final String latestTradingDay;
  final String previousClose;
  final String change;
  final String changePercent;

  StockQuote({
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.price,
    required this.volume,
    required this.latestTradingDay,
    required this.previousClose,
    required this.change,
    required this.changePercent,
  });

  factory StockQuote.fromJson(Map<String, dynamic> json) {
    return StockQuote(
      symbol: json['01. symbol'],
      open: json['02. open'],
      high: json['03. high'],
      low: json['04. low'],
      price: json['05. price'],
      volume: json['06. volume'],
      latestTradingDay: json['07. latest trading day'],
      previousClose: json['08. previous close'],
      change: json['09. change'],
      changePercent: json['10. change percent'],
    );
  }
}
