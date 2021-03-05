import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_handler.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class LogInWithEmailScreen extends StatefulWidget {
  @override
  _LogInWithEmailScreenState createState() => _LogInWithEmailScreenState();
}

class _LogInWithEmailScreenState extends State<LogInWithEmailScreen> {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Text(Strings.submitYourEmail),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: Strings.email),
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              onTap: sendEmail,
              text: Strings.sendActivationLink,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _emailLinkHandler =
        Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.emailSignIn),
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(),
    );
  }
}
