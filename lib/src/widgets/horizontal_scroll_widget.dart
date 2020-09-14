import 'package:flutter/material.dart';

import 'package:movies_clone/src/models/movie.dart';

class HorizontalScrollWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  HorizontalScrollWidget({@required this.movies, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    this._pageController.addListener(() {
      if (this._pageController.position.pixels >=
          this._pageController.position.maxScrollExtent - 500) {
        this.nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
          pageSnapping: false,
          controller: this._pageController,
          itemCount: movies.length,
          itemBuilder: (context, i) => this._card(context, movies[i])),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uuid = '${movie.id}-poster';
    final movieCard = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uuid,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(movie.getIMG()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          //SizedBox(height: 10),
          Text(movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption)
        ],
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'movie', arguments: movie),
      child: movieCard,
    );
  }
}
