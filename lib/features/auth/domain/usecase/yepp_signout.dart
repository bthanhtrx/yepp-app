import 'package:fpdart/src/either.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';

class YeppSignout implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  YeppSignout(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.yeppSignOut();
  }

}
