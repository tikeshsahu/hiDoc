import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hidoc/Services/apiService.dart';
import 'package:hidoc/class/article.dart';
import 'package:hidoc/class/bulletin.dart';
import 'package:hidoc/widgets/dropDownBox.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late Article article;
  late Bulletin bulletin;
  late List<Bulletin> trendingBulletin;
  late List<Article> trendingArticle;
  late List<Article> exploreArticle;
  late List<Article> latestArticle;

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

          latestArticle = Article.fromJsonListArticle(
              responseBody["data"]["latestArticle"]);

          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appBar(context),
                    const SizedBox(height: 20),
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
                            child: SizedBox(
                              height: 550,
                              child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return bulletinBox(context);
                                },
                              ),
                            )),
                        trendingBullBox(context)
                      ],
                    ),
                    const SizedBox(height: 20),
                    readMoreButton(context),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        latestArticles(context),
                        trendingArticles(context),
                        exploreArticles(context),
                      ],
                    ),
                    const SizedBox(height: 30),
                    infoBox(context),
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

  Expanded exploreArticles(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Column(
                children: [
                  const Text(
                    'Explore more in Articles',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        itemCount: exploreArticle.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          );
                        },
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: 45,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  exploreArticle[index].articleTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )));
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
      ),
    );
  }

  Expanded trendingArticles(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //height: MediaQuery.of(context).size.height * 0.63,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Column(
            children: [
              const Text(
                'Trending Articles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
              const SizedBox(height: 10),
              SizedBox(
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
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(
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
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'Emerging Zoonotic diseases and the One Health approach',
                          //trendingArticle[1].articleTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Expanded latestArticles(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Column(
            children: [
              const Text(
                'Latest Articles',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.separated(
                    itemCount: latestArticle.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (context, index) {
                      return latestArticle == null
                          ? SizedBox(
                              height: 45,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  latestArticle[index].articleTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )))
                          : const Center(
                              child: Text('No Latest Articles'),
                            );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card appBar(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HIDoc',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              // Listview.seperated using appBarTitles

              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 25,
                //color: Colors.amber,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appBarTitles.length,
                        separatorBuilder: (context, index) {
                          return VerticalDivider(
                            color: Colors.grey[600],
                            thickness: 1,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Text(
                            appBarTitles[index],
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[700]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: Center(
                            child: Text(
                          'G',
                          style: TextStyle(
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox readMoreButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.4,
      height: 50,
      child: ElevatedButton(
          // color to button
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EC4D8),
          ),
          onPressed: () {},
          child: const Text('Read More Bulletins')),
    );
  }

  Container infoBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.45,
      color: const Color(0xFF091734),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HiDoc',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text(
                        'HiDoc is a platform that connects patients and doctors.\nDoctors can manage',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF091734),
                            child: Icon(Icons.facebook_outlined),
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF091734),
                            child: Icon(Icons.facebook_outlined),
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF091734),
                            child: Icon(Icons.facebook_outlined),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Reach Us',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text('Please contact below details for any other\ninformation.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text('Email:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    )),
                Text('info@hidoc.co',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )),
                SizedBox(height: 20),
                Text('Address:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    )),
                Text(
                    'HiDoc Technologies Pvt Ltd,No. 1, 1st Floor, 1st Main,\n1st Block, Koramangala.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HIDOC DR. FEATURES',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    width: MediaQuery.of(context).size.width * 0.435,
                    color: Colors.white,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 210,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0),
                        itemCount: featuresData.length,
                        itemBuilder: (BuildContext context, index) {
                          final featureName =
                              featuresData.keys.elementAt(index);
                          final featureIcon = featuresData[featureName];
                          return Container(
                              //alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:
                                      colors[Random().nextInt(colors.length)],
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.blue,
                                      child: Icon(featureIcon,
                                          color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Text(featureName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                ],
                              ));
                        }),
                  )
                ],
              ))
        ],
      ),
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
                  const SizedBox(height: 20),
                  SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
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
            //launchUrl(Uri.parse(trendingBulletin[index].redirectLink!));
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
        const Text(
          ' Hidoc Bulletin',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
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

  Map featuresData = {
    "Social Network": Icons.people_alt_sharp,
    "Case Presentation": Icons.medical_services_sharp,
    "Quizzes": Icons.quiz_sharp,
    "Articles": Icons.article_sharp,
    "Drugs": Icons.file_copy_sharp,
    "Webinars": Icons.webhook_sharp,
    "Calculators": Icons.calculate_sharp,
    "Guidelines": Icons.pages_sharp
  };

  List<Color> colors = [
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.red[100]!,
    Colors.orange[100]!,
  ];

  List<String> appBarTitles = [
    'Social',
    'Cases',
    'Quizzes',
    'Articles',
    'Drugs',
    'Webinars',
    'Calculators',
    'Guidelines',
    'News',
    'Surveys',
    'Clinical Trails'
  ];
}

class Features {
  String name;
  IconData icon;
  Color color;
  Features({required this.name, required this.icon, required this.color});
}
