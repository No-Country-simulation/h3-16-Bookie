class CountryProvince{
  final int id;
  final String name;
  final List<Province> provinces;

  CountryProvince({
    required this.id,
    required this.name,
    required this.provinces,
  });
}

class Province{
  final int id;
  final String name;

  Province({
    required this.id,
    required this.name,
  });
}

class Country{
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });
}

