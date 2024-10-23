import 'package:flutter/material.dart';
import 'services/movie_service.dart';

void main() {
  runApp(MovieSearchApp());
}

class MovieSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primaryColor: const Color(0xFF5EC570), // Green color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF5EC570), // Green as primary color
          secondary: const Color(0xFF1C7EEB), // Blue for highlights and buttons
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White background
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600, // Semi Bold
            fontSize: 16,
            color: Color(0xFF212121), // Dark Gray for main text
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 14,
            color: Color(0xFF262e2e), // Blackish for secondary text
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C7EEB), // Blue color for AppBar
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF2F2F2), // Light gray background for text field
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFFAAAAAA), // Light gray for placeholder text
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: Color(0xFF262e2e), // Blackish for icons
        ),
      ),
      home: MovieSearchPage(),
    );
  }
}

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  TextEditingController _searchController = TextEditingController();
  MovieService _movieService = MovieService();
  List<dynamic> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Method to fetch movies from the API
  void _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _movies = [];
    });

    try {
      final movies = await _movieService.searchMovies(query);
      setState(() {
        _movies = movies;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (query) {
                _searchMovies(query); // Trigger search on submit
              },
            ),
            const SizedBox(height: 25),

            // Movie List or Loading/Error Message
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : ListView.builder(
                          itemCount: _movies.length,
                          itemBuilder: (context, index) {
                            final movie = _movies[index];
                            return MovieItemCard(movie: movie);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieItemCard extends StatelessWidget {
  final dynamic movie;

  const MovieItemCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Movie Poster
            movie['Poster'] != 'N/A'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      movie['Poster'],
                      height: 150,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 100,
                    width: 70,
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.movie, size: 50, color: Colors.grey),
                  ),
            const SizedBox(width: 16),

            // Movie Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['Title'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Year: ${movie['Year']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'IMDB: 7.5',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFBC02D), size: 16),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
