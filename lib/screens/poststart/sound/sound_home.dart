import 'package:audioplayers/audioplayers.dart';
import 'package:champions/screens/global_components/app_body.dart';
import 'package:champions/screens/global_components/app_header.dart';
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
  CollectionReference easy = FireBaseReferences.kEasyActingRef;
  CollectionReference mid = FireBaseReferences.kMidActingRef;
  CollectionReference hard = FireBaseReferences.kHardActingRef;
  int startTime = 30;
  int? start;
  int currentIndex = 0;
  AudioPlayer soundPlayer = AudioPlayer();
  //late final AnimateIconController animateIconController;

  @override
  void initState() {
    randomNumbers = [];
    //animateIconController = AnimateIconController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<QuerySnapshot>(
      stream: args == AppStrings.easyId
          ? easy.snapshots()
          : args == AppStrings.midId
          ? mid.snapshots()
          : hard.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                                  [AppStrings.imageFBTitle],
                                  playerName: snapshot.data!.docs[currentIndex]
                                  [AppStrings.nameFBTitle],
                                  keyColor: snapshot.data!.docs[currentIndex]
                                  [AppStrings.keyFBTitle],
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
          return const Center(child: CustomCircularProgressIndicator(color: kWhiteColor,));
        }
      },
    );
  }
}