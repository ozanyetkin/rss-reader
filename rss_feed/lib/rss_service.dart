import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class RssService {
  final String url;

  RssService(this.url);

  Future<List<RssItem>> fetchRssFeed() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        var document = xml.XmlDocument.parse(decodedResponse);
        var items = document.findAllElements('item');
        return items.map((item) {
          String? imageUrl;
          if (item.findElements('media:content').isNotEmpty) {
            imageUrl =
                item.findElements('media:content').first.getAttribute('url');
          } else if (item.findElements('image').isNotEmpty) {
            imageUrl = item.findElements('image').first.text;
          } else if (item.findElements('enclosure').isNotEmpty) {
            imageUrl = item.findElements('enclosure').first.getAttribute('url');
          }

          return RssItem(
            title: item.findElements('title').single.text,
            description: item.findElements('description').single.text,
            link: item.findElements('link').single.text,
            imageUrl: imageUrl ?? '',
          );
        }).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load RSS feed');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load RSS feed');
    }
  }
}

class RssItem {
  final String title;
  final String description;
  final String link;
  final String imageUrl;

  RssItem({
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
  });
}
