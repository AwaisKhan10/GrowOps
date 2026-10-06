import 'package:get_it/get_it.dart';

import '../../app_state.dart';
import '../../features/auth/data/datasources/demo_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/login_with_google.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/request_password_reset.dart';
import '../../features/auth/domain/usecases/sign_up_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../network/growops_api_client.dart';

final getIt = GetIt.instance;

/// Registers application dependencies.
Future<void> configureDependencies() async {
  if (getIt.isRegistered<AppState>()) return;

  // Legacy global state — removed after full migration.
  getIt.registerLazySingleton<AppState>(AppState.new);

  // Core
  getIt.registerLazySingleton<GrowOpsApiClient>(
    () => GrowOpsApiClient(baseUrl: GrowOpsApiClient.defaultBaseUrl),
  );

  _registerAuth();
}

void _registerAuth() {
  getIt.registerLazySingleton<DemoAuthDataSource>(DemoAuthDataSource.new);
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<DemoAuthDataSource>()),
  );

  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => RequestPasswordReset(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => AuthBloc(
      loginUser: getIt<LoginUser>(),
      signUpUser: getIt<SignUpUser>(),
      loginWithGoogle: getIt<LoginWithGoogle>(),
      logoutUser: getIt<LogoutUser>(),
      requestPasswordReset: getIt<RequestPasswordReset>(),
    ),
  );
}
