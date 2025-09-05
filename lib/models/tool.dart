class Tool {
  final String id;
  final String name;
  final String image; // asset path or network
  final String category;
  final String description;
  final double pricePerDay;
  final String location;

  const Tool({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.pricePerDay,
    required this.location,
  });
}
