import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addMovieDetails(Map<String, dynamic> movieInfoMap, String id) async {
    return await FirebaseFirestore.instance.collection('Movie').doc(id).set(movieInfoMap);
  }

  Future deleteMovie(String id) async {
    return await FirebaseFirestore.instance.collection('Movie').doc(id).delete();
  }

  Future updateMovieDetails(String id, Map<String, dynamic> updatedMovieInfo) async {
    return await FirebaseFirestore.instance.collection('Movie').doc(id).update(updatedMovieInfo);
  }

  Stream<QuerySnapshot> getMovies(String userId) {
    return FirebaseFirestore.instance.collection('Movie').where('userId', isEqualTo: userId).snapshots();
  }
}
