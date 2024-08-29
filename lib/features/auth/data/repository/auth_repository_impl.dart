import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/exception.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:yepp/features/auth/data/model/yepp_user_model.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDatasourceImpl;

  AuthRepositoryImpl(this.authRemoteDatasourceImpl);

  @override
  Future<Either<Failure, YeppUserModel>> getCurrentUser() async {
    try {
      final user = await authRemoteDatasourceImpl.getCurrentUser();
      if (user == null) {
        return Either.left(Failure('User Not Logged In'));
      }
      return Either.right(user);
    } on NetworkException catch (e) {
      return Either.left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, YeppUser>> yeppLogin(
      {required String email, required String password}) async {
    try {
      final yeppLogin = await authRemoteDatasourceImpl.yeppLogin(
          email: email, password: password);
      return Either.right(yeppLogin);
    } on NetworkException catch (e) {
      return Either.left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, YeppUser>> yeppSignUp(
      {String? name, required String email, required String password}) async {
    try {
      final yeppSignUp = await authRemoteDatasourceImpl.yeppSignUp(
          name: name, email: email, password: password);
      return Either.right(yeppSignUp);
    } on NetworkException catch (e) {
      return Either.left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> yeppSignOut() async{
   try {
     return Either.right(authRemoteDatasourceImpl.yeppSignOut());
   } on NetworkException catch(e) {
     return Either.left(Failure(e.message));
   }
  }
}
