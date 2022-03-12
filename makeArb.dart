import 'dart:io';

const rowLang = 1;
const colJsonProperty = 2;
const dirL10n = 'lib/l10n';
const tsvName = 'text4arb - water.tsv';

void main() async {
  final File file = File('$dirL10n/$tsvName');

  print(file.absolute);

  List<String> lines = await file.readAsLines();
  int length = lines.length;

  int numOfLang = -1;

  List<String> lang = [];
  var map = <String, Map<String, String>>{};

  // データの読み込み
  for (int i = rowLang; i < length; i++) {
    List<String> rows = lines[i].split('\t');

    if (lang.isEmpty) {
      lang = rows;
      numOfLang = lang.length - 3;
    } else {
      // ,タイトル,title,Flutter Demo Home Page,Fladder Demo Tuisblad
      for (int j = colJsonProperty + 1; j < rows.length - 1; j++) {
        var language = lang[j];
        map.putIfAbsent(language, () => <String, String>{});

        String key = rows[colJsonProperty];
        if (key.isNotEmpty) {
          map[language]!.putIfAbsent(key, () => rows[j]);
        }
      }
    }
  }

  // データの出力
  for (String keyLang in lang) {
    var langData = map[keyLang];
    if (langData != null) {
      final File output = File('$dirL10n/app_$keyLang.arb');
      output.writeAsString(makeArb(keyLang, langData));
    }
  }
}

String makeArb(String language, Map<String, String> map) {
  StringBuffer buffer = StringBuffer();
  buffer.writeln('{"@@locale":"${language.replaceAll('-', '_')}",');
  for (String key in map.keys) {
    String value = map[key]!;
    value = value.replaceAll('/', '\/');
    value = value.replaceAll('\\', '\\\\');
    value = value.replaceAll('"', '\\"'); // " -> \"

    buffer.writeln('"$key":"$value",');
  }

  return buffer.toString().substring(0, buffer.length - 2) + '}';
}
