import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      DevicePreview(
        builder: (_) => MaterialApp(
          useInheritedMediaQuery: true,
          home: MyApp(),
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.orange,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          navStyle: NavStyle.globePedestal,
          index: 0,
          bottom: true,
          height: 60.0,
          buttonOffsetY: 45,
          items: const <Widget>[
            Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.list,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.compare_arrows,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.call_split,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.perm_identity,
              size: 25,
              color: Colors.white,
            ),
          ],
          color: Colors.brown,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          buttonPadding: const EdgeInsets.all(10),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => false,
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
      ),
    );
  }
}
