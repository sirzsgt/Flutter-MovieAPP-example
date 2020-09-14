import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:movies_clone/src/models/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context, int index) {
            movies[index].uuid = '${movies[index].id}-card';
            final _card = Hero(
              tag: movies[index].uuid,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(movies[index].getIMG()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            );
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'movie',
                  arguments: movies[index]),
              child: _card,
            );
          },
          itemCount: this.movies.length),
    );
  }
}
