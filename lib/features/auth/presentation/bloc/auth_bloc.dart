import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/features/auth/data/model/yepp_user_model.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';
import 'package:yepp/features/auth/domain/usecase/get_current_user.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_login.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signout.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signup.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final YeppSignup _yeppSignup;
  final YeppLogin _yeppLogin;
  final YeppSignout _yeppSignout;
  final GetCurrentUser _getCurrentUser;

  // final FirebaseAuth _firebaseAuth;

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    print('onTransition: ${transition.currentState} ${transition.nextState}');
  }

  AuthBloc(
      {required YeppSignup yeppSignUp,
      required YeppLogin yeppLogin,
      required YeppSignout yeppSignout,
      required GetCurrentUser getCurrentUser})
      : _yeppSignup = yeppSignUp,
        _yeppLogin = yeppLogin,
        _yeppSignout = yeppSignout,
        _getCurrentUser = getCurrentUser,
        super(AuthInitial()) {
    // on<AuthUserChanged>((event, emit) {
    //   if (event.user != null) {
    //     emit(AuthAuthenticated(event.user!));
    //   } else {
    //     emit(AuthUnauthenticated());
    //   }
    // });

    on<LoginUserEvent>(
      (event, emit) async {
        emit(AuthLoading());

        final res = await _yeppLogin(
            LoginParams(email: event.email, password: event.password));
        res.fold(
          (l) => emit(AuthError(l.message)),
          (r) => emit(AuthAuthenticated(r)),
        );
      },
    );

    on<SignUpUserEvent>(
      (event, emit) async {
        emit(AuthLoading());

        final res = await _yeppSignup(
            SignUpParams(name: event.userName, email: event.email, password: event.password));
        res.fold((l) => emit(AuthError(l.message)),
            (r) => emit(AuthAuthenticated(r)));
      },
    );

    on<SignOutEvent>(
      (event, emit) async {
        emit(AuthLoading());
        final res = await _yeppSignout(NoParams());
        res.fold(
          (l) => emit(AuthError(l.message)),
          (r) => emit(AuthUnauthenticated()),
        );
      },
    );

    on<GetCurrentUserEvent>(
      (event, emit) async{
        emit(AuthLoading());
        final res = await _getCurrentUser(NoParams());
        res.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthAuthenticated(r)),);
      },
    );

    // _firebaseAuth.authStateChanges().listen((user) {
    //   add(AuthUserChanged(user));
    // });
  }
}
