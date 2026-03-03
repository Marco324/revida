import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revida/config/config.dart';
import 'package:revida/config/router/app_router.dart';
import 'package:revida/features/auth/infrastructure/datasources/auth_datasource_impl.dart';
import 'package:revida/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:revida/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:revida/firebase_options.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final datasource = AuthDatasourceImpl();
  final repository = AuthRepositoryImpl(datasource: datasource);

  //runapp
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(authRepo: repository)..checkAuth(),
      ),
      
    ],
    child: const MyApp(),
  ));
}
