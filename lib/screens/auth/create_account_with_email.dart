import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class CreateAccountWithEmailScreen extends StatefulWidget {
  @override
  _CreateAccountWithEmailScreenState createState() =>
      _CreateAccountWithEmailScreenState();
}

class _CreateAccountWithEmailScreenState
    extends State<CreateAccountWithEmailScreen> {
  FirebaseEmailLinkHandler _emailLinkHandler;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendEmail() async {
    final packageInfo = await PackageInfo.fromPlatform();
    await _emailLinkHandler.sendSignInWithEmailLink(
      email: _controller.text,
      url: Strings.authorizedDomain,
      handleCodeInApp: true,
      packageName: packageInfo.packageName,
      androidInstallApp: true,
      androidMinimumVersion: '21',
    );
  }

  Widget _body() {
    _controller = TextEditingController();
    return Column(
      children: [
        const Text('EMAIL'),
        TextField(controller: _controller),
        RaisedButton(
          onPressed: sendEmail,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _emailLinkHandler =
        Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).createAccount),
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(),
    );
  }
}
