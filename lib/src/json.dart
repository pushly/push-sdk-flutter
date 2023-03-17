import 'dart:convert';

abstract class JsonObject {

  String toJson();

  String convert(Map<String, dynamic>? object) => const JsonEncoder
    .withIndent('  ')
    .convert(object)
    .replaceAll("\\n", "\n")
    .replaceAll("\\", "");
}