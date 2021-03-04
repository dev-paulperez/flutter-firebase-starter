import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/screens/init_app.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_handler.dart';
import 'package:firebasestarter/services/dynamic_links/email_secure_storage.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
      ],
      child: FirebaseStarter(),
    );
  }
}

class FirebaseStarter extends StatefulWidget {
  @override
  _FirebaseStarterState createState() => _FirebaseStarterState();
}

class _FirebaseStarterState extends State<FirebaseStarter> {
  @override
  void initState() {
    NotificationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(),
        ),
        ProxyProvider2<LoginBloc, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, LoginBloc loginBloc, EmailSecureStore storage, __) =>
              FirebaseEmailLinkHandler(
            auth: FirebaseAuthService(),
            emailStore: storage,
            firebaseDynamicLinks: FirebaseDynamicLinks.instance,
          )..init(),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: DetermineAccessScreen(),
      ),
    );
  }
}
