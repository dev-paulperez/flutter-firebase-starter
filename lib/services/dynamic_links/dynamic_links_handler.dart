import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/dynamic_links/email_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum EmailLinkErrorType {
  linkError,
  isNotSignInWithEmailLink,
  emailNotSet,
  signInFailed,
  userAlreadySignedIn,
}

/// Checks incoming dynamic links and uses them to sign in the user with Firebase
class FirebaseEmailLinkHandler {
  FirebaseEmailLinkHandler({
    @required this.auth,
    @required this.emailStore,
    @required this.firebaseDynamicLinks,
  });
  final AuthService auth;
  final EmailSecureStore emailStore;
  final FirebaseDynamicLinks firebaseDynamicLinks;

  Future<void> init() async {
    try {
      // Listen to incoming links when the app is open
      firebaseDynamicLinks.onLink(
        onSuccess: (linkData) => _processDynamicLink(linkData?.link),
      );

      // Check dynamic link once on app startup.
      // This is required to process any dynamic links that are opened when the app was closed
      final linkData = await firebaseDynamicLinks.getInitialLink();
      final link = linkData?.link?.toString();
      if (link != null) {
        await _processDynamicLink(linkData?.link);
      }
    } on PlatformException catch (e) {
      throw (e);
    }
  }

  /// Clients can listen to this stream and show a loading indicator while sign in is in progress
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<String> getEmail() => emailStore.getEmail();

  void dispose() {
    isLoading.dispose();
  }

  Future<void> _processDynamicLink(Uri deepLink) async {
    if (deepLink != null) {
      await _signInWithEmail(deepLink.toString());
    }
  }

  Future<void> _signInWithEmail(String link) async {
    try {
      isLoading.value = true;
      // check that user is not signed in
      final user = await auth.currentUser();
      if (user != null) {
        return;
      }
      // check that email is set
      final email = await emailStore.getEmail();
      if (email == null) {
        return;
      }
      // sign in
      if (auth.isSignInWithEmailLink(link)) {
        await auth.signInWithEmailAndLink(email: email, link: link);
      }
    } on PlatformException catch (e) {
      throw (e);
    } finally {
      isLoading.value = false;
    }
  }

  // sign in
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String packageName,
    @required bool androidInstallApp,
    @required String androidMinimumVersion,
  }) async {
    try {
      isLoading.value = true;
      // Save to email store
      await emailStore.setEmail(email);
      // Send link
      await auth.sendSignInWithEmailLink(
        email: email,
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleId: packageName,
        androidPackageName: packageName,
        androidInstallApp: androidInstallApp,
        androidMinimumVersion: androidMinimumVersion,
      );
    } on PlatformException catch (_) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
