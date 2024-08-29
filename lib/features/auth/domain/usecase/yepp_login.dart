import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';

class YeppLogin implements UseCase<YeppUser, LoginParams> {
  final AuthRepository authRepository;

  YeppLogin(this.authRepository);

  @override
  Future<Either<Failure, YeppUser>> call(LoginParams params) {
    return authRepository.yeppLogin(email: params.email, password: params.password);
  }

}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});

}