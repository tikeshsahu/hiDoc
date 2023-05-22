import 'package:flutter/material.dart';
import 'package:hidoc/class/bulletin.dart';
import 'package:hidoc/screens/mobileScreens/trendingBulletinScreen.dart';
import 'package:hidoc/screens/mobileScreens/webViewScreen.dart';
import 'package:hidoc/widgets/appbarWidget.dart';
import 'package:hidoc/widgets/hidocContainer.dart';

class BulletinScreen extends StatelessWidget {
  const BulletinScreen(
      {Key? key, required this.bulletin, required this.trendingBulletin})
      : super(key: key);

  final Bulletin bulletin;
  final List<Bulletin> trendingBulletin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrendingBulletinScreen(
                        trendingBulletin: trendingBulletin)));
          },
          child: const Text('Show Trending Bulletins'),
        ),
        body: Stack(
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
                  hidocContainer(context),
                  appBar(context),
                  const SizedBox(height: 20),
                  headerWidget(),
                  const SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return bulletinBox(context);
                    },
                  )),
                ],
              ),
            )
          ],
        ));
  }

  Row headerWidget() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Hidoc Bulletin',
            style: TextStyle(
                color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Column bulletinBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                          url: bulletin.redirectLink!,
                        )));
          },
          child: const Text(
            'Read More',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
