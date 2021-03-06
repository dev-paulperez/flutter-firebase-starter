import 'package:firebase_analytics/observer.dart';
import 'package:firebasestarter/bloc/create_account/create_account_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/init_app/init_app_bloc.dart';
import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/screens/init_app.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InitAppBloc>(
            create: (BuildContext context) =>
                InitAppBloc()..add(const IsFirstTime())),
        BlocProvider<LoginBloc>(
            create: (BuildContext context) =>
                LoginBloc()..add(const CheckIfUserIsLoggedIn())),
        BlocProvider<CreateAccountBloc>(
            create: (BuildContext context) => CreateAccountBloc()),
        BlocProvider<UserBloc>(
            create: (BuildContext context) => UserBloc()..add(const GetUser())),
        BlocProvider<EditProfileBloc>(
            create: (BuildContext context) =>
                EditProfileBloc()..add(const GetCurrentUser())),
        BlocProvider<EmployeesBloc>(
            create: (BuildContext context) =>
                EmployeesBloc()..add(const GetEmployees())),
        BlocProvider<ForgotPasswordBloc>(
            create: (BuildContext context) => ForgotPasswordBloc())
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
  NotificationService _notificationService;

  @override
  void initState() {
    _notificationService = GetIt.I<NotificationService>();
    _notificationService.configure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: DetermineAccessScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: GetIt.I.get<AnalyticsService>().getService(),
        ),
      ],
    );
  }
}
