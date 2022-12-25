import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';

import 'package:shuffle_x/json/SongsJson.dart';
import 'package:shuffle_x/ui/Player.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation _sizeAnimation;
  Animation _listAnimation;
  AnimationController _sizeAnimationController;

  @override
  void initState() {
    super.initState();
    _sizeAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _sizeAnimation = Tween(begin: 20, end: 120.0).animate(CurvedAnimation(
        parent: _sizeAnimationController, curve: Curves.fastOutSlowIn));
    _listAnimation = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
        parent: _sizeAnimationController,
        curve: Interval(0.40, 0.75, curve: Curves.easeOut)));
    _sizeAnimationController.forward();
    _sizeAnimationController.addListener(() {
      setState(() {});
    });
  }

  List imageUrl = [
    'https://upload.wikimedia.org/wikipedia/en/3/3d/Dua_Lipa_Levitating_%28DaBaby_Remix%29.png',
    'https://i.ytimg.com/vi/KXanlLjOFh0/maxresdefault.jpg',
    'https://i.pinimg.com/564x/b8/24/87/b824872c99524c9ef531350d031855b5.jpg',
    'https://m.media-amazon.com/images/M/MV5BYTBlY2E2Y2ItNmFjNy00Zjg4LThhNjAtNmRmNDQ2NzI2YjVlXkEyXkFqcGdeQXVyNjE0ODc0MDc@._V1_.jpg',
    'https://dancingastronaut.com/wp-content/uploads/2018/08/marshmello-anne-marie.jpg'
  ];
  List songInfo = [
    'Levitating',
    'Ring Ring',
    'Baby I\'m Jealous',
    'Boyfriend',
    'Friends'
  ];
  String songUrl = 'https://mymp3bhojpuri.in/files/download/id/17928' ;

  int selectedMenu = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Opacity(
              opacity: _listAnimation.value,
              child: Text("ShuffleX",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
            // Icon(Feather.list)
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Opacity(
                opacity: _listAnimation.value,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: song_type_1.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 4.0, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMenu = index;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    song_type_1[index],
                                    style: TextStyle(
                                        color: selectedMenu == index
                                            ? Colors.white
                                            : Colors.white24,
                                        fontSize:
                                            selectedMenu == index ? 18 : 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  selectedMenu == index
                                      ? Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                        )
                                      : SizedBox(),
                                ],
                              )),
                        );
                      }),
                ),
              ),
              //  HtmlEditor(controller: controller)
              SizedBox(height: 10),
              Opacity(
                opacity: _listAnimation.value,
                child: Container(
                  height: 130,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: song_type_1.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 4.0, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMenu = index;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: _sizeAnimation.value,
                                    width: _sizeAnimation.value,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage(songs[index]['img']),
                                            fit: BoxFit.cover),
                                        // color: primary,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ],
                              )),
                        );
                      }),
                ),
              ),
              SizedBox(height: 20),
              Opacity(
                opacity: _listAnimation.value,
                child: Container(
                  height: 31,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: song_type_2.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 4.0, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMenu = index;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    song_type_2[index],
                                    style: TextStyle(
                                        color: selectedMenu == index
                                            ? Colors.white
                                            : Colors.white24,
                                        fontSize:
                                            selectedMenu == index ? 18 : 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // selectedMenu == index
                                  //     ? Container(
                                  //         height: 8,
                                  //         width: 8,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.white,
                                  //             shape: BoxShape.circle),
                                  //       )
                                  //     : SizedBox(),
                                ],
                              )),
                        );
                      }),
                ),
              ),
              SizedBox(height: 30),
              Opacity(
                opacity: _listAnimation.value,
                child: Container(
                  height: 180,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrl.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 4.0, right: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMenu = index;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                        
                                        // enableDrag: true,
                                        context: context, builder: (context){
                                        return Player(
                                                  imageUrl[index],
                                                  songInfo[index],songUrl);
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => AudioPlayer(
                                      //             imageUrl[index],
                                      //             songInfo[index])));
                                    },
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            
                                              image: NetworkImage(
                                                imageUrl[index],
                                              ),
                                              fit: BoxFit.cover),
                                          // color: primary,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                  // Text(
                                  //   imageUrl[index],
                                  //   style: TextStyle(
                                  //       color: selectedMenu == index
                                  //           ? Colors.white
                                  //           : Colors.white24,
                                  //       fontSize:
                                  //           selectedMenu == index ? 18 : 15,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  // selectedMenu == index
                                  //     ? Container(
                                  //         height: 8,
                                  //         width: 8,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.white,
                                  //             shape: BoxShape.circle),
                                  //       )
                                  //     : SizedBox(),
                                ],
                              )),
                        );
                      }),
                ),
              ),

              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) => AudioPlayer()));
                  },
                  child: Text(
                    'play ',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
