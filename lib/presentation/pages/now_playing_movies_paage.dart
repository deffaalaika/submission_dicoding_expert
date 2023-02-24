import 'package:ditonton/common/drawer_item_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-movie';

  @override
  _NowPlayingMoviesPageState createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MovieListNotifier>(context, listen: false)
            .fetchNowPlayingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MovieListNotifier>(
          builder: (context, datas, child) {
            final state = datas.nowPlayingState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              final data = datas.nowPlayingMovies;

              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data[index];

                  return ContentCardList(
                    activeDrawerItem: DrawerItem.Movie,
                    routeName: MovieDetailPage.ROUTE_NAME,
                    movie: movie,
                  );
                },
                itemCount: data.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(datas.message),
              );
            }
          },
        ),
      ),
    );
  }
}
