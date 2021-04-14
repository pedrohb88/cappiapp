import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final _items = [
    Container(
      color: Color(0xFF008600),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom:8.0, left: 32.0, right:32.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.asset('assets/images/cappi_logo.png'),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  'Tenha um app adaptado ao seu perfil e acompanhe sua evolução financeira!',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      color: Color(0xFF008600),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom:8.0, left: 32.0, right:32.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.asset('assets/images/cappi_logo.png'),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  'Compartilhe suas metas com amigos para se manterem motivados!',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      color: Color(0xFF008600),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom:8.0, left: 32.0, right:32.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.asset('assets/images/cappi_logo.png'),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  'Está com muita pressa? Anote o que precisa com nosso bot para WhatsApp!',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  _buildPageView() {
    return PageView.builder(
        itemCount: _items.length,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return _items[index];
        },
        onPageChanged: (int index) {
          _currentPageNotifier.value = index;
        });
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 20.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          dotSpacing: 30.0,
          dotColor: Colors.white.withAlpha(150),
          selectedDotColor: Colors.white,
          itemCount: _items.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildPageView(),
        _buildCircleIndicator(),
      ],
    );
  }
}
