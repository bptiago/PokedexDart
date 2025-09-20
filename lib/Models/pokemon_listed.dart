class Pokemon {
  final String name;
  final String url; // URL para buscar os detalhes completos

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  // Extrai o ID do Pokémon a partir da URL de detalhes.
  String get id => url.split('/')[6];

  // URL da imagem (sprite) oficial do Pokémon.
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
