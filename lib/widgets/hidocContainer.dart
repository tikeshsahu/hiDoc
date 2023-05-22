import 'package:flutter/material.dart';

Container hidocContainer(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.03,
    width: MediaQuery.of(context).size.width * 0.28,
    decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
    child: const Center(
      child: Text('hidoc', style: TextStyle(color: Colors.white, fontSize: 20)),
    ),
  );
}
