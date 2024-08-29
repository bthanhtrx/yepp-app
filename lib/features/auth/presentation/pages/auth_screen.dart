import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:yepp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yepp/init_dependencies.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _emailController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _reEnterPasswordController;

  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;

  @override
  void initState() {
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _reEnterPasswordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _isSignUp ? 'Sign Up' : 'Login',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                _isSignUp
                    ? TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      hintText: 'Username'),
                  controller: _userNameController,
                )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      hintText: 'Email'),
                  controller: _emailController,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 2),
                    ),
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 10,
                ),
                _isSignUp
                    ? TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty.';
                    }

                    if (value.trim() != _passwordController.text) {
                      return 'Password must match.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 2),
                    ),
                    hintText: 'Confirm Password',
                  ),
                  obscureText: true,
                  controller: _reEnterPasswordController,
                )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, fixedSize: Size(200, 20)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      _isSignUp
                          ? context.read<AuthBloc>().add(SignUpUserEvent(
                          userName: _userNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text))
                          : context.read<AuthBloc>().add((LoginUserEvent(
                          email: _emailController.text,
                          password: _passwordController.text)));
                      // Navigator.pop(context, true);
                    }
                  },
                  child: Text(
                    _isSignUp ? 'Sign Up' : 'Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _isSignUp
                    ? RichText(
                    text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    clearTextField();
                                    _isSignUp = !_isSignUp;
                                  });
                                })
                        ]))
                    : RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    clearTextField();
                                    _isSignUp = !_isSignUp;
                                  });
                                })
                        ])),

                Gap(20),
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                  if(state is AuthAuthenticated) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Successfully Sign In as ${FirebaseAuth.instance.currentUser!
                                .displayName}')));
                  }
                },builder: (context, state) {
                  if (state is AuthError) {
                    return Text(state.message, style: TextStyle(
                        color: Colors.red),);
                  }

                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }

                  return SizedBox.shrink();
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);


      Navigator.pop(context);
    } catch (e) {
      print('error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signUpAccount() async {
    try {
      await sl<FirebaseAuth>()
          .createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .then(
            (value) {
      Navigator.pop(context);
              return value.user!.updateDisplayName(_userNameController.text);
            },
      );

    } catch (e) {
      print('error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void clearTextField() {
    _passwordController.clear();
    _emailController.clear();
    _reEnterPasswordController.clear();
    _userNameController.clear();
  }
}
