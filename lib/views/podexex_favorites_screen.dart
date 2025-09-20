import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedexdart/provider/pokemon_favorites.dart';
import 'package:pokedexdart/views/pokedex_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa o Consumer para obter a lista de favoritos e reconstruir a tela
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(
              child: Text('Você ainda não tem Pokémon favoritos.'),
            );
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final pokemon = provider.favorites[index];
              return ListTile(
                leading: Image.network(pokemon.imageUrl, width: 50, height: 50),
                title: Text(
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PokemonDetailScreen(pokemon: pokemon),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
