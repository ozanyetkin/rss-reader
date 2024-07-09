import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class RssService {
  final String url;

  RssService(this.url);

  Future<List<RssItem>> fetchRssFeed() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var document = xml.XmlDocument.parse(response.body);
      var items = document.findAllElements('item');
      return items.map((item) {
        return RssItem(
          title: item.findElements('title').single.innerText,
          description: item.findElements('description').single.innerText,
          link: item.findElements('link').single.innerText,
        );
      }).toList();
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }
}

class RssItem {
  final String title;
  final String description;
  final String link;

  RssItem({
    required this.title,
    required this.description,
    required this.link,
  });
}
