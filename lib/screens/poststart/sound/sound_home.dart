import 'package:audioplayers/audioplayers.dart';
import 'package:champions/global_helpers/internet_connection.dart';
import 'package:champions/screens/global_components/app_body.dart';
import 'package:champions/screens/global_components/app_header.dart';
import 'package:champions/screens/global_components/connection_error_body.dart';
import 'package:champions/screens/global_components/custom_circular_progress_indicator.dart';
import 'package:champions/screens/global_components/custom_timer_with_sound.dart';
import 'package:champions/screens/global_components/player_card.dart';
import 'package:champions/screens/global_components/primary_button.dart';
import 'package:champions/global_helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SoundHome extends StatefulWidget {
  const SoundHome({super.key});

  static String id = 'SoundHome';

  @override
  State<SoundHome> createState() => _ActingHomeState();
}

class _ActingHomeState extends State<SoundHome> {
  CollectionReference sound = FireBaseReferences.kSoundRef;

  int startTime = 30;
  int? start;
  int currentIndex = 0;
  AudioPlayer soundPlayer = AudioPlayer();

  @override
  void initState() {
    InternetConnection.checkInternet();
    randomNumbers = [];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: sound.snapshots(),
      builder: (context, snapshot) {
        if (InternetConnection.hasInternet == true){
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              backgroundColor: kPrimaryColor,
              body: Column(
                children: [
                  const AppHeader(
                    title: AppStrings.soundTitle,
                  ),
                  Expanded(
                    child: AppBody(
                      widget: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.06,
                                  ),
                                  PlayerCard(
                                    playerImage: snapshot.data!.docs[currentIndex]
                                    [AppStrings.playerImageFBTitle],
                                    playerName: snapshot.data!.docs[currentIndex]
                                    [AppStrings.playerNameFBTitle],
                                    keyColor: snapshot.data!.docs[currentIndex]
                                    [AppStrings.playerKeyColorFBTitle],
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.05,
                                  ),
                                  CustomTimerWithSound(
                                    startTime: startTime,
                                    start: start ?? startTime,
                                    soundPlayer: soundPlayer,
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 48,
                            ),
                            child: PrimaryButton(
                              text: AppStrings.nextPlayerBtn,
                              itemCallBack: () {
                                setState(() {
                                  currentIndex = generateRandomNumber(
                                      snapshot.data!.docs.length);
                                  start = startTime;
                                  soundPlayer.pause();
                                  // if(animateIconController.isEnd()){
                                  //   animateIconController.animateToStart;
                                  // }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: kWhiteColor,
              body: Center(
                  child: CustomCircularProgressIndicator(
                    color: kPrimaryColor,
                  )),
            );
          }
        }
        return ConnectionErrorBody(
          onPressed: ()async{
            await InternetConnection.checkInternet();
            setState(() {});
          },
        );
      },
    );
  }
}
