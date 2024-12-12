import 'dart:math';

import 'package:bookie/config/constants/general.dart';

String generarBioWriter() {
  final random = Random();
  return RandomBioWriters.bio[random.nextInt(RandomBioWriters.bio.length)];
}
