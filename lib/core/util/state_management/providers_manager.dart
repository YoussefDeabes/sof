import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sof/core/util/bloc/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:sof/core/util/bloc/internet_connection_bloc/repository/network_info.dart';
import 'package:sof/core/util/bloc/language/language_cubit.dart';
import 'package:sof/core/util/bloc/theme/theme_cubit.dart';
import 'package:sof/features/users/presentation/bloc/users_bloc.dart';
import 'package:sof/injection_container.dart';

class ProviderManager {
  static List<SingleChildWidget> providers = [
    BlocProvider<InternetConnectionBloc>(
      create: (BuildContext context) => InternetConnectionBloc(
        connectionCheck: locator<AbstractNetworkInfo>(),
      ),
    ),
    BlocProvider<ThemeCubit>(
      create: (BuildContext context) => ThemeCubit(),
    ),
    BlocProvider<LanguageCubit>(
      create: (BuildContext context) => LanguageCubit(),
    ),
    BlocProvider<UsersBloc>(
      create: (BuildContext context) => UsersBloc(),
    ),
  ];
}

