import 'package:firebasestarter/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class EmailSignInFormBloc with ValidationMixin {
  final _emailController = BehaviorSubject<String>.seeded('');

  EmailSignInFormBloc();

  Stream<String> get email => _emailController.transform(emailTransfomer);

  Function(void) get onEmailChanged => _emailController.sink.add;

  String get emailValue => _emailController.value;
}
