import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../constants/strings.dart';

class DynamicLinkService {
  Future<bool> handleDynamicLinks(BuildContext context, bool openedApp) async {
    //Get initial dynamic link if the app is started using the link
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;
    if (deepLink != null && openedApp) {
      _handleDeepLink(data, context);
      return true;
    }
    //Into foreground from dynamic link logic
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        _handleDeepLink(dynamicLinkData, context);
        return true;
      },
      onError: (OnLinkErrorException e) async {
        print('Dynamic Link Failed ${e.message}');
        return true;
      },
    );
    return false;
  }

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
    final deepLink = data?.link;
    //log in
    // navigate to main screen
  }

  static Future<void> _createLink(String email) async {
    final packageInfo = await PackageInfo.fromPlatform();
    // Send link
    await FirebaseAuth.instance.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: Strings.prefix,
        handleCodeInApp: true,
        androidPackageName: packageInfo.packageName,
        androidInstallApp: true,
        androidMinimumVersion: '21',
      ),
    );
  }
}
