import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sof/core/util/bloc/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:sof/core/util/bloc/language/language_cubit.dart';
import 'package:sof/core/util/bloc/theme/theme_cubit.dart';
import 'package:sof/core/util/helpers/route_manager.dart';
import 'package:sof/core/util/lang/app_localization.dart';
import 'package:sof/core/util/state_management/providers_manager.dart';
import 'package:sof/core/util/theme/app_theme.dart';
import 'package:sof/core/widgets/no_internet_screen.dart';
import 'package:sof/features/splash/presentation/pages/screens/splash_screen.dart';
import 'package:sof/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage for state persistence
  final tempDir = await getTemporaryDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(tempDir.path),
  );

  // Setup dependency injection
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 810),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: ProviderManager.providers,
          child: BlocBuilder<InternetConnectionBloc, InternetConnectionState>(
            builder: (context, connectivityState) {
              // Show NoInternetScreen when disconnected
              if (!connectivityState.isConnected) {
                return BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, localeState) {
                    ScreenUtil.configure(data: MediaQuery.of(context));
                    return BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: AppTheme(localeState).themeDataLight,
                          darkTheme: AppTheme(localeState).themeDataDark,
                          themeMode: themeMode,
                          supportedLocales: AppLocalizations.supportLocales,
                          localizationsDelegates: const [
                            AppLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          localeResolutionCallback:
                              AppLocalizations.localeResolutionCallback,
                          locale: localeState,
                          home: const NoInternetScreen(),
                        );
                      },
                    );
                  },
                );
              }

              // Show normal app when connected
              return BlocBuilder<LanguageCubit, Locale>(
                builder: (context, localeState) {
                  ScreenUtil.configure(data: MediaQuery.of(context));
                  return BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      return MaterialApp(
                        navigatorKey: navigatorKey,
                        title: 'StackOverflow Users',
                        debugShowCheckedModeBanner: false,
                        theme: AppTheme(localeState).themeDataLight,
                        darkTheme: AppTheme(localeState).themeDataDark,
                        themeMode: themeMode,
                        supportedLocales: AppLocalizations.supportLocales,
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        localeResolutionCallback:
                            AppLocalizations.localeResolutionCallback,
                        locale: localeState,
                        home: const SplashScreen(),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
