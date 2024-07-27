import 'package:flutter/material.dart';
import '../services/database.dart';


void showDeleteDialogBox(BuildContext context, String movieId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: 100,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to delete this movie?'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); 
                    await _deleteMovie(context, movieId);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _deleteMovie(BuildContext context, String movieId) async {
  // Show loading spinner
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  // Delete movie from Firestore using DatabaseMethods
  await DatabaseMethods().deleteMovie(movieId);

  // Close loading spinner after 5 seconds
  await Future.delayed(Duration(seconds: 5));
  Navigator.of(context).pop(); // Close the loading spinner
}
