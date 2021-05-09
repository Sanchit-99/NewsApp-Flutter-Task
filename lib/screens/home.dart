import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newsapp/model/news.dart';

class Home extends StatefulWidget {
  static String id='home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String api = "https://api.first.org/data/v1/news/";

  List<News> newsList = [];
  List<News> favList = [];
  bool isNews = true;

  void fetchNews() async {
    final http.Response response = await http.get(Uri.parse(api));
    final Map<String, dynamic> responseData = json.decode(response.body);
    await responseData['data'].forEach((e) {
      final News news = News(
        title: e['title'],
        summary: e['summary'],
        published: e['published'],
        isliked: false,
      );
      setState(() {
        newsList.add(news);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: HexColor('#f5f5f5'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: mq.width,
              margin: EdgeInsets.only(bottom: 55),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  for (var item in isNews ? newsList : favList)
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  item.isliked = !item.isliked;
                                  if (item.isliked) {
                                    favList.add(item);
                                  } else {
                                    favList.remove(item);
                                  }
                                });
                              },
                              child: Icon(
                                item.isliked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: item.isliked ? Colors.red : Colors.black,
                                size: 35,
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 260,
                                  child: Text(
                                    item.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    width: 260,
                                    child: Text(item.summary.toString())),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: 260,
                                  child: Text(
                                    item.published,
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: mq.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isNews = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: isNews ? HexColor('#2d56be') : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      width: mq.width * 0.49,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list,
                            color: isNews ?  Colors.white : Colors.black,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'News',
                            style: TextStyle(
                                color: isNews ?  Colors.white : Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isNews = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: isNews ? Colors.white : HexColor('#2d56be'),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      width: mq.width * 0.49,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: isNews ? Colors.red : Colors.white,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Favs',
                            style: TextStyle(
                                color: isNews ? Colors.black : Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
