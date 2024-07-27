import 'package:flutter/material.dart';
import '../screens/EditMovieScree.dart';
import './showDeleteDialogueBox.dart';

class MovieCard extends StatelessWidget {
  final String movieName;
  final String directorName;
  final int watchStatus;
  final String userId;
  final String id;
  final String? imageUrl; 

  const MovieCard({
    Key? key,
    required this.movieName,
    required this.directorName,
    required this.watchStatus,
    required this.userId,
    required this.id,
    this.imageUrl, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black, width: 1.0),
        ),
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: double.infinity,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://via.placeholder.com/400',
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Movie Name: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      movieName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Director Name: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      directorName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      watchStatus == 1 ? 'Watched' : 'Unwatched',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        // Here Navigate to EditMovie screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMovie(
                              movieData: {
                                'movieName': movieName,
                                'directorName': directorName,
                                'watchStatus': watchStatus,
                                'userId': userId,
                                'id': id,
                                'imageUrl': imageUrl, 
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: Colors.yellow,
                      ),
                      child: Icon(Icons.tips_and_updates_sharp, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    // Delete Button
                    ElevatedButton(
                      onPressed: () => showDeleteDialogBox(context, id),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: Colors.red,
                      ),
                      child: Icon(Icons.delete_sharp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
