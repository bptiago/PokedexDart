import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedexdart/provider/pokemon_favorites.dart';
import 'package:pokedexdart/views/pokedex_main_screen.dart';

// TODO
// 4) DEIXAR O DESIGN MAIS BONITINHO

void main() {
  runApp(
    // ChangeNotifierProvider deixa o estado dos favoritos disponível em toda a árvore de widgets :)
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const PokedexApp(),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex Explorer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PokedexScreen(), // --> tela inicial
      debugShowCheckedModeBanner: false,
    );
  }
}
