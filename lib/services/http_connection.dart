import 'dart:io';
import 'package:http/http.dart';
import 'package:news_app/models/article.dart';

import '../models/model_class.dart';

class HttpConnection {
  final String link = 'https://newsapi.org/v2/everything';
  final String apikey = "9087c011fb164a85929ac849b1ff0dc6";

  Future<NewsApi> getData({String? query = 'apple'}) async {
    try {
      final response = await get(Uri.parse(
        '$link?q=$query&apiKey=$apikey',
      ));
      if (response.statusCode == 200) {
        return newsApiFromJson(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException catch (err) {
      throw Exception('No Internet Connection:${err.message}');
    } on HttpException catch (err) {
      throw Exception('HTTP error: ${err.message}');
    } catch (err) {
      throw Exception('Unexpected error: $err');
    }
  }

  Future<Article> getOne() async {
    try {
      final response = await get(Uri.parse(
          '$link?q=tesla&from=2024-05-17&sortBy=publishedAt&apiKey=$apikey'));
      if (response.statusCode == 200) {
        return articlesFromJson(response.body);
      } else {
        throw Exception('Failed to load data');
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
