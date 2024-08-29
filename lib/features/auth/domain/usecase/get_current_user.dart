import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/auth/domain/entity/yepp_user.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUser implements UseCase<YeppUser, NoParams> {
  final AuthRepository authRepository;

  GetCurrentUser(this.authRepository);

  @override
  Future<Either<Failure, YeppUser>> call(NoParams params) async{
    return await authRepository.getCurrentUser();

  }

}
