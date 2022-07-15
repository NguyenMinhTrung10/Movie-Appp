//import 'dart:ffi';
//import 'dart:ui';

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/genre_movies.dart';
import 'package:rxdart/rxdart.dart';

class GenresList extends StatefulWidget {
  const GenresList({Key? key, required this.genres}) : super(key: key);
  final List<Genre> genres;
  // GenresList({Key? key, required this.genres}) : super(key: key);

  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  late TabController _tabController;

  _GenresListState(this.genres);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307.0,
      child: DefaultTabController(
          length: genres.length,
          child: Scaffold(
              backgroundColor: Style.Colors.mainColor,
              appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: Style.Colors.mainColor,
                    bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: Style.Colors.secondColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3.0,
                        unselectedLabelColor: Style.Colors.titleColor,
                        labelColor: Colors.white,
                        isScrollable: true,
                        tabs: genres.map((Genre genre) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                            child: Text(
                              genre.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList()),
                  ),
                  preferredSize: Size.fromHeight(50.0)),
              body: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: genres.map((Genre genre) {
                  return GenreMovis(genreId: genre.id);
                }).toList(),
              ))),
    );
  }
}
