import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'blocs/product/product_bloc.dart';
import 'repositories/product_repository.dart';
import 'screens/product_list_screen.dart';
import 'blocs/product/product_event.dart';
import 'blocs/favorites/favorites_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;

  final repository = ProductRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(repository)..add(LoadInitialProducts()),
        ),
        BlocProvider(create: (_) => FavoritesBloc()),
      ],
      child: MyApp(repository: repository), // 🔧 Pass repository here
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ProductBloc(repository)..add(LoadInitialProducts()),
        child: const ProductListScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
