abstract class EmailSignInState {
  const EmailSignInState();
}

class EmailSent extends EmailSignInState {
  const EmailSent();
}

class NotDetermined extends EmailSignInState {
  const NotDetermined();
}

class Error extends EmailSignInState {
  final String message;
  const Error(this.message);
}

class Loading extends EmailSignInState {
  const Loading();
}
