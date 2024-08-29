import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yepp/core/error/exception.dart';
import 'package:yepp/features/auth/data/model/yepp_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<YeppUserModel> yeppLogin(
      {required String email, required String password});

  Future<YeppUserModel> yeppSignUp(
      {String? name, required String email, required String password});

  Future<void> yeppSignOut();

  Future<YeppUserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore) {print('registering authremotedatasource');}


  @override
  Future<YeppUserModel?> getCurrentUser() async {
    try {
      if (firebaseAuth.currentUser != null) {
        return YeppUserModel(
            userName: firebaseAuth.currentUser!.displayName!,
            email: firebaseAuth.currentUser!.email!);
      }
      return null;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<YeppUserModel> yeppLogin(
      {required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return YeppUserModel(
          userName: userCredential.user!.displayName,
          email: userCredential.user!.email!);
    } catch (e) {
      print('----------- Error: ${e.toString()}');
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<YeppUserModel> yeppSignUp(
      {String? name, required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user?.updateDisplayName(name);

      firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email});
    } catch (e) {
      throw NetworkException(e.toString());
    }

    return YeppUserModel(userName: name, email: email);
  }

  @override
  Future<void> yeppSignOut() async{
    try {
      firebaseAuth.signOut();
    } catch (e) {
      throw NetworkException(
          'There is an error during SignOut, try again later.');
    }
  }
}
