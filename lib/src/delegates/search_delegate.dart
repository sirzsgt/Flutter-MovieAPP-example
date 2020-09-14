import 'package:flutter/material.dart';

import 'package:movies_clone/src/providers/movies_provider.dart';

import 'package:movies_clone/src/models/movie.dart';

class SearchMovies extends SearchDelegate {
  String selected = '';

  final moviesProvider = new MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blueAccent,
        child: Text(selected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage(
                    image: NetworkImage(movie.getIMG()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    width: 50.0,
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text(movie.overview != '' ? movie.overview : movie.originalTitle, overflow: TextOverflow.ellipsis),
                onTap: () {
                  close(context, null);
                  movie.uuid = '';
                  Navigator.pushNamed(context, 'movie', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.black),
          );
        }
      },
    );

    /*final suggestions = (query.isEmpty)
        ? recently
        : movies.where(
            (movie) => movie.toLowerCase().startsWith(query.toLowerCase())
          ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(suggestions[i]),
          onTap: () {
            selected = suggestions[i];
            showResults(context);
          },
        );
      },
    );*/
  }
}
