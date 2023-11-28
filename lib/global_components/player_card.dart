import 'package:champions/global_components/custom_circular_progress_indicator.dart';
import 'package:champions/global_helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerCard extends StatelessWidget {
  String? playerImage;
  String? playerName;
  String? keyColor;

  PlayerCard({
    super.key,
    required this.playerImage,
    required this.playerName,
    required this.keyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(keyColor == 'red'
                      ? kRedPlayerBG
                      : keyColor == 'blue'
                          ? kBluePlayerBG
                          : keyColor == 'yellow'
                              ? kYellowPlayerBG
                              : keyColor == 'white'
                                  ? kWhitePlayerBG
                                  : keyColor == 'babyBlue'
                                      ? kBabyBluePlayerBG
                                      : keyColor == 'darkRed'
                                          ? kDarkRedPlayerBG
                                          : kRedPlayerBG),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: -40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: CachedNetworkImage(
                  imageUrl: playerImage!,
                  placeholder: (context, url) =>
                      const CustomCircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Text(
          playerName ?? 'null',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
