import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../reusable_widgets/reusabl_widgets.dart';
import './MovieListScreen.dart';
import '../services/database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class EditMovie extends StatefulWidget {
  final Map<String, dynamic> movieData; // Map containing movie details

  const EditMovie({Key? key, required this.movieData}) : super(key: key);

  @override
  EditMovieState createState() => EditMovieState();
}

class EditMovieState extends State<EditMovie> {
  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController directorNameController = TextEditingController();
  int _watchStatus = 0; // 0 - Unwatched, 1 - Watched
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    movieNameController.text = widget.movieData['movieName'];
    directorNameController.text = widget.movieData['directorName'];
    _watchStatus = widget.movieData['watchStatus'];
    _imageUrl = widget.movieData['imageUrl'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      Fluttertoast.showToast(
          msg: "Image uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _deleteImage() async {
    if (_imageUrl != null) {
      await FirebaseStorage.instance.refFromURL(_imageUrl!).delete();
      setState(() {
        _imageUrl = null;
      });
      Fluttertoast.showToast(
          msg: "Image deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String?> _uploadImage(String id) async {
    if (_selectedImage != null) {
      final storageReference = FirebaseStorage.instance.ref().child('movies/$id.jpg');
      await storageReference.putFile(_selectedImage!);
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Movie",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Movie Name",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            reusableTextFields(
              text: 'Enter Movie Name',
              icon: Icons.movie,
              isPasswordType: false,
              controller: movieNameController,
              borderRadius: 10.0,
              fillColor: Colors.yellow[50],
            ),
            const SizedBox(height: 20),
            Text(
              "Director Name",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            reusableTextFields(
              text: 'Enter Director Name',
              icon: Icons.person_outline,
              isPasswordType: false,
              controller: directorNameController,
              borderRadius: 10.0,
              fillColor: Colors.yellow[50],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Watched: "),
                Radio<int>(
                  value: 1,
                  groupValue: _watchStatus,
                  onChanged: (value) => setState(() => _watchStatus = value!),
                ),
                Text("Unwatched: "),
                Radio<int>(
                  value: 0,
                  groupValue: _watchStatus,
                  onChanged: (value) => setState(() => _watchStatus = value!),
                ),
              ],
            ),
            SizedBox(height: 10),
            _imageUrl != null
                ? Column(
                    children: [
                      Image.network(_imageUrl!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _deleteImage,
                            child: Text("Delete Image"),
                          ),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text("Upload New Image"),
                          ),
                        ],
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Upload Image"),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  final db = DatabaseMethods();

                  // Upload new image if selected
                  String? newImageUrl;
                  if (_selectedImage != null) {
                    newImageUrl = await _uploadImage(widget.movieData['id']);
                  }

                  // Update movie data in Firebase
                  await db.updateMovieDetails(
                    widget.movieData['id'],
                    {
                      'movieName': movieNameController.text,
                      'directorName': directorNameController.text,
                      'watchStatus': _watchStatus,
                      'imageUrl': newImageUrl ?? _imageUrl,
                    },
                  );

                  // Display success message and navigate back
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Movie updated successfully'),
                    ),
                  );
                  Navigator.pop(context);
                } catch (error) {
                  // Handle update error (e.g., display a snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating movie: $error'),
                    ),
                  );
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 238, 83),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
