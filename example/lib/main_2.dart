import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        navStyle: NavStyle.mould,
        index: 0,
        height: 60.0,
        buttonOffsetY: 45,
        items: <Widget>[
          Icon(
            Icons.add,
            size: 25,
            color: Colors.white.withOpacity(_page == 0 ? 1.0 : 0.95),
          ),
          Icon(
            Icons.list,
            size: 25,
            color: Colors.white.withOpacity(_page == 1 ? 1.0 : 0.95),
          ),
          Icon(
            Icons.compare_arrows,
            size: 25,
            color: Colors.white.withOpacity(_page == 2 ? 1.0 : 0.95),
          ),
          Icon(
            Icons.call_split,
            size: 25,
            color: Colors.white.withOpacity(_page == 3 ? 1.0 : 0.95),
          ),
          Icon(
            Icons.perm_identity,
            size: 25,
            color: Colors.white.withOpacity(_page == 4 ? 1.0 : 0.95),
          ),
        ],
        color: darkBlue,
        buttonBackgroundColor: darkBlue,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        buttonPadding: const EdgeInsets.all(10),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text(_page.toString(), textScaleFactor: 10.0),
              ElevatedButton(
                child: Text('Go To Page of index 1'),
                onPressed: () {
                  final CurvedNavigationBarState? navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState?.setPage(1);
                },
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 100,
                  height: 90,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
