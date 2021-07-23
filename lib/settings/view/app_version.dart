import 'package:firebasestarter/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasestarter/settings/settings.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appVersion = context.select(
      (AppVersionCubit cubit) => cubit.state.appVersion,
    );
    return appVersion != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appVersion,
                style: const TextStyle(
                  color: AppColor.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        : const CircularProgressIndicator();
  }
}
