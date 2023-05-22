import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hidoc/Services/apiService.dart';
import 'package:hidoc/class/article.dart';
import 'package:hidoc/class/bulletin.dart';
import 'package:hidoc/screens/mobileScreens/bulletinScreen.dart';
import 'package:hidoc/screens/mobileScreens/webViewScreen.dart';
import 'package:hidoc/widgets/appbarWidget.dart';
import 'package:hidoc/widgets/dropDownBox.dart';
import 'package:hidoc/widgets/hidocContainer.dart';
import 'package:http/http.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  String dropdownValue = 'Critical Care';
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
                body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-5, -1.3),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.4,
                      backgroundColor: Colors.orange[200],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        hidocContainer(context),
                        appBar(context),
                        const SizedBox(height: 10),
                        dropdownBox(context),
                        articleCard(context),
                        bulletinBox(context)
                      ],
                    ),
                  )
                ],
              ),
            ));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        });
  }

  Padding bulletinBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hidoc Bulletin',
            style: TextStyle(
                color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 5,
            width: MediaQuery.of(context).size.width * 0.25,
            color: Colors.blue,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                bulletin.articleTitle!,
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
              Text(
                bulletin.articleDescription!,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BulletinScreen(
                          bulletin: bulletin,
                          trendingBulletin: trendingBulletin)));
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
      ),
    );
  }

  Padding articleCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [cardImage(context), textsBox(), pointsBox(context)],
        ),
      ),
    );
  }

  pointsBox(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebViewScreen(url: article.redirectLink)));
              },
              child: const Text('Read full article to earn points',
                  style: TextStyle(
                      color: Color(0xFF2EC4D8),
                      fontSize: 15,
                      decoration: TextDecoration.underline))),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.15,
          decoration: const BoxDecoration(
              color: Color(0xFF2EC4D8),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
              )),
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
        )
      ],
    );
  }

  Container cardImage(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        //width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: Center(
          child: Icon(
            Icons.file_copy,
            size: MediaQuery.of(context).size.height * 0.15,
            color: Colors.white,
          ),
        ));
  }

  Padding textsBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        children: [
          Text(
            article.articleTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
          )
        ],
      ),
    );
  }
}
