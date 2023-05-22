import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hidoc/Services/apiService.dart';
import 'package:hidoc/class/article.dart';
import 'package:hidoc/class/bulletin.dart';
import 'package:hidoc/widgets/dropDownBox.dart';
import 'package:http/http.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late Article article;
  late Bulletin bulletin;
  late List<Bulletin> trendingBulletin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API.getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Response response = snapshot.data as Response;
          dynamic responseBody = jsonDecode(response.body);
          article = Article.fromJson(responseBody["data"]["article"]);

          bulletin = Bulletin.fromJson(responseBody["data"]["bulletin"][0]);

          trendingBulletin =
              Bulletin.fromJsonList(responseBody["data"]["trandingBulletin"]);

          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Articles',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 20),
                    dropdownBox(context),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        articleImage(context),
                        const SizedBox(width: 10),
                        articleDetails(context),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 700,
                                  child: ListView.builder(
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return bulletinBox(context);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        trendingBullBox(context)
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.45,
                      color: const Color(0xFF091734),
                    )
                  ],
                ),
              ),
            )),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }

  Expanded trendingBullBox(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Card(
            color: const Color(0xFFD8EBEF),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trending Hidoc Bulletin',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: trendingBulletin.length,
                        itemBuilder: (context, index) {
                          return trendingBulletinBox(index, context);
                        },
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  Expanded articleImage(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.65,
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.newspaper,
              size: MediaQuery.of(context).size.height * 0.18,
              color: Colors.grey,
            ),
          ),
        ),
        Positioned(
            bottom: 0.1,
            right: 0.1,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.08,
                decoration: const BoxDecoration(
                    color: Color(0xFF2EC4D8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                    )),
                child: Center(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Points',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          article.rewardPoints.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )))
      ]),
    );
  }

  Expanded articleDetails(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        //color: Colors.amber,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              article.articleTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              //article.articleDescription,
              'Necessary properties are present and of the correct type before accessing them. This should help prevent the error you were encountering.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             WebViewScreen(url: article.redirectLink)));
                },
                child: const Text('Read full article to earn points',
                    style: TextStyle(
                        color: Color(0xFF2EC4D8),
                        fontSize: 15,
                        decoration: TextDecoration.underline))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Published Date: ${article.createdAt}'.substring(0, 26),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column trendingBulletinBox(int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              trendingBulletin[index].articleTitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              trendingBulletin[index].articleDescription!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            )
          ],
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => WebViewScreen(
            //               url: trendingBulletin[index].redirectLink!,
            //             )));
          },
          child: const Text(
            'Read More',
            style: TextStyle(
                color: Color(0xFF2EC4D8),
                fontSize: 15,
                decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Column bulletinBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 5,
            width: MediaQuery.of(context).size.width * 0.25,
            color: Colors.blue,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(
                bulletin.articleTitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                bulletin.articleDescription!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => WebViewScreen(
            //               url: bulletin.redirectLink!,
            //             )));
          },
          child: const Text(
            'Read More',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
