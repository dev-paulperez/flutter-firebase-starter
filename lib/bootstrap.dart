import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app/bloc_observer.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AppBlocObserver extends BlocObserver {}

void bootstrap(Future<Widget> Function() builder) async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  NotificationService().configure();

  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: '234963458267270',
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }

  await runZonedGuarded<Future<void>>(
    () async => runApp(await builder()),
    FirebaseCrashlytics.instance.recordError,
  );
}