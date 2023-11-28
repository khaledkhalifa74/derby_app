import 'package:cached_network_image/cached_network_image.dart';
import 'package:champions/global_components/app_body.dart';
import 'package:champions/global_components/app_header.dart';
import 'package:champions/global_components/custom_circular_progress_indicator.dart';
import 'package:champions/global_components/players_names_bottom_sheet.dart';
import 'package:champions/global_components/primary_button.dart';
import 'package:champions/global_components/secondary_button.dart';
import 'package:champions/global_helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamHome extends StatefulWidget {
  const TeamHome({super.key});

  static String id = 'TeamHome';

  @override
  State<TeamHome> createState() => _TeamHomeState();
}

class _TeamHomeState extends State<TeamHome> {

  CollectionReference easy = FirebaseFirestore.instance
      .collection(AppStrings.teamCollection)
      .doc(AppStrings.teamDoc)
      .collection(AppStrings.easyTeamCollection);

  CollectionReference mid = FirebaseFirestore.instance
      .collection(AppStrings.teamCollection)
      .doc(AppStrings.teamDoc)
      .collection(AppStrings.midTeamCollection);

  CollectionReference hard = FirebaseFirestore.instance
      .collection(AppStrings.teamCollection)
      .doc(AppStrings.teamDoc)
      .collection(AppStrings.hardTeamCollection);
  int currentIndex = 0;

  @override
  void initState() {
    randomNumbers =[];
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
                  title: AppStrings.teamTitle,
                ),
                Expanded(
                  child: AppBody(
                    widget: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.04,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.22,
                                child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[currentIndex]
                                    [AppStrings.imageFBTitle],
                                  imageBuilder: (context,imageProvider) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill,
                                      )
                                    ),
                                  ),
                                  placeholder: (context, url) => const CustomCircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.04,
                              ),
                              Text(
                                  snapshot.data!.docs[currentIndex]
                                  [AppStrings.nameFBTitle],
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SecondaryButton(
                          text: AppStrings.nextTeamBtn,
                          itemCallBack: () {
                            currentIndex = generateRandomNumber(
                                snapshot.data!.docs.length);
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 48,
                          ),
                          child: PrimaryButton(
                            text: AppStrings.showPlayersBtn,
                            itemCallBack: () {
                              showModalBottomSheet(
                                elevation: 0,
                                isScrollControlled: true,
                                backgroundColor: kWhiteColor,
                                context: context,
                                builder: (context) => PlayersNamesBottomSheet(
                                  teamName: snapshot.data!.docs[currentIndex]
                                  [AppStrings.nameFBTitle],
                                  player1: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player1FBTitle],
                                  player2: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player2FBTitle],
                                  player3: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player3FBTitle],
                                  player4: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player4FBTitle],
                                  player5: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player5FBTitle],
                                  player6: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player6FBTitle],
                                  player7: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player7FBTitle],
                                  player8: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player8FBTitle],
                                  player9: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player9FBTitle],
                                  player10: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player10FBTitle],
                                  player11: snapshot.data!.docs[currentIndex]
                                  [AppStrings.player11FBTitle],
                                ),
                              );
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
          return const Center(child: CustomCircularProgressIndicator());
        }
      },
    );
  }
}
