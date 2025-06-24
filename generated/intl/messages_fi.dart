// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fi locale. All the
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
  String get localeName => 'fi';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutUs": MessageLookupByLibrary.simpleMessage("Tietoa meistä"),
    "aboutUsText": MessageLookupByLibrary.simpleMessage(
      "Tervetuloa myVideo-sovellukseen! Tarjoamme laadukkaita videoita.\nOlemme sitoutuneet tuomaan sinulle parhaan katselukokemuksen, ja arvostamme palautettasi.\nJos sinulla on kysymyksiä tai ehdotuksia, ota rohkeasti yhteyttä.",
    ),
    "clicktoWatch": MessageLookupByLibrary.simpleMessage("Katso"),
    "contactUs": MessageLookupByLibrary.simpleMessage("Ota yhteyttä"),
    "english": MessageLookupByLibrary.simpleMessage("Englanti"),
    "errorLoadingVideos": MessageLookupByLibrary.simpleMessage(
      "Virhe ladattaessa videoita",
    ),
    "finnish": MessageLookupByLibrary.simpleMessage("Suomi"),
    "fixTimestamps": MessageLookupByLibrary.simpleMessage(
      "Videoluettelo päivitetty",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Koti"),
    "language": MessageLookupByLibrary.simpleMessage("Kieli"),
    "menu": MessageLookupByLibrary.simpleMessage("Valikko"),
    "noTitle": MessageLookupByLibrary.simpleMessage("Ei otsikkoa"),
    "noVideo": MessageLookupByLibrary.simpleMessage("Videota ei löytynyt"),
    "searchVideos": MessageLookupByLibrary.simpleMessage("Hae videoita..."),
    "watch": MessageLookupByLibrary.simpleMessage("Katso"),
  };
}
