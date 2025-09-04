import 'package:flutter/cupertino.dart';
import 'package:story_app/db/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  bool isLoadingLogin = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool isLoadingLogout = false;
  bool isSplashDone = false;
  String? _registerMessage;
  String? _loginMessage;

  String? get registerMessage => _registerMessage;
  String? get loginMessage => _loginMessage;

  AuthProvider(this.authRepository);

  Future<void> finishSplash()async{
    isSplashDone = true;
    notifyListeners();
  }

  Future<void> checkLogin() async{
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if(logout){
      await authRepository.deleteUser();
    }

    isLoggedIn = await authRepository.isLoggedIn();


    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> register(String name, String email, String password) async{
    isLoadingRegister = true;
    _registerMessage = null;
    notifyListeners();

    var result = await authRepository.register(name, email, password);

    isLoadingRegister = false;
    _registerMessage = result.message;
    notifyListeners();

    return !result.error;
  }

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    _loginMessage = null;
    notifyListeners();

    final result = await authRepository.login(email, password);
    isLoadingLogin = false;
    _loginMessage = result.message;
    if(!result.error){
      await authRepository.saveLogin(result.loginResult!);
      isLoggedIn = true;
    }
    notifyListeners();
    return !result.error;
  }

}
