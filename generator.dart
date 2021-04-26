import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' show parse;
import 'dart:io';
import 'package:sass/sass.dart' as sass;

class AttributeRemover extends TreeVisitor {
  String _language;

  AttributeRemover(String language) {
    _language = language;
  }

  void visit(Node node) {
    if (node.attributes.containsKey('data-text-' + _language)) {
      node.insertBefore(Text(node.attributes['data-text-' + _language]), node.firstChild);

    }
    if (node.attributes.containsKey('data-tail-' + _language)) {
      node.parent.nodes.insert(node.parent.nodes.indexOf(node) + 1, Text(node.attributes['data-tail-' + _language]));
    }
    node.attributes.removeWhere((Object key, String value) => key.toString().startsWith('data-text-') || key.toString().startsWith('data-tail-'));
    visitChildren(node);
  }
}

void main() {
  var htmlFile = File('application.html');
  var html = htmlFile.readAsStringSync();
  for (var language in ['en', 'es']) {
    var htmlDoc = parse(html);
    htmlDoc.documentElement.attributes["lang"] = language;
    var attributeRemover = AttributeRemover(language);
    attributeRemover.visit(htmlDoc.body);
    var hdcHeader = htmlDoc.querySelector('.hdc-header');
    htmlDoc.querySelector('#application-form').children.insert(0, hdcHeader.clone(true));
    htmlDoc.querySelector('#consent').children.insert(0, hdcHeader.clone(true));
    var lsuhscHeader = htmlDoc.querySelector('.lsu-logo-container');
    htmlDoc.querySelector('#phi_release').children.insert(0, lsuhscHeader.clone(true));
    File('application_' + language + '.html').writeAsStringSync(htmlDoc.outerHtml);
  }


}

