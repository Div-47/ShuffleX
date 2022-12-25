import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:des_plugin/des_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:shuffle_x/json/SongsJson.dart';
import 'package:shuffle_x/ui/Search.dart';
import "package:chewie/chewie.dart";
import "package:chewie/src/helpers/utils.dart";

import 'package:touchable_opacity/touchable_opacity.dart';

String status = 'hidden';
AudioCache audioCache = AudioCache();
AudioPlayer audioPlayer = AudioPlayer();
PlayerState playerState;

enum AudioPlayerState { stopped, playing, paused }

class Player extends StatefulWidget {
  final String imageUrl;
  final String songInfo;
  final String songUrl;

  Player(this.imageUrl, this.songInfo, this.songUrl);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<Player> {
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);

  // get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription audioPlayerStateSubscription;

  PlayingRoute playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription durationSubscription;
  StreamSubscription positionSubscription;
  StreamSubscription playerCompleteSubscription;
  StreamSubscription playerErrorSubscription;
  StreamSubscription playerStateSubscription;
  StreamSubscription<PlayerControlCommand> playerControlCommandSubscription;

  bool _isPlaying = true;

  String key = "38346591";
  String decrypt = "";

  @override
  void initState() {
    initAudioPlayer();
    super.initState();

    // audioPlayer = AudioPlayer() ;
  }

  // void decryptSong()async{
  //  setState(()async {
  //     songUrl =await DesPlugin.decrypt(key, widget.songUrl);
  //  });
  // }
  void dispose() {
    audioPlayer.dispose();
    durationSubscription?.cancel();
    positionSubscription?.cancel();
    playerCompleteSubscription?.cancel();
    playerErrorSubscription?.cancel();
    playerStateSubscription?.cancel();
    playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GradientText(
          "Now Playing",
          shaderRect: Rect.fromLTWH(10.0, 20.0, 40, 100.0),
          gradient: Gradients.rainbowBlue,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.35,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(height: 20),
                GradientText(
                  widget.songInfo,
                  shaderRect: Rect.fromLTWH(10.0, 20.0, 40, 100.0),
                  gradient: Gradients.rainbowBlue,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  songs[2]['description'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, bottom: 0),
                      child: Slider(
                          autofocus: true,
                          inactiveColor: Colors.white24,
                          activeColor: Colors.white,
                          value: (position != null &&
                                  duration != null &&
                                  position.inMilliseconds > 0 &&
                                  position.inMilliseconds <
                                      duration.inMilliseconds)
                              ? position.inMilliseconds /
                                  duration.inMilliseconds
                              : 0.0,
                          onChanged: (v) {
                            final Position = v * duration.inSeconds;
                            audioPlayer
                                .seek(Duration(seconds: Position.round()));
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            position != null
                                ? '${formatDuration(position)}'
                                : '00:00',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            duration != null
                                ? '${formatDuration(duration)}'
                                : '00:00',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TouchableOpacity(
                        onTap: () {
                          setState(() {
                            // _isPlaying ? null : play ;
                            if (_isPlaying) {
                              _isPlaying = false;
                            } else {
                              _isPlaying = true;
                            }
                          });
                        },
                        child: Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 50,
                        )),
                    CircularGradientButton(
                        callback: () {
                          setState(() {
                            if (_isPlaying) {
                              _isPlaying = false;
                              // int result = await audioPlayer.stop();
                              pause();
                            } else {
                              _isPlaying = true;
                              play();
                            }
                          });
                        },
                        gradient: Gradients.rainbowBlue,
                        shadowColor: Gradients.backToFuture.colors.last
                            .withOpacity(0.25),
                        child: !_isPlaying
                            ? Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 50,
                              )
                            : Icon(
                                Icons.pause_rounded,
                                color: Colors.white,
                                size: 50,
                              )),
                    TouchableOpacity(
                        onTap: () {
                          setState(() {
                            if (_isPlaying) {
                              _isPlaying = false;
                            } else {
                              _isPlaying = true;
                            }
                          });
                        },
                        child: Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 50,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
//  void initAudioPlayer() {
//     if (audioPlayer == null) {
//       audioPlayer = AudioPlayer();
//     }
//     setState(() {
//       if (checker == "Haa") {
//         stop();
//         play();
//       }
//       if (checker == "Nahi") {
//         if (playerState == PlayerState.playing) {
//           play();
//         } else {
//           //Using (Hack) Play() here Else UI glitch is being caused, Will try to find better solution.
//           play();
//           pause();
//         }
//       }
//     });

//     _positionSubscription = audioPlayer.onAudioPositionChanged
//         .listen((p) => {if (mounted) setState(() => position = p)});

//     _audioPlayerStateSubscription =
//         audioPlayer.onPlayerStateChanged.listen((s) {
//       if (s == AudioPlayerState.PLAYING) {
//         {
//           if (mounted) setState(() => duration = audioPlayer.duration);
//         }
//       } else if (s == AudioPlayerState.STOPPED) {
//         onComplete();
//         if (mounted)
//           setState(() {
//             position = duration;
//           });
//       }
//     }, onError: (msg) {
//       if (mounted)
//         setState(() {
//           playerState = PlayerState.stopped;
//           duration = Duration(seconds: 0);
//           position = Duration(seconds: 0);
//         });
//     });
//   ;

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    durationSubscription = audioPlayer.onDurationChanged.listen((d) {
      print(d);
      setState(() => duration = d);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // optional: listen for notification updates in the background
        audioPlayer.notificationService.startHeadlessService();
        // set at least title to see the notification bar on ios.
        audioPlayer.notificationService.setNotification(
          title: 'ShuffleX',
          artist: 'Artist or blank',
          albumTitle: 'Name or blank',
          imageUrl: 'Image URL or blank',
          forwardSkipInterval: const Duration(seconds: 15), // default is 30s
          backwardSkipInterval: const Duration(seconds: 15), // default is 30s
          duration: duration,
          enableNextTrackButton: true,
          enablePreviousTrackButton: true,
        );
      }
    });

    positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              position = p;
              // print(p);
            }));

    playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen((event) {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        playerState = PlayerState.STOPPED;
        duration = const Duration();
        position = const Duration();
      });
    });

    playerControlCommandSubscription =
        audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('command: $command');
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          playerState = state;
        });
      }
    });

    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => playerState = state);
      }
    });

    playingRouteState = PlayingRoute.SPEAKERS;
    play();
  }

  Future<int> play() async {
    final playPosition = (position != null &&
            duration != null &&
            position.inMilliseconds > 0 &&
            position.inMilliseconds < duration.inMilliseconds)
        ? position
        : null;
    final result = await audioPlayer.play(widget.songUrl,
        position: playPosition, isLocal: false);
    if (result == 1) {
      setState(() => playerState = PlayerState.PLAYING);
    }

    return result;
  }

  Future<int> pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      setState(() => playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> earpieceOrSpeakersToggle() async {
    final result = await audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => playingRouteState = playingRouteState.toggle());
    }
    return result;
  }

  Future<int> stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        playerState = PlayerState.STOPPED;
        position = const Duration();
      });
    }
    return result;
  }

  void onComplete() {
    setState(() => playerState = PlayerState.STOPPED);
  }

  // int result = await audioPlayer.pause();
}
