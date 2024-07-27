import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../reusable_widgets/reusabl_widgets.dart';
import './MovieListScreen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class AddMovie extends StatefulWidget {
  final String userId;

  const AddMovie({Key? key, required this.userId}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final TextEditingController movieNameController = TextEditingController();
  final TextEditingController directorNameController = TextEditingController();
  int _watchStatus = 0;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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
          "Movie Snack Form",
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!)
                    : Icon(Icons.add_a_photo, color: Colors.grey[800]),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String id = randomAlphaNumeric(10); // Generate random ID
                String? imageUrl = await _uploadImage(id); // Upload image and get URL
                Map<String, dynamic> movieInfoMap = {
                  'movieName': movieNameController.text.trim(),
                  'directorName': directorNameController.text.trim(),
                  'watchStatus': _watchStatus,
                  'userId': widget.userId,
                  'imageUrl': imageUrl, // Add image URL to map
                };
                DatabaseMethods()
                    .addMovieDetails(movieInfoMap, id)
                    .then((data) {
                  Fluttertoast.showToast(
                      msg: "Added Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieListsScreen(userId: 'abc')),
                  );
                });
              },
              child: Text(
                'Add',
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
