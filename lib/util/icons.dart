import 'dart:io' show Platform;

import 'package:flutter/material.dart';

final _isApple = Platform.isIOS || Platform.isMacOS;

final moreIcon = _isApple ? Icons.more_horiz : Icons.more_vert;

final shareIcon = _isApple ? Icons.ios_share : Icons.share;
