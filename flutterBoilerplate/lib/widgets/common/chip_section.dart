import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as my;
import 'package:flutterBoilerplate/widgets/common/chip_list.dart';

class ChipSection extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final Color activeChipColor;
  final Color inactiveChipColor;
  final List<my.Chip> chips;
  final void Function(my.Chip chip) toggleChip;

  const ChipSection({
    this.chips,
    this.title,
    this.height,
    this.width,
    this.activeChipColor,
    this.inactiveChipColor,
    this.toggleChip,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ChipList(
              chips: chips,
              activeChipColor: activeChipColor,
              inactiveChipColor: inactiveChipColor,
              toggleChip: toggleChip,
            )
          ],
        ),
      );
}