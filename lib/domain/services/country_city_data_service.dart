import 'dart:convert';
import 'package:flutter/services.dart';

class Country {
  final String name;
  final List<String> cities;

  Country({
    required this.name,
    required this.cities,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? '',
      cities: (json['cities'] as List<dynamic>?)
          ?.map((city) => city.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cities': cities,
    };
  }
}

class City {
  final String name;

  City({
    required this.name,
  });

  factory City.fromString(String cityName) {
    return City(name: cityName);
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class CountryCityDataService {
  static List<Country> _countries = [];
  static bool _isLoaded = false;

  static Future<List<Country>> getCountries() async {
    if (!_isLoaded) {
      await _loadData();
    }
    return _countries;
  }

  static Future<List<City>> getCitiesForCountry(String countryName) async {
    if (!_isLoaded) {
      await _loadData();
    }

    final country = _countries.firstWhere(
      (c) => c.name.toLowerCase() == countryName.toLowerCase(),
      orElse: () => _countries.first,
    );

    // Remove duplicates by converting to Set and back to List
    final uniqueCityNames = country.cities.toSet().toList();

    // Sort alphabetically for better UX
    uniqueCityNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return uniqueCityNames.map((cityName) => City.fromString(cityName)).toList();
  }

  static Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/countries_cities.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _countries = jsonList.map((json) => Country.fromJson(json)).toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading country data: $e');
      _countries = [];
      _isLoaded = true;
    }
  }
}
