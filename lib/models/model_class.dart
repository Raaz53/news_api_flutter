import 'dart:convert';

import 'article.dart';

NewsApi newsApiFromJson(String str) => NewsApi.fromJson(json.decode(str));

String newsApiToJson(NewsApi data) => json.encode(data.toJson());

class NewsApi {
  String? status;
  int? totalResults;
  List<Article>? articles;

  NewsApi({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApi.fromJson(Map<String, dynamic> json) => NewsApi(
      status: json["status"] ?? '',
      totalResults: json["totalResults"] ?? 0,
      articles:
          List<Article>.from(json["articles"].map((x) => Article.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles!.map((x) => x.toJson())),
      };
}
