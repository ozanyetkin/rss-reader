import 'package:flutter/material.dart';
import 'rss_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RssService rssService =
      RssService('https://www.futboo.com/rss_super-lig_42.xml');

  late Future<List<RssItem>> rssItems;

  @override
  void initState() {
    super.initState();
    rssItems = rssService.fetchRssFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS Reader'),
      ),
      body: FutureBuilder<List<RssItem>>(
        future: rssItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title:
                      Text(item.title, style: TextStyle(fontFamily: 'Roboto')),
                  subtitle: Text(item.description,
                      style: TextStyle(fontFamily: 'Roboto')),
                  onTap: () => _launchURL(item.link),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _launchURL(String url) {
    // You can use a package like url_launcher to open the URL
    // For example, url_launcher can be added to pubspec.yaml and used here
  }
}
