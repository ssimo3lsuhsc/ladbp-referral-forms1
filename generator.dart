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
    htmlDoc.head.querySelector("link[rel=stylesheet]").replaceWith(Element.html('<style type="text/css">' + sass.compile('scss/app.scss') + '</style>'));
    var attributeRemover = AttributeRemover(language);
    attributeRemover.visit(htmlDoc.body);
    htmlDoc.querySelector('#consent').children.insert(0, htmlDoc.querySelector('.hdc-header').clone(true));
    File('application_' + language + '.html').writeAsStringSync(htmlDoc.outerHtml);
  }


}

