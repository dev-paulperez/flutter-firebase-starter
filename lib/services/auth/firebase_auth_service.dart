import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/auth/facebook/facebook_auth_service.dart';
import 'package:firebasestarter/services/auth/google/googe_auth_service.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInMethods { email, anonymous, google, facebook, apple }

class FirebaseAuthService implements AuthService {
  final Auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final GoogleAuthService _googleAuthService;
  final FacebookAuthService _facebookAuthService;
  SignInMethods _signInMethod;

  FirebaseAuthService(
    Auth.FirebaseAuth this._firebaseAuth, [
    GoogleSignIn this._googleSignIn,
    this._googleAuthService = const GoogleAuthService(),
    FacebookLogin this._facebookLogin,
    this._facebookAuthService = const FacebookAuthService(),
  ]) {}

  User _mapFirebaseUser(Auth.User user) {
    if (user == null) {
      return null;
    }
    var splittedName = ['Name ', 'LastName'];
    if (user.displayName != null) {
      splittedName = user.displayName.split(' ');
    }
    final map = <String, dynamic>{
      'id': user.uid ?? '',
      'firstName': splittedName.first ?? '',
      'lastName': splittedName.last ?? '',
      'email': user.email ?? '',
      'emailVerified': user.emailVerified ?? false,
      'imageUrl': user.photoURL ?? '',
      'isAnonymous': user.isAnonymous,
      'age': 0,
      'phoneNumber': '',
      'address': '',
    };
    return User.fromJson(map);
  }

  @override
  Stream<User> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<User> currentUser() async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    _signInMethod = SignInMethods.anonymous;
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _signInMethod = SignInMethods.email;
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    String name,
    String lastName,
    String email,
    String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user.updateProfile(
        displayName: name + ' ' + lastName,
      );
      await userCredential.user.reload();
      _signInMethod = SignInMethods.email;
      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final signInMethod = _googleSignIn ?? GoogleSignIn();
      final googleUser = await _googleAuthService.getGoogleUser(signInMethod);
      final googleAuth = await _googleAuthService.getGoogleAuth(googleUser);
      if (googleAuth != null) {
        final googleCredential = _googleAuthService.getUserCredentials(
            googleAuth.accessToken, googleAuth.idToken);

        final userCredential =
            await _firebaseAuth.signInWithCredential(googleCredential);
        _signInMethod = SignInMethods.google;
        return _mapFirebaseUser(userCredential.user);
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final signInMethod = _facebookLogin ?? FacebookLogin();
    final response = await _facebookAuthService.signIn(signInMethod);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken.token;
        final userCredential = await _firebaseAuth.signInWithCredential(
          _facebookAuthService.createFirebaseCredential(accessToken),
        );
        _signInMethod = SignInMethods.facebook;
        return _mapFirebaseUser(userCredential.user);
      case FacebookLoginStatus.cancel:
        return null;
      case FacebookLoginStatus.error:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithApple({List<Scope> scopes}) async {
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = Auth.OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        _signInMethod = SignInMethods.apple;
        return _mapFirebaseUser(firebaseUser);
      case AuthorizationStatus.error:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        return null;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    switch (_signInMethod) {
      case SignInMethods.anonymous:
      case SignInMethods.apple:
      case SignInMethods.email:
        break;
      case SignInMethods.facebook:
        final facebookLogin = FacebookLogin();
        await facebookLogin.logOut();
        break;
      case SignInMethods.google:
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        break;
    }
    _firebaseAuth.signOut();
    _signInMethod = null;
    return;
  }

  @override
  Future<bool> changeProfile(
      {String firstName, String lastName, String photoURL}) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.updateProfile(
          displayName: '$firstName $lastName', photoURL: photoURL);
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }
}
