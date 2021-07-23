import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'app_version_state.dart';

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit({@required AppInfo appInfo})
      : assert(appInfo != null),
        _appInfo = appInfo,
        super(const AppVersionState());

  final AppInfo _appInfo;

  void appVersion() async {
    final version = await _appInfo.getVersionNumber();
    emit(state.copyWith(appVersion: version));
  }
}