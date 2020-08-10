import 'package:json_annotation/json_annotation.dart';

part 'captcha.g.dart';

/// based on https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-captcha
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Captcha {
  final String png;

  /// can be null
  final String wav;
  final String uuid;
  
  const Captcha({
    this.png,
    this.wav,
    this.uuid
  });

  factory Captcha.fromJson(Map<String, dynamic> json) =>
      _$CaptchaFromJson(json);
}
