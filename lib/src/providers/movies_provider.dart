import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:movies_clone/src/models/movie.dart';
import 'package:movies_clone/src/models/actor.dart';
import 'package:movies_clone/src/models/cast.dart';

import 'dart:convert';

import 'package:movies_clone/src/models/movies.dart';

class MoviesProvider {

  String _apiKey = 'f4d7ac22729798942f58c2cfde672a13';
  String _url = 'api.themoviedb.org';
  String _language = 'es-MX';

  int _pagination = 0;
  bool _loading = false;

  List<Movie> _populars = new List();

  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processRequest(Uri url) async {
    final response = await http.get(url);
    final decode = json.decode(response.body);

    final data = new Movies.fromJsonList(decode['results']);

    return data.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });
    return await this._processRequest(url);
  }

  Future<List<Movie>> getPopular() async {

    if (this._loading) return [];

    this._loading = true;

    _pagination++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _pagination.toString()
    });

    final response = await this._processRequest(url);

    this._populars.addAll(response);
    this.popularsSink(this._populars);

    this._loading = false;

    return response;
  }

  Future<List<Actor>> getCast(String id) async {
    final url = Uri.https(_url, '3/movie/$id/credits', {
      'api_key': _apiKey,
      'language': _language
    });

    final response = await http.get(url);
    final decode = json.decode(response.body);

    final cast = new Cast.fromJsonList(decode['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });
    return await this._processRequest(url);
  }
}