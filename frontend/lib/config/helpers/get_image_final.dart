import 'package:bookie/config/constants/general.dart';

String getImageUrl(bool isDarkmode, String imageUrl) {
  return imageUrl != "sin-imagen"
      ? imageUrl
      : isDarkmode
          ? GeneralConstants.imageNotFoundDark
          : GeneralConstants.imageNotFoundLight;
}