// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutUs => 'About Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutUsText => 'Welcome to the myVideo app! We provide high-quality videos.\nWe are committed to delivering the best viewing experience and appreciate your feedback.\nIf you have any questions or suggestions, please feel free to contact us.';

  @override
  String get language => 'Language';

  @override
  String get searchVideos => 'Search videos...';

  @override
  String get noVideo => 'No video found';

  @override
  String get english => 'English';

  @override
  String get finnish => 'Finnish';

  @override
  String get home => 'Home';

  @override
  String get menu => 'Menu';

  @override
  String get fixTimestamps => 'Video list refreshed';

  @override
  String get errorLoadingVideos => 'Error loading videos';

  @override
  String get noTitle => 'No Title';

  @override
  String get watch => 'Watch';

  @override
  String get clicktoWatch => 'Watch';
}
