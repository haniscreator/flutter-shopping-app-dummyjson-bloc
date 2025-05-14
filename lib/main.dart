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
import 'blocs/category/category_bloc.dart'; // ✅ Add this
import 'blocs/category/category_event.dart'; // ✅ Add this if using LoadCategories


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
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(
          create: (_) => CategoryBloc(repository: repository)..add(LoadCategories()),

        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
