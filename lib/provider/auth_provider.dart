import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/static/login_result_state.dart';
import 'package:story_app/static/register_result_state.dart';

import '../data/model/login_result.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices _apiServices;
  bool isLoadingLogin = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool isLoadingLogout = false;
  bool isSplashDone = false;
  String? _registerMessage;
  String? _loginMessage;
  LoginResult? _loginResult;

  String? get registerMessage => _registerMessage;

  String? get loginMessage => _loginMessage;

  LoginResult? get loginResult => _loginResult;

  LoginResultState _resultState = LoginNoneState();
  RegisterResultState _registerResultState = RegisterNoneState();

  LoginResultState get resultState => _resultState;

  RegisterResultState get resultRegisterState => _registerResultState;

  AuthProvider(this.authRepository, this._apiServices);

  Future<void> finishSplash() async {
    isSplashDone = true;
    notifyListeners();
  }

  Future<void> checkLogin() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    await authRepository.logout();

    isLoggedIn = false;
    isLoadingLogout = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _registerResultState = RegisterLoadingState();
      notifyListeners();

      var result = await _apiServices.register(name, email, password);

      if (result.error) {
        _registerResultState = RegisterErrorState(result.message);
        notifyListeners();
      } else {
        _registerResultState = RegisterLoadedState(result);
        notifyListeners();
      }
    } on Exception catch (e) {
      _registerResultState = RegisterErrorState(
        e.toString().replaceAll('Exception:', '').trim(),
      );
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _resultState = LoginLoadingState();
      notifyListeners();
      final result = await _apiServices.login(email, password);
      if (result.error) {
        _resultState = LoginErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = LoginLoadedState(result.loginResult);
        authRepository.saveLogin(result.loginResult);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = LoginErrorState(
        e.toString().replaceAll('Exception:', '').trim(),
      );
      notifyListeners();
    }
  }

  Future<LoginResult> getLoginResult() async {
    _loginResult = await authRepository.getUser();
    notifyListeners();
    return _loginResult!;
  }
}
