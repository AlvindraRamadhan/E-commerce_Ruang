import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Bisa ditambahkan logging atau menampilkan error jika gagal
      throw 'Could not launch $url';
    }
  }
}
