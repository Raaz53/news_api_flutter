import 'dart:io';
import 'package:http/http.dart';
import 'package:news_app/models/article.dart';

import '../models/model_class.dart';

class HttpConnection {
  final String link = 'https://newsapi.org/v2/everything';
  final String apikey = "e86642e1a5ef4a5e9c5a4e2ce29c2815";

  Future<NewsApi> getData({String? query = 'apple'}) async {
    try {
      final response = await get(Uri.parse(
        '$link?q=$query&apiKey=$apikey',
      ));
      if (response.statusCode == 200) {
        return newsApiFromJson(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException catch (err) {
      throw Exception('No Internet Connection:${err.message}');
    } on HttpException catch (err) {
      throw Exception('HTTP error: ${err.message}');
    } catch (err) {
      throw Exception('Unexpected error: $err');
    }
  }
}
