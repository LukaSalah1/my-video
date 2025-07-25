// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutUs": MessageLookupByLibrary.simpleMessage("About Us"),
    "aboutUsText": MessageLookupByLibrary.simpleMessage(
      "Welcome to the myVideo app! We provide high-quality videos.\nWe are committed to delivering the best viewing experience and appreciate your feedback.\nIf you have any questions or suggestions, please feel free to contact us.",
    ),
    "clicktoWatch": MessageLookupByLibrary.simpleMessage("Watch"),
    "contactUs": MessageLookupByLibrary.simpleMessage("Contact Us"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "errorLoadingVideos": MessageLookupByLibrary.simpleMessage(
      "Error loading videos",
    ),
    "finnish": MessageLookupByLibrary.simpleMessage("Finnish"),
    "fixTimestamps": MessageLookupByLibrary.simpleMessage(
      "Video list refreshed",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "noTitle": MessageLookupByLibrary.simpleMessage("No Title"),
    "noVideo": MessageLookupByLibrary.simpleMessage("No video found"),
    "searchVideos": MessageLookupByLibrary.simpleMessage("Search videos..."),
    "watch": MessageLookupByLibrary.simpleMessage("Watch"),
  };
}
