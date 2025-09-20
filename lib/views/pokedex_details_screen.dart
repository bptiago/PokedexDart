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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<FavoritesProvider>(
              builder: (context, provider, child) {
                final isFavorite = provider.isFavorite(pokemon);

                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.star,
                    color: isFavorite ? Colors.amber : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(pokemon);
                  },
                );
              },
            ),
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
                    'Tipos',
                    Wrap(
                      spacing: 8.0,
                      children: details.types
                          .map((type) => Chip(label: Text(type)))
                          .toList(),
                    ),
                  ),
                  _buildDetailCard(
                    'Habilidades',
                    Text(details.abilities.join(', ')),
                  ),
                  // Novo Card para os Status Base
                  _buildStatsCard(details.stats),
                  _buildDetailCard(
                    'Altura',
                    Text('${details.height / 10} m'),
                  ),
                  _buildDetailCard(
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

  Widget _buildDetailCard(String title, Widget content) {
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

  Widget _buildStatsCard(List<Stat> stats) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status Base',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...stats.map((stat) {
              const double maxStatValue = 180.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(stat.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(stat.baseStat.toString()),
                    ),
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          value: stat.baseStat / maxStatValue,
                          minHeight: 12,
                          backgroundColor: Colors.grey[300],
                          color: stat.baseStat > 90
                              ? Colors.green
                              : stat.baseStat > 50
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}