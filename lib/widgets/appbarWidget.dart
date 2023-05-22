import 'package:flutter/material.dart';

Padding appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.orange[100],
              radius: 22,
              child: const Center(
                  child: Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              )),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.23),
          child: const Text('Articles',
              style: TextStyle(color: Colors.black, fontSize: 24)),
        )
      ],
    ),
  );
}
