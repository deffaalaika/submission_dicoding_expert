import 'package:ditonton/common/drawer_item_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tvshow';

  @override
  _NowPlayingTVShowsPageState createState() => _NowPlayingTVShowsPageState();
}

class _NowPlayingTVShowsPageState extends State<NowPlayingTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TVShowListNotifier>(context, listen: false)
            .fetchNowPlayingTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TVShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TVShowListNotifier>(
          builder: (context, datas, child) {
            final state = datas.nowPlayingState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              final data = datas.nowPlayingTVShows;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data[index];

                  return ContentCardList(
                    activeDrawerItem: DrawerItem.TVShow,
                    routeName: TVShowDetailPage.ROUTE_NAME,
                    tvShow: tvShow,
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
