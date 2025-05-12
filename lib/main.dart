import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/product/product_bloc.dart';
import 'repositories/product_repository.dart';
import 'screens/product_list_screen.dart';
import 'blocs/product/product_event.dart';
import 'blocs/favorites/favorites_bloc.dart';
import 'blocs/cart/cart_bloc.dart'; // ✅ Add this import

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
        BlocProvider(create: (_) => CartBloc()), // ✅ Add CartBloc here
      ],
      child: MyApp(repository: repository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProductListScreen(), // ✅ No need to wrap again in ProductBloc
      debugShowCheckedModeBanner: false,
    );
  }
}
