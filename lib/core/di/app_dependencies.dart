import 'package:get_it/get_it.dart';
import '../network/network_client.dart';
import '../../features/game/data/di/game_di.dart';

final getIt = GetIt.instance;

/// Initialize all app dependencies
Future<void> setupAppDependencies() async {
  // Register core dependencies
  getIt.registerLazySingleton<NetworkClient>(() => NetworkClient());

  // Register feature dependencies
  await setupGameDependencies();
}

