import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/constants.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
class GetImage extends StatefulWidget {
  const GetImage({super.key});

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  File? file;
  String? url ;

  getImage() async {
    final ImagePicker picker = ImagePicker();
// // Pick an image.
// final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
// // Capture a photo.
    final XFile? imageCamera = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 200
    );
    if (imageCamera != null) {
      file = File(imageCamera.path);

      var imageName = basename(imageCamera.path);

      var refStorage = FirebaseStorage.instance.ref("images /$imageName");
      await refStorage.putFile(file!);
       url =await refStorage.getDownloadURL();
    }
    setState(() {});
  }
// Future<XFile?> takePhoto(
//  // final ImagePicker takeAPhoto = ImagePicker();
//   //final ImagePicker picker = ImagePicker();

//       {ImagePickerCameraDelegateOptions options =
//           const ImagePickerCameraDelegateOptions()}) async {
//     return _takeAPhoto(options.preferredCameraDevice);
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: kPrimaryColor,
              onPressed: () async {
                await getImage();
              },
              child: const Text("Select Image"),
            ),
            if (url != null) Image.network(url!),
          ],
        ),
      ),
    );
  }
}
