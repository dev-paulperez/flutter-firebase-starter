import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int index;
  final void Function(int) updateIndex;

  const BottomNavBar(this.index, this.updateIndex);

  Widget _item(int idx, IconData icon) => InkWell(
        onTap: () => updateIndex(idx),
        child: SizedBox(
          child: Icon(
            icon,
            color: idx == index ? AppColor.blue : AppColor.grey,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => BottomAppBar(
        elevation: 0.0,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.lightGrey,
            border: Border(
              top: BorderSide(color: Color(0xffC1C1C1), width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item(0, Feather.home),
                Margin(150.0, 0.0),
                _item(1, Feather.user),
              ],
            ),
          ),
        ),
      );
}
