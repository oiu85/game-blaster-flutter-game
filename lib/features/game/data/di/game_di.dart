import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/game_repository.dart';
import '../repositories/game_repository_impl.dart';

/// Setup game feature dependencies
Future<void> setupGameDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  
  GetIt.instance.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  GetIt.instance.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(GetIt.instance<SharedPreferences>()),
  );
}

