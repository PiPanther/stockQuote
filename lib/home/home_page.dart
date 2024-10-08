import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_quote/constants/constants.dart';
import 'package:stock_quote/theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;
  void onpageChange(int page) {
    setState(() {
      _page = page;
      print(_page);
    });
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'StockN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/bg.gif'))),
            child: Constants.tabWidgets[_page]),
        bottomNavigationBar: CupertinoTabBar(
          activeColor: Colors.white,
          backgroundColor: currentTheme.cardColor,
          height: 70,
          items: const [
            BottomNavigationBarItem(
              label: '',
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.waterfall_chart_outlined),
              ),
            ),
          ],
          onTap: onpageChange,
          currentIndex: _page,
        ));
  }
}
