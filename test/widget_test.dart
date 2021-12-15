import "package:http/http.dart" as http;

void main() async {
  final Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
  final response = await http.get(url, headers: {
    "key": "b0c6d61e27e64814c1f55f44b2cef2a3",
  });

  print(response.body);
}
