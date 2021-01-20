import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_bloc.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_event.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_state.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:flutterBoilerplate/screens/main_screen.dart';
import 'package:flutterBoilerplate/screens/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetermineAccessScreen extends StatefulWidget {
  @override
  _DetermineAccessScreenState createState() => _DetermineAccessScreenState();
}

class _DetermineAccessScreenState extends State<DetermineAccessScreen> {
  LoginBloc _bloc;
  InitAppBloc _initAppBloc;

  @override
  void initState() {
    super.initState();
    _initAppBloc = InitAppBloc();
    _initAppBloc.add(const IsFirstTime());
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.add(const CheckIfUserIsLoggedIn());
    super.didChangeDependencies();
  }

  Widget _checkIfUserIsLoggedIn() => BlocBuilder<LoginBloc, LoginState>(
        cubit: _bloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoggedIn:
              return MainScreen((state as LoggedIn).currentUser);
            default:
              return LoginScreen();
          }
        },
      );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<InitAppBloc, FirstTimeInAppState>(
        cubit: _initAppBloc,
        builder: (context, initAppState) {
          switch (initAppState.runtimeType) {
            case FirstTime:
              return OnBoardingScreen();
            case NoFirstTime:
              return _checkIfUserIsLoggedIn();
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      );
}