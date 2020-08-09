import 'package:flutter/material.dart';

class Captcha {
  final String png;

  /// can be null
  final String wav;
  final String uuid;
  Captcha({@required this.png, this.wav, @required this.uuid});
}
