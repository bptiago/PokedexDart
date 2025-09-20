import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedexdart/models/pokemon_details.dart';
import 'package:pokedexdart/models/pokemon_listed.dart';

const String baseUrl = 'https://pokeapi.co/api/v2';

class PokemonService {
  Future<List<Pokemon>> fetchPokemons({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => Pokemon.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar a lista de Pokémon');
    }
  }

  Future<PokemonDetails> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do Pokémon');
    }
  }

  Future<PokemonDetails> searchPokemon(String nameOrId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon/${nameOrId.toLowerCase()}'),
    );

    if (response.statusCode == 200) {
      return PokemonDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Pokémon não encontrado');
    }
  }
}
