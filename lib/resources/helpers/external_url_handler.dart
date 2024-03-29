import 'package:url_launcher/url_launcher.dart';

class ExternalUrlHandler {

  const ExternalUrlHandler();
  
  Future<void> go({required String url}) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}