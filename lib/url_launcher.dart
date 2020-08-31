import 'package:url_launcher/url_launcher.dart' as ul;

Future<void> urlLauncher(String url) async {
  if (await ul.canLaunch(url)) {
    await ul.launch(url);
  } else {
    throw Exception();
    // TODO: handle opening links to stuff in app
  }
}
