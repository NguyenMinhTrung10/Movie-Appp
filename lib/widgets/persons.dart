import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/bloc/get_persons_bloc.dart';
import 'package:movie_app/model/person.dart';
import 'package:movie_app/model/person_response.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:rxdart/rxdart.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    super.initState();
    personsBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "TRENDING PERSONS ON THIS WEEK",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<PersonResponse>(
            stream: personsBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error != null &&
                    snapshot.data!.error.length > 0) {
                  return _buildErrorWidget(snapshot.data!.error);
                }
                return _buildPersonsWidget(snapshot.data!);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else {
                return _buildLoadingWidget();
              }
            })
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Error occured: $error")],
      ),
    );
  }

  Widget _buildPersonsWidget(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 130.0,
      padding: EdgeInsets.only(left: 10.0),
      child: ListView.builder(
          itemCount: persons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 100.0,
              padding: EdgeInsets.only(top: 10.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  persons[index].profileImg == null
                      ? Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Style.Colors.secondColor),
                          child: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.white,
                          ))
                      : persons[index].profileImg != null
                          ? Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w200" +
                                              persons[index].profileImg!),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://scontent.fsgn4-1.fna.fbcdn.net/v/t39.30808-6/273190887_3181406158810299_8844312634369128996_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=pY59dk_jb1AAX_DdiWs&_nc_ht=scontent.fsgn4-1.fna&oh=00_AT9Xrw2brvY_UqnSUDHe4sAm8bg0i6ZDu3LiCutcobOCYg&oe=62D6B32E"),
                                      fit: BoxFit.cover)),
                            ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    persons[index].name,
                    maxLines: 2,
                    style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    "Trending for ${persons[index].known}",
                    style: TextStyle(
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 7.0),
                  )
                ],
              ),
            );
          }),
    );
  }
}
