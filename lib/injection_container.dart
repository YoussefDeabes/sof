import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:sof/core/util/bloc/internet_connection_bloc/repository/network_info.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register Connectivity
  locator.registerLazySingleton<Connectivity>(() => Connectivity());

  // Register NetworkInfoRepository
  locator.registerLazySingleton<AbstractNetworkInfo>(
    () => NetworkInfoRepository(connectivity: locator<Connectivity>()),
  );
}
