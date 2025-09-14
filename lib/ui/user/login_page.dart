import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/static/login_result_state.dart';

import '../../provider/password_visibility_provider.dart';

class LoginPage extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginPage({super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginPage> createState() => _StateLogin();
}

class _StateLogin extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = context.watch<PasswordVisibilityProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_app.png',
                  width: 125,
                  height: 125,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !passwordProvider.isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<PasswordVisibilityProvider>()
                                  .toggle();
                            },
                            icon: Icon(
                              passwordProvider.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final provider  = context.read<AuthProvider>();

                            await provider
                                .login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            final state = provider.resultState;

                            if(state is LoginLoadingState){
                              if(context.mounted){
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                  const Center(child: CircularProgressIndicator()),
                                );
                              }
                            }else{
                              if (state is LoginLoadedState) {
                                if(context.mounted){
                                  context.go("/story");
                                }
                              } else if (state is LoginErrorState) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(state.error)));
                                }
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: widget.onRegister,
                            child: Text('Register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
