import 'dart:convert';

import 'package:fcm_automate/model/article.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

enum ArticlesState { Loading, Loaded, Error }

class ArticleProvider extends ChangeNotifier {
  List<Article> _genList = [];

  List<Article> get genList {
    return [..._genList];
  }

  List<Article> categoryList({required String category}) {
    print(category);

    switch (category) {
      case 'general':
        return [..._genList];

      default:
        return [..._genList];
    }
  }

  ArticlesState _articlesState = ArticlesState.Loading;
  ArticlesState get getArticlesState => _articlesState;
// request for category articles

  Future<List<Article>> getArticle({
    required String category,
    String country = "in",
  }) async {
    Uri url = Uri.parse(
        "https://raw.githubusercontent.com/prakasharyaman/NewpaperNews-API/main/top-headlines/category/general/in.json");

    List<Article> tempList = [];

    try {
      var response = await http.get(url);
      Map<String, dynamic> result =
          json.decode(response.body) as Map<String, dynamic>;

      //  print(json.decode(response.body));

      if (result["status"] == "ok") {
        // print('result article length =${result["articles"].length}');

        result["articles"].forEach((article) {
          //  print('inside status ok for each loop condition true');
          if (article['source']['name'] != null &&
              article['description'] != null &&
              article['urlToImage'] != null &&
              article['content'] != null &&
              article['url'] != null &&
              article['title'] != null &&
              article['publishedAt'] != null) {
            String temp = article['publishedAt'];

            String dateTime = "    " +
                temp.substring(0, temp.indexOf('T')) +
                "    " +
                temp.substring(temp.indexOf('T') + 1, temp.length - 1);
            tempList.add(
              Article(
                sourceName: article["source"]["name"],
                title: article["title"],
                description: article["description"],
                content: article['content'],
                url: article["url"],
                urlToImage: article["urlToImage"],
                publishedAt: dateTime,
              ),
            );
          }
        });

        if (tempList.isEmpty) {
          print('list is empty ....');
        }
        print(
            'the total number of articles in $category is ${tempList.length}');
      }
    } catch (error) {
      print('Failed to get top articles : $error');
    }
    return tempList;
  }

  createArticleList({required String category}) async {
    try {
      print(category);
      _genList = await getArticle(
        category: 'general',
      );
      _articlesState = ArticlesState.Loaded;
      if (_genList == []) {
        print('empty lists ');
      }
      notifyListeners();
    } on Exception catch (e) {
      print('Failed to get articles : $e');
      _articlesState = ArticlesState.Error;
      notifyListeners();
    }
  }
}
