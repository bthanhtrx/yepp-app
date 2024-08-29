import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, YeppUser>> yeppLogin({required String email, required String password});
  Future<Either<Failure, YeppUser>> yeppSignUp({String? name, required String email, required String password});
  Future<Either<Failure, void>> yeppSignOut();
  Future<Either<Failure, YeppUser>> getCurrentUser();
}