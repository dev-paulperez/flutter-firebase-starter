import 'package:firebasestarter/bloc/email_sign_in/email_sign_in_bloc.dart';
import 'package:firebasestarter/bloc/email_sign_in/email_sign_in_event.dart';
import 'package:firebasestarter/bloc/email_sign_in/email_sign_in_state.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInWithEmailScreen extends StatefulWidget {
  @override
  _LogInWithEmailScreenState createState() => _LogInWithEmailScreenState();
}

class _LogInWithEmailScreenState extends State<LogInWithEmailScreen> {
  EmailSignInBloc _bloc;

  @override
  void initState() {
    _bloc = EmailSignInBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(
          title: Strings.emailSignIn,
        ),
        body: BlocListener<EmailSignInBloc, EmailSignInState>(
          cubit: _bloc,
          listener: (BuildContext context, EmailSignInState state) {
            if (state is EmailSent) {
              DialogHelper.showAlertDialog(
                context: context,
                story: AppLocalizations.of(context).emailSended,
                btnText: AppLocalizations.of(context).ok,
                btnAction: () => Navigator.pop(context),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Margin(0.0, 75.0),
                Text(
                  AppLocalizations.of(context).submitYourEmail,
                  style: const TextStyle(fontSize: 16),
                ),
                Margin(0.0, 40.0),
                TextFieldBuilder(
                  stream: _bloc.form.email,
                  labelText: AppLocalizations.of(context).email,
                  onChanged: (email) => _bloc.form.onEmailChanged(email),
                ),
                Margin(0.0, 41.0),
                Button(
                  text: AppLocalizations.of(context).send,
                  onTap: () => _bloc.add(const EmailSignIn()),
                  backgroundColor: AppColor.blue,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
