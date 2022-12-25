import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import "package:http/http.dart" as http;
import 'package:shuffle_x/controller/search_controller.dart';
import 'package:shuffle_x/ui/Player.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        // FocusNode focus ;
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<SearchController>(
          init: searchController,
          builder: (c) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.black,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Theme(
                          data: new ThemeData(
                            primaryColor: Colors.white,
                            primaryColorDark: Colors.white,
                          ),
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                EasyDebounce.debounce(
                                    "search", Duration(seconds: 1), () {
                                  searchController.fetchSongsList(val);
                                });
                              });
                            },
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.grey,

                            decoration: InputDecoration(
                              alignLabelWithHint: true,

                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search_sharp,
                                color: Colors.white,
                              ),

                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              // labelText: 'Search',
                              // labelStyle: TextStyle(color: Colors.white,  ),

                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: searchController.searchedList.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                Text(
                                  searchController.searchedList[i]['title'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await searchController
                                          .songDetails(searchController
                                              .searchedList[i]['id'])
                                          .then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Player(
                                                    searchController
                                                            .searchedList[i]
                                                        ['image'],
                                                    searchController
                                                            .searchedList[i]
                                                        ['title'],
                                                    value)));
                                      });
                                    },
                                    child: Image.network(searchController
                                        .searchedList[i]['image']))
                              ],
                            );
                          })
                    ],
                  ),
                ),
              ),
            );
          }),
    ));
  }

  // Music search api -->

}
