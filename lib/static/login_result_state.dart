import '../data/model/login_result.dart';

sealed class LoginResultState {}

class LoginNoneState extends LoginResultState {}

class LoginLoadingState extends LoginResultState {}

class LoginErrorState extends LoginResultState {
  final String error;

  LoginErrorState(this.error);
}

class LoginLoadedState extends LoginResultState {
  final LoginResult loginResult;

  LoginLoadedState(this.loginResult);
}
