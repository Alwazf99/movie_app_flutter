import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String _baseUrl = 'http://www.omdbapi.com/';
  static const String _apiKey = '63d5a488';

  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?apikey=$_apiKey&s=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        return data['Search']; // Return list of movies
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
