import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class VideoDesc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final video =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final localeCode = Localizations.localeOf(context).languageCode;
    final titleMap = video['title'] as Map<String, dynamic>;
    final title =
        titleMap.containsKey(localeCode)
            ? titleMap[localeCode]
            : titleMap.values.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('myVideo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/watch',
                      arguments: video,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black,
                  ),
                  child: Text(
                    s.clicktoWatch,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
