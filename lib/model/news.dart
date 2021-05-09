import 'package:flutter/material.dart';

class News {
  String title;
  String summary;
  String published;
  bool isliked;

  News({this.title,this.summary,this.published,this.isliked});

  

  //  static Resource<List<News>> get all {
    
  //   return Resource(
  //     url: Constants.HEADLINE_NEWS_URL,
  //     parse: (response) {
  //       final result = json.decode(response.body); 
  //       Iterable list = result['articles'];
  //       return list.map((model) => NewsArticle.fromJson(model)).toList();
  //     }
  //   );

  // }


}