import 'package:flutter/material.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'generated/l10n.dart';

final Map<String, String> videoThumbnails = {};

Future<String?> generateThumbnail(String videoUrl) async {
  try {
    if (videoThumbnails.containsKey(videoUrl)) {
      return videoThumbnails[videoUrl];
    }

    final uint8List = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 75,
      timeMs: 5000,
    );

    if (uint8List != null) {
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(uint8List);
      videoThumbnails[videoUrl] = tempFile.path;
      return tempFile.path;
    }
  } catch (e) {
    print('Thumbnail error: $e');
  }
  return null;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> fixMissingTimestamps(BuildContext context) async {
    final collection = FirebaseFirestore.instance.collection('videos');
    final snapshot = await collection.get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (!data.containsKey('timestamp') || data['timestamp'] == null) {
        await doc.reference.update({'timestamp': FieldValue.serverTimestamp()});
        print('Updated doc ${doc.id}');
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context).fixTimestamps)));
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    MyApp.setLocale(context, locale);
    Navigator.pop(context);
  }

  Widget _buildTitle(S s) {
    return Center(
      child: Text('myVideo', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(s),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: s.fixTimestamps,
            onPressed: () => fixMissingTimestamps(context),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    s.menu,
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.search, color: Colors.black),
                    title: Text(
                      s.searchVideos,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(s.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(s.aboutUs),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aboutUs');
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: Text(s.contactUs),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contactUs');
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                s.language,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: Text(s.english),
              onTap: () => _changeLanguage(context, Locale('en')),
            ),
            ListTile(
              leading: Text('🇫🇮', style: TextStyle(fontSize: 24)),
              title: Text(s.finnish),
              onTap: () => _changeLanguage(context, Locale('fi')),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('videos')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(s.errorLoadingVideos));
          }

          final videos = snapshot.data!.docs;

          if (videos.isEmpty) {
            return Center(child: Text(s.noVideo));
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index].data() as Map<String, dynamic>;
              final videoId = videos[index].id;
              final isUnlocked = MyApp.unlockedVideos.contains(videoId);

              // Expect your video 'title' field to be a Map<String, dynamic> like
              // {"en": "English title", "fi": "Suomenkielinen otsikko"}
              String title = s.noTitle;
              if (video.containsKey('title') && video['title'] is Map) {
                Map titleMap = video['title'];
                if (titleMap.containsKey(localeCode)) {
                  title = titleMap[localeCode] ?? s.noTitle;
                } else {
                  title = titleMap.values.first ?? s.noTitle;
                }
              } else if (video.containsKey('title') &&
                  video['title'] is String) {
                // fallback if your data is still string
                title = video['title'];
              }

              return FutureBuilder<String?>(
                future: generateThumbnail(video['url']),
                builder: (context, thumbSnapshot) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          isUnlocked ? '/watch' : '/vidDesc',
                          arguments: {'id': videoId, ...video},
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 100,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  thumbSnapshot.hasData
                                      ? Image.file(
                                        File(thumbSnapshot.data!),
                                        width: 140,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 140,
                                        height: 90,
                                        color: Colors.grey[300],
                                      ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
