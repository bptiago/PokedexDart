import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedexdart/models/pokemon_details.dart';
import 'package:pokedexdart/models/pokemon_listed.dart';
import 'package:pokedexdart/provider/pokemon_favorites.dart';
import 'package:pokedexdart/services/pokemon_service.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
        actions: [
          // O Consumer reconstrói apenas o ícone quando o estado de favoritos muda.
          Consumer<FavoritesProvider>(
            builder: (context, provider, child) {
              final isFavorite = provider.isFavorite(pokemon);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.white,
                ),
                onPressed: () {
                  provider.toggleFavorite(pokemon);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<PokemonDetails>(
        future: PokemonService().fetchPokemonDetails(pokemon.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar detalhes: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final details = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(details.imageUrl, height: 250),
                  const SizedBox(height: 20),
                  Text(
                    '#${details.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailCard(
                    context,
                    'Tipos',
                    Wrap(
                      spacing: 8.0,
                      children: details.types
                          .map((type) => Chip(label: Text(type)))
                          .toList(),
                    ),
                  ),
                  _buildDetailCard(
                    context,
                    'Habilidades',
                    Text(details.abilities.join(', ')),
                  ),
                  _buildDetailCard(
                    context,
                    'Altura',
                    Text('${details.height / 10} m'),
                  ),
                  _buildDetailCard(
                    context,
                    'Peso',
                    Text('${details.weight / 10} kg'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Nenhum dado disponível.'));
        },
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, Widget content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: content,
        ),
      ),
    );
  }
}
