import 'package:flutter/material.dart';

import 'package:movies_clone/src/models/actor.dart';
import 'package:movies_clone/src/models/movie.dart';

import 'package:movies_clone/src/providers/movies_provider.dart';

class MovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        this._appBar(movie),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            this._titlePoster(movie, context),
            this._description(movie, context),
            this._casting(movie)
          ]),
        )
      ],
    ));
  }

  Widget _appBar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.black,
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            movie.title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getIMG()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _titlePoster(Movie movie, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uuid,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getIMG()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title,
                    style: Theme.of(context).textTheme.headline4,
                    overflow: TextOverflow.ellipsis),
                Text(movie.originalTitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subtitle1,
                        overflow: TextOverflow.ellipsis)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(movie.overview,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget _casting(Movie movie) {
    final moviesProvider = new MoviesProvider();

    return FutureBuilder(
      future: moviesProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) {
          return this._createPageViewCast(snapshot.data);
        } else {
          return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.black));
        }
      },
    );
  }

  Widget _createPageViewCast(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actors.length,
        itemBuilder: (context, i) {
          return this._card(actors[i]);
        },
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
      ),
    );
  }

  Widget _card(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                image: NetworkImage(actor.getIMG()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 150.0),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
