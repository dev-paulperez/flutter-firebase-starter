import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/bloc/bloc_observer.dart';
import 'package:firebasestarter/locator.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  initServices();
  GetIt.I.get<AnalyticsService>().logAppOpen();
  runApp(App());
}
