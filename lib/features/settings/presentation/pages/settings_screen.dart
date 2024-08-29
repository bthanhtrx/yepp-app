import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:yepp/core/common/cubit/theme_cubit.dart';
import 'package:yepp/core/theme/theme.dart';
import 'package:yepp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yepp/features/auth/presentation/pages/auth_screen.dart';
import 'package:yepp/init_dependencies.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final firebaseAuth = sl<FirebaseAuth>();

  bool isDarkMode = false;

  Future<void> toggleTheme(value) async {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    await context.read<ThemeCubit>().changeTheme(isDarkMode: isDarkMode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, state) {
              isDarkMode = state == AppTheme.darkThemeMode;
              return ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark Mode'),
                trailing: Switch(value: isDarkMode, onChanged: toggleTheme),
              );
            },
          ),
          /*StreamBuilder(
                stream: firebaseAuth.authStateChanges(),
                builder: (context, snapshot) => snapshot.data == null
                    ? TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => AuthScreen(),
                              constraints:
                                  BoxConstraints(maxHeight: screenHeight * .8),
                              showDragHandle: true,
                              isDismissible: true,
                              isScrollControlled: true).then((value) {

                              // if(value) {
                              //   context.pushNamed(PathRouteConstant.homeNavigationRoute);
                              // }

                          },);
                        },
                        child: Text('Sign In To Save Data Across Devices'))
                    : TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: () {
                          firebaseAuth.signOut();
                        },
                        child: Text(
                            'You are logged in as: ${firebaseAuth.currentUser!.displayName ?? 'no_name'} - Logout?'))),*/

          const Gap(20),
          // BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          //   if (state is AuthUnauthenticated) {
          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //         content: Text(
          //             'You\'ve Signed Out')));
          //   }
          // }, builder: (context, state) {}),
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                      child: Text(
                          'You are logged in as: ${firebaseAuth.currentUser!.displayName ?? 'no_name'} - Logout?'));
                }

                // if(state is AuthLoading) {
                //   return CircularProgressIndicator();
                // }
                //
                // if(state is AuthError) {
                //   return Text('Error: ${state.message}', style: TextStyle(color: Colors.red),);
                // }

                return TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
                    onPressed: () {
                      showModalBottomSheet(
                              context: context,
                              builder: (context) => const AuthScreen(),
                              constraints:
                                  BoxConstraints(maxHeight: screenHeight * .8),
                              showDragHandle: true,
                              isDismissible: true,
                              isScrollControlled: true)
                          .then(
                        (value) {
                          // if(value) {
                          //   context.pushNamed(PathRouteConstant.homeNavigationRoute);
                          // }
                        },
                      );
                    },
                    child: const Text('Sign In To Save Data Across Devices'));
              }),
        ]),
      ),
    );
  }
}
