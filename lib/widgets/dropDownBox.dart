import 'package:flutter/material.dart';

Card dropdownBox(BuildContext context) {
  var items = [
    'Articles',
    'Bulletins',
  ];
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 8,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: DropdownButton(
          value: 'Articles',
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ),
    ),
  );
}
