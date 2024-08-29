import 'package:fpdart/src/either.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';

class YeppSignup implements UseCase<YeppUser, SignUpParams> {
  final AuthRepository authRepository;

  YeppSignup(this.authRepository);

  @override
  Future<Either<Failure, YeppUser>> call(SignUpParams params) {
    return authRepository.yeppSignUp(
        name: params.name, email: params.email, password: params.password);
  }
}

class SignUpParams {
  String? name;
  final String email;
  final String password;

  SignUpParams({this.name, required this.email, required this.password});
}
