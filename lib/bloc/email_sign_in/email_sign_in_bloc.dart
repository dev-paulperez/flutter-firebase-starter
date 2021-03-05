import 'package:firebasestarter/bloc/email_sign_in/email_sign_in_event.dart';
import 'package:firebasestarter/bloc/email_sign_in/email_sign_in_state.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_handler.dart';
import 'package:firebasestarter/bloc/forms/email_sign_in_form.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';

class EmailSignInBloc extends Bloc<EmailSignInEvent, EmailSignInState> {
  FirebaseEmailLinkHandler _emailLinkHandler;

  static const _errEvent = 'Error: Invalid event in [email_sign_in_bloc.dart]';
  static const _emailSignInErr =
      'Error: Something went wrong while trying to send email';

  final form = EmailSignInFormBloc();

  EmailSignInBloc() : super(const NotDetermined()) {
    _emailLinkHandler = GetIt.I<FirebaseEmailLinkHandler>();
  }

  @override
  Stream<EmailSignInState> mapEventToState(EmailSignInEvent event) async* {
    switch (event.runtimeType) {
      case EmailSignIn:
        yield* _emailSignIn();
        break;
      default:
        yield const Error(_errEvent);
    }
  }

  Future<void> _sendEmail(email) async {
    final packageInfo = await PackageInfo.fromPlatform();
    await _emailLinkHandler.sendSignInWithEmailLink(
      email: email,
      url: Strings.authorizedDomain,
      handleCodeInApp: true,
      packageName: packageInfo.packageName,
      androidInstallApp: true,
      androidMinimumVersion: '21',
    );
  }

  Stream<EmailSignInState> _emailSignIn() async* {
    yield const Loading();
    try {
      await _sendEmail(form.emailValue);
      yield const EmailSent();
    } catch (e) {
      yield const Error(_emailSignInErr);
    }
  }
}
