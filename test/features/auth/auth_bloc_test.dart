import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growops_go/core/errors/failures.dart';
import 'package:growops_go/features/auth/domain/entities/user.dart';
import 'package:growops_go/features/auth/domain/repositories/auth_repository.dart';
import 'package:growops_go/features/auth/domain/usecases/login_user.dart';
import 'package:growops_go/features/auth/domain/usecases/login_with_google.dart';
import 'package:growops_go/features/auth/domain/usecases/logout_user.dart';
import 'package:growops_go/features/auth/domain/usecases/request_password_reset.dart';
import 'package:growops_go/features/auth/domain/usecases/sign_up_user.dart';
import 'package:growops_go/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:growops_go/features/auth/presentation/bloc/auth_event.dart';
import 'package:growops_go/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late AuthBloc bloc;

  const user = User(
    id: '1',
    email: 'demo@growops.app',
    name: 'Demo Grower',
    workspace: 'Demo Farm',
  );

  setUp(() {
    repository = _MockAuthRepository();
    bloc = AuthBloc(
      loginUser: LoginUser(repository),
      signUpUser: SignUpUser(repository),
      loginWithGoogle: LoginWithGoogle(repository),
      logoutUser: LogoutUser(repository),
      requestPasswordReset: RequestPasswordReset(repository),
    );
  });

  tearDown(() => bloc.close());

  test('initial state is unauthenticated', () {
    expect(bloc.state, const AuthUnauthenticated());
  });

  blocTest<AuthBloc, AuthState>(
    'emits authenticated on successful login',
    build: () {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);
      return bloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(email: 'demo@growops.app', password: 'demo1234'),
    ),
    expect: () => [
      const AuthLoading(),
      const AuthAuthenticated(user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure on invalid login',
    build: () {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthInvalidCredentialsFailure());
      return bloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(email: 'bad', password: ''),
    ),
    expect: () => [
      const AuthLoading(),
      const AuthFailureState(AuthInvalidCredentialsFailure()),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated on logout',
    build: () {
      when(() => repository.logout()).thenAnswer((_) async {});
      return bloc;
    },
    seed: () => const AuthAuthenticated(user),
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits password reset sent on success',
    build: () {
      when(
        () => repository.requestPasswordReset(email: any(named: 'email')),
      ).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(
      const PasswordResetRequested(email: 'demo@growops.app'),
    ),
    expect: () => [
      const AuthLoading(),
      const AuthPasswordResetSent(),
    ],
  );
}
