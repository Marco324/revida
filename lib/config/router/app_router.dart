
import 'package:go_router/go_router.dart';
import 'package:revida/features/pages/presentation/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),
    ),


  ]
);