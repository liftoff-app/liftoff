import 'dart:io' show Platform;

import 'package:flutter/material.dart';

final moreIcon =
    (Platform.isIOS || Platform.isMacOS) ? Icons.more_horiz : Icons.more_vert;
