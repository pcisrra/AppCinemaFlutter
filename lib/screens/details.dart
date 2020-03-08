import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appcinema/block/cast_and_crew_bloc/cast_bloc.dart';
import 'package:appcinema/block/cast_and_crew_bloc/cast_event.dart';
import 'package:appcinema/block/cast_and_crew_bloc/cast_state.dart';
import 'package:appcinema/data/model/api_cast_model.dart';
import 'package:appcinema/data/model/api_result_model.dart';
import 'package:appcinema/data/model/genre.dart';
import 'package:appcinema/screens/search.dart';

class Details extends StatefulWidget {
  final Results movies;

  Details(this.movies);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<String> geners = [];

  @override
  void initState() {
    BlocProvider.of<CastBloc>(context)
        .add(FetchCastAndCrewEvent(movieId: (widget.movies.id).toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("geners:${}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Hero(
                tag: "https://image.tmdb.org/t/p/w1280${widget.movies.id}",
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  color: Color(0xFF333333),
                  child: kIsWeb
                      ? Image.network(
                          "https://image.tmdb.org/t/p/w1280${widget.movies.posterPath}",
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : CachedNetworkImage(
                          width: double.infinity,
                          imageUrl:
                              "https://image.tmdb.org/t/p/w1280${widget.movies.posterPath}",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF000000).withOpacity(1),
                          Colors.transparent,
                        ],
                        stops: [
                          0.2,
                          0.4,
                        ]),
                  )),
              Positioned(
                top: 30,
                left: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white24),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.movies.title,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontFamily: "Poppins-Bold",
                      color: Color(0xFFFBFBFB) //Color(0xFF5d59d8)
                      ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        genres(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text("Storyline",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05)),
                        ),
                        Text(widget.movies.overview,
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontFamily: "Poppins-Light",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                          child: Text("Cast & Crue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05)),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: BlocBuilder<CastBloc, CastState>(
                                  builder: (context, state) {
                                if (state is CastInitialState) {
                                  return CircularProgressIndicator();
                                } else if (state is CastLoadingState) {
                                  return CircularProgressIndicator();
                                } else if (state is CastLoadedState) {
                                  print(state.casts);
                                  return CastScreen(state.casts);
                                } else if (state is CastErrorState) {
                                  return Center(
                                      child: Message("Feild to load !"));
                                }
                              })),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget genres() {
    for (int i = 0; i < widget.movies.genreIds.length; i++) {
      geners.add((Genre.getGenre(widget.movies.genreIds[i].toString())));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: getTextWidgets(context, geners),
    );
  }
}

Widget getTextWidgets(context, List<String> strings) {
  List<Widget> list = new List<Widget>();
  for (var i = 0; i < strings.length; i++) {
    list.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFFee6969), borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13),
        child: new Text(
          strings[i],
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              fontSize: MediaQuery.of(context).size.width * 0.033,
              fontFamily: "Poppins-Light"),
        ),
      ),
    ));
  }
  return new Wrap(runSpacing: 8, spacing: 8, children: list);
}

class CastScreen extends StatelessWidget {
  final List<Cast> casts;
  CastScreen(this.casts);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, i) {
          return SizedBox(
            width: 8,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.15 + 15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: casts[i].profilePath != null
                              ? NetworkImage(
                                  "https://image.tmdb.org/t/p/w1280${casts[i].profilePath}",
                                )
                              : AssetImage("assets/icons/noimage.jpg"),
                          fit: BoxFit.cover),
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              AutoSizeText(
                casts[i].name,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                    color: Color(0xFFfbfbfb),
                    fontFamily: "Poppins-Light"),
              )
            ],
          );
        });
  }
}