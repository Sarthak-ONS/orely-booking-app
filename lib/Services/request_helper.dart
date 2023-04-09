import 'package:http/http.dart' as http;

class RequestHelper {
  final hostUrl = "http://localhost:4000";

  Future request({required String endPoint}) async {
    try {
      final http.Response response = await http.post(Uri.parse(endPoint));
      if (response.statusCode < 300) {
        print(response.body);
        print(response);
        return response.body;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}
