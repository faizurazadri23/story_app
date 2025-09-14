import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../../provider/password_visibility_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _StateRegister();
}

class _StateRegister extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = context.watch<PasswordVisibilityProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Buat Akun')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Full Name',
                          hintText: 'Enter your name',
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: context.watch<AuthProvider>().isLoadingRegister
                          ? null
                          :  () async {
                        if (_formKey.currentState!.validate()) {
                         final success = await context.read<AuthProvider>().register(
                            _fullNameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (!context.mounted) return;
                          final msg =
                              context.read<AuthProvider>().registerMessage ??
                              "";
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(msg)));

                          if(success){
                            context.go("/login");
                          }
                        }
                      },
                      child: context.watch<AuthProvider>().isLoadingRegister
                          ? const Center(child: CircularProgressIndicator())
                          :  Text(
                        'Register',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
