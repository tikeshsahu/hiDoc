import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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

  late Article article;
  late Bulletin bulletin;
  late List<Bulletin> trendingBulletin;
  late List<Article> trendingArticle;
  late List<Article> exploreArticle;

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

            trendingArticle = Article.fromJsonListArticle(
                responseBody["data"]["trandingArticle"]);

            exploreArticle = Article.fromJsonListArticle(
                responseBody["data"]["exploreArticle"]);

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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          hidocContainer(context),
                          appBar(context),
                          const SizedBox(height: 10),
                          dropdownBox(context),
                          articleCard(context),
                          const SizedBox(height: 20),
                          bulletinBox(context),
                          const SizedBox(height: 10),
                          readMoreButton(context),
                          const SizedBox(height: 40),
                          trendingArticles(context),
                          const SizedBox(height: 20),
                          exploreArticles(context),
                        ],
                      ),
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

  Padding exploreArticles(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Explore more in Articles',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                //const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.separated(
                      itemCount: exploreArticle.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                        url: exploreArticle[index]
                                            .redirectLink)));
                          },
                          child: SizedBox(
                              height: 45,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  exploreArticle[index].articleTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ElevatedButton(
                // color to button
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC4D8),
                ),
                onPressed: () {},
                child: const Text('Explore Hidoc Dr.')),
          )
        ],
      ),
    );
  }

  Padding trendingArticles(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Container(
        //height: MediaQuery.of(context).size.height * 0.63,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Trending Articles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                              url: trendingArticle[0].redirectLink)));
                },
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: trendingArticle[0].articleImg,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                            url: trendingArticle[0].redirectLink)));
              },
              child: SizedBox(
                  height: 45,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      trendingArticle[0].articleTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                            url: trendingArticle[1].redirectLink)));
              },
              child: SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 40,
                          width: 60,
                          child: CachedNetworkImage(
                            imageUrl: trendingArticle[1].articleImg,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'Emerging Zoonotic diseases and the\nOne Health approach',
                          //trendingArticle[1].articleTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  SizedBox readMoreButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 40,
      child: ElevatedButton(
          // color to button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BulletinScreen(
                        bulletin: bulletin,
                        trendingBulletin: trendingBulletin)));
          },
          child: const Text('Read More Bulletins')),
    );
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
