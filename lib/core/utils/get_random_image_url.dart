  // Method to pick a random image URL
  import 'dart:math';

import 'package:helphive_flutter/core/constants/images_urls.dart';

String getRandomImageUrl() {
    final random = Random();
    return imageUrls[random.nextInt(imageUrls.length)];
  }