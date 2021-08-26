part of auth;

enum SocialMediaMethod { GOOGLE, FACEBOOK, APPLE }

abstract class AuthService {
  Stream<UserEntity> get onAuthStateChanged;

  Future<UserEntity> currentUser();

  Future<UserEntity> signInAnonymously();

  Future<UserEntity> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    @required String name,
    @required String lastName,
    @required String email,
    @required String password,
  });

  Future<void> sendPasswordResetEmail({@required String email});

  Future<void> sendSignInLinkToEmail({@required String email});

  Future<UserEntity> signInWithEmailLink({@required email, @required emailLink});

  bool isSignInWithEmailLink({@required String emailLink});

  Future<UserEntity> signInWithSocialMedia({
    @required SocialMediaMethod method,
  });

  Future<void> signOut();

  Future<bool> changeProfile({
    String firstName,
    String lastName,
    String photoURL,
  });

  Future<void> deleteAccount();
}