import 'package:flutter/material.dart';

import 'package:movies_clone/src/delegates/search_delegate.dart';

import 'package:movies_clone/src/providers/movies_provider.dart';

import 'package:movies_clone/src/widgets/card_swiper_widget.dart';
import 'package:movies_clone/src/widgets/horizontal_scroll_widget.dart';

class HomeScreen extends StatelessWidget {

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {

    this.moviesProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchMovies());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            this._swipeCards(),
            this._footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swipeCards() {
    moviesProvider.getNowPlaying();

    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
            height: 600,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Popular Movies', style: Theme.of(context).textTheme.headline5),
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: moviesProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return HorizontalScrollWidget(movies: snapshot.data, nextPage: moviesProvider.getPopular);
              } else {
                return Center(child: CircularProgressIndicator(
                  backgroundColor: Colors.black
                ));
              }
            }
          )
        ],
      )
    );
  }
}