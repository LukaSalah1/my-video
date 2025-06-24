import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
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
        '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(uint8List);
      videoThumbnails[videoUrl] = tempFile.path;
      return tempFile.path;
    }
  } catch (e) {
    print('Error generating thumbnail: $e');
  }
  return null;
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: s.searchVideos,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.black, fontSize: 18),
          onChanged: (query) {
            setState(() {
              _searchQuery = query.toLowerCase();
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('videos')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text(s.errorLoadingVideos));

          final videos =
              snapshot.data!.docs.where((doc) {
                final video = doc.data() as Map<String, dynamic>;
                final titleMap = video['title'] as Map<String, dynamic>;
                final title =
                    titleMap[localeCode]?.toString().toLowerCase() ??
                    titleMap.values.first.toString().toLowerCase();
                return title.contains(_searchQuery);
              }).toList();

          if (videos.isEmpty) {
            return Center(child: Text(s.noVideo));
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index].data() as Map<String, dynamic>;
              final titleMap = video['title'] as Map<String, dynamic>;
              final title = titleMap[localeCode] ?? titleMap.values.first;

              return FutureBuilder<String?>(
                future: generateThumbnail(video['url']),
                builder: (context, thumbSnapshot) {
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/vidDesc',
                          arguments: video,
                        );
                      },
                      child: Container(
                        height: 120,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    thumbSnapshot.hasData
                                        ? Image.file(
                                          File(thumbSnapshot.data!),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                        : Container(color: Colors.grey[300]),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
