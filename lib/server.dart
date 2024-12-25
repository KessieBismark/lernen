import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

// var env = DotEnv()..load();

// final url = PocketBase(env.get('pocketbase_api'));

// final aiUrl = env.get("ai_backend");


final url = PocketBase("<your pocketbase link here>");
final aiUrl = "<your AI api endpoint here>";
class Query {
  static var header = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  static Future queryData({var query, required String endPoint}) async {
    try {
      var res = await http.post(
        Uri.parse(
          "$aiUrl/$endPoint",
        ),
        headers: header,
        body: query,
      );
      if (res.statusCode == 200) {
        return res.body;
      } else {
        print.call(res.body);
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future getData({required String endPoint}) async {
    try {
      var res = await http.get(Uri.parse("$aiUrl/$endPoint"));
      if (res.statusCode == 200) {
        return res.body;
      } else {
        print.call(res.body);
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }
}
