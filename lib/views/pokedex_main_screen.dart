import 'package:flutter/material.dart';
import 'package:pokedexdart/models/pokemon_listed.dart';
import 'package:pokedexdart/services/pokemon_service.dart';
import 'package:pokedexdart/views/pokedex_details_screen.dart';
import 'package:pokedexdart/views/podexex_favorites_screen.dart';
import 'package:pokedexdart/views/pokemon_grid_item.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokemonService _pokemonService = PokemonService();
  final List<Pokemon> _pokemons = [];
  final _searchController = TextEditingController();

  int _offset = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInitialPokemons();
  }

  Future<void> _fetchInitialPokemons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newPokemons = await _pokemonService.fetchPokemons(offset: _offset);
      setState(() {
        _pokemons.addAll(newPokemons);
        _offset += 20;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newPokemons = await _pokemonService.fetchPokemons(offset: _offset);
      setState(() {
        _pokemons.addAll(newPokemons);
        _offset += 20;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar mais Pokémon: $e')),
      );
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _searchPokemon() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final details = await _pokemonService.searchPokemon(query);
      final pokemon = Pokemon(
        name: details.name,
        url: '$baseUrl/pokemon/${details.id}/',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonDetailScreen(pokemon: pokemon),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Pokémon não encontrado!')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContent()),
          if (!_isLoading) _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome ou número',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onSubmitted: (_) => _searchPokemon(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _searchPokemon,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  /// constrói o conteúdo principal (indicador de progresso, erro ou a grade de Pokémon).
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Erro: $_errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchInitialPokemons,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colunas
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0, // Itens quadrados
      ),
      itemCount: _pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = _pokemons[index];
        return PokemonGridItem(pokemon: pokemon);
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoadingMore
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _loadMore,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Carregar Mais'),
            ),
    );
  }
}
