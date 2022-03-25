import 'package:book_club/models/suggestion_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/suggestions/add_suggestion.dart';
import 'package:book_club/screens/suggestions/suggestion_card.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:flutter/material.dart';

import '../../services/db_stream.dart';
import '../../shared/containers/background_container.dart';
import '../../shared/loading.dart';

class Suggestions extends StatefulWidget {
  final UserModel currentUser;

  const Suggestions({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              height: mobileContainerMaxHeight,
              width: mobileMaxWidth,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: ListView(
          children: [
            const SizedBox(
              height: 100,
              child: Center(
                  child: Text(
                "Suggestions",
                style: TextStyle(fontSize: 30),
              )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder<List<SuggestionModel>>(
                        stream: DBStream().getAllSuggestions(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Loading();
                          } else {
                            if (snapshot.data!.isEmpty) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      "Il n'y a pas encore de suggestion, à vous l'honneur !",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else {
                              List<SuggestionModel> _suggestions =
                                  snapshot.data!;

                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _suggestions.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0) {
                                      return Container();
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: SuggestionCard(
                                          suggestion: _suggestions[index - 1],
                                          currentUser: widget.currentUser,
                                        ),
                                      );
                                    }
                                  });
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).focusColor,
          onPressed: (() => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AddSuggestion(currentUser: widget.currentUser),
              )))),
    );
  }
}
