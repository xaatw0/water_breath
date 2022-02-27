import 'package:flutter_test/flutter_test.dart';

void main() {
  test("list", () {
    var list1 = <int>[1, 2, 3];
    list1.add(4);

    List<int> list2 = [1, 2, 3];
    list2.add(4);
  });

  test("const list", () {
    const list1 = <int>[1, 2, 3];
    list1.add(4);
  });

  test("const list", () {
    var list1 = const <int>[1, 2, 3];
    list1.add(4);
  });

  test("list combine", () {
    var l1 = [1, 2];
    var l2 = [3];

    // Spreads記法
    var l3 = [l1, l2]; //=> [[1,2],[3]]
    var l4 = [...l1, ...l2]; //=> [1,2,3]

    List<int>? l8 = null;
    var l10 = [...l1, ...?l8]; // [1,2]
    var l11 = [...l1, ...?l3]; //[1,2,3]

    // Collection if
    var l5 = [...l1, if (false) ...l2]; // [1,2]
    var l6 = [...l1, if (true) ...l2]; // [1,2,3]

    var l12 = [
      for (var i in [1, 2]) '$i'
    ]; // ['1','2']
  });

  test("String", () {
    var str1 = 'abc';
    var str2 = "abc";
    var str6 = "It's a pen";

    var str3 = '''
a
b
''';
    var str4 = """a
b
""";

    var str5 = '''
    a
    b
    ''';

    expect(str1, 'abc');
    expect(str1, "abc");
    expect(str2, 'abc');
    expect(str3, 'a\nb\n');
    expect(str4, 'a\nb\n');
    expect(str5, '    a\n    b\n    ');
    expect(str6, 'It\'s a pen');

    var str7 = r'a\nb';
    print(str7); // 「a\nb」と改行されずに表示される
  });

  test('equal', () {});
}
