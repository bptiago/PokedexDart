import 'package:flutter/material.dart';
import 'package:pokedexdart/models/pokemon_listed.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Pokemon> _favorites = [];

  List<Pokemon> get favorites => _favorites;

  void toggleFavorite(Pokemon pokemon) {
    if (isFavorite(pokemon)) {
      _favorites.removeWhere((p) => p.name == pokemon.name);
    } else {
      _favorites.add(pokemon);
    }
    // Notifica os widgets que estão ouvindo sobre a mudança.
    notifyListeners();
  }

  bool isFavorite(Pokemon pokemon) {
    return _favorites.any((p) => p.name == pokemon.name);
  }
}
