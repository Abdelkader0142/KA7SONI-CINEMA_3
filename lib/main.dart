
import 'package:flutter/material.dart';

void main() {
  runApp(const Ka7soniCinema());
}

class Ka7soniCinema extends StatelessWidget {
  const Ka7soniCinema({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KA7SONI CINEMA',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080816),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9D4EDD),
          secondary: Color(0xFF00D9FF),
        ),
      ),
      home: const CinemaHome(),
    );
  }
}

class Movie {
  String title;
  String description;
  String image;
  String link;

  Movie({
    required this.title,
    required this.description,
    required this.image,
    required this.link,
  });
}

class CinemaHome extends StatefulWidget {
  const CinemaHome({super.key});

  @override
  State<CinemaHome> createState() => _CinemaHomeState();
}

class _CinemaHomeState extends State<CinemaHome> {
  final List<Movie> movies = [];
  final TextEditingController search = TextEditingController();

  List<Movie> get filteredMovies => movies
      .where((m) =>
          m.title.toLowerCase().contains(search.text.toLowerCase()))
      .toList();

  void addMovie() {
    final title = TextEditingController();
    final description = TextEditingController();
    final image = TextEditingController();
    final link = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF17172B),
        title: const Text('إضافة فيلم جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              field(title, 'اسم الفيلم'),
              field(image, 'رابط صورة الفيلم'),
              field(description, 'وصف الفيلم'),
              field(link, 'رابط المشاهدة'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.text.trim().isEmpty) return;
              setState(() {
                movies.add(Movie(
                  title: title.text.trim(),
                  description: description.text.trim(),
                  image: image.text.trim(),
                  link: link.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Widget field(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111126),
        title: const Text(
          'KA7SONI CINEMA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF00D9FF),
          ),
        ),
        actions: [
          IconButton(
            onPressed: addMovie,
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFFB65CFF),
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ابحث عن فيلم...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF17172B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_creation_outlined,
                          size: 75,
                          color: Color(0xFF9D4EDD),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'سينما KA7SONI',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('اضغط على + لإضافة أول فيلم'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF17172B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF7138B8),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: movie.image.isEmpty
                                    ? const Center(
                                        child: Icon(
                                          Icons.movie,
                                          size: 65,
                                          color: Color(0xFF9D4EDD),
                                        ),
                                      )
                                    : Image.network(
                                        movie.image,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.movie, size: 65),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                movie.title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00D9FF),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:
                                        const Color(0xFF17172B),
                                    title: Text(movie.title),
                                    content: Text(
                                      movie.description.isEmpty
                                          ? 'لا يوجد وصف.'
                                          : movie.description,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('إغلاق'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('التفاصيل'),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => movies.remove(movie));
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMovie,
        backgroundColor: const Color(0xFF9D4EDD),
        child: const Icon(Icons.add),
      ),
    );
  }
}