import 'package:flutter_emoji/flutter_emoji.dart';

class GeneralMethods {
  String convertToEmoji(String text) {

  var parser = EmojiParser();
  var coffee = Emoji('coffee', '☕');
  var heart  = Emoji('heart', '❤️');
  var smile= Emoji(':D','😃');

  text=text.replaceAll(':D', '😃');
 





    return text;
  }
}
