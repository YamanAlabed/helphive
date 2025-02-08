import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/theme/colors.dart';

class HorizontalListWidget extends StatefulWidget {
  final List<String> items;
  final Function(String?) onCategorySelected;

  const HorizontalListWidget({
    super.key,
    required this.items,
    required this.onCategorySelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalListWidgetState createState() => _HorizontalListWidgetState();
}

class _HorizontalListWidgetState extends State<HorizontalListWidget> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.items.map((item) {
          bool isSelected = item == selectedItem;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedItem = isSelected ? null : item;
                });
                widget.onCategorySelected(selectedItem);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isSelected ? colorCoolGray : colorDarkGray,
                  shape: BoxShape.circle, // Kreisform
                ),
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}