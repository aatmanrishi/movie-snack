import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/AddMovie.dart';
import '../reusable_widgets/reusabl_widgets.dart';
import '../reusable_widgets/MovieCard.dart';
import '../services/database.dart';

class MovieListsScreen extends StatefulWidget {
  final String userId; // User ID obtained from authentication or previous screen

  const MovieListsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListsScreen> {
  Stream? movieStream;

  getOnLoad(userId) async {
    movieStream = await DatabaseMethods().getMovies(userId);
    setState(() {});
  }

  @override
  void initState() {
    getOnLoad(widget.userId);
    super.initState();
  }

  // Get all movies function will get movies from database and then we'll pass them in MovieCard widget to render them
  Widget allMovies() {
    return StreamBuilder(
      stream: movieStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return MovieCard(
                    movieName: ds['movieName'],
                    directorName: ds['directorName'],
                    watchStatus: ds['watchStatus'],
                    userId: ds['userId'],
                    id: ds['id'],
                    imageUrl: ds['imageUrl'], // Pass imageUrl to MovieCard
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMovie(userId: widget.userId)),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Movie ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Snack",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: allMovies(),
      ),
    );
  }
}
