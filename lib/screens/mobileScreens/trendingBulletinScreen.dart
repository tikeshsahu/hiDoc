import 'package:flutter/material.dart';
import 'package:hidoc/class/bulletin.dart';
import 'package:hidoc/screens/mobileScreens/webViewScreen.dart';
import 'package:hidoc/widgets/appbarWidget.dart';
import 'package:hidoc/widgets/hidocContainer.dart';

class TrendingBulletinScreen extends StatelessWidget {
  const TrendingBulletinScreen({super.key, required this.trendingBulletin});

  final List<Bulletin> trendingBulletin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                hidocContainer(context),
                appBar(context),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Card(
                    color: Color(0xFFD8EBEF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                          //Expanded
                          SizedBox(
                              height: 700,
                              //height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: trendingBulletin.length,
                                itemBuilder: (context, index) {
                                  return bulletinBox(
                                      trendingBulletin, index, context);
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }

  Column bulletinBox(List trandingBulletin, int index, BuildContext context) {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                          url: trendingBulletin[index].redirectLink!,
                        )));
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
}
