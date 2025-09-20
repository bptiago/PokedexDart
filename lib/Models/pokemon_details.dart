class PokemonDetails {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final int height;
  final int weight;

  PokemonDetails({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.height,
    required this.weight,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    // Extrai os tipos do JSON
    var typesList = (json['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    // Extrai as habilidades do JSON
    var abilitiesList = (json['abilities'] as List)
        .map((abilityInfo) => abilityInfo['ability']['name'] as String)
        .toList();

    // Obtém a URL da artwork oficial
    String imageUrl =
        json['sprites']['other']['official-artwork']['front_default'];

    return PokemonDetails(
      id: json['id'],
      name: json['name'],
      imageUrl: imageUrl,
      types: typesList,
      abilities: abilitiesList,
      height: json['height'],
      weight: json['weight'],
    );
  }
}
