import 'dart:io';

void main() {
  print("Enter string:");
  var originalString = stdin.readLineSync();
  var lang = stdin.readLineSync();
  if (lang.isEmpty) {
    lang = 'en';
  }
  if (lang == 'es') {
    print(originalString.substring(0,1).toUpperCase() + originalString.substring(1).toLowerCase());
  } else {
    print(originalString.replaceAllMapped(RegExp(r'\b(\w)(\w+)\b'), (Match match) => match[1].toUpperCase() + match[2].toLowerCase()));
  }
}