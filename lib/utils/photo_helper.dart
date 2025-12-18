import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PhotoHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        imageQuality: 80,
      );

      if (photo != null) {
        return await _savePhoto(photo.path);
      }
      return null;
    } catch (e) {
      print('Error picking from camera: $e');
      return null;
    }
  }

  static Future<String?> pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        imageQuality: 80,
      );

      if (photo != null) {
        return await _savePhoto(photo.path);
      }
      return null;
    } catch (e) {
      print('Error picking from gallery: $e');
      return null;
    }
  }

  static Future<String> _savePhoto(String sourcePath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photosDir = path.join(appDir.path, 'photos');

      final Directory photosDirObj = Directory(photosDir);
      if (!await photosDirObj.exists()) {
        await photosDirObj.create(recursive: true);
      }

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(sourcePath);
      final String fileName =
          '${timestamp}_${DateTime.now().microsecond}$extension';
      final String targetPath = path.join(photosDir, fileName);

      final File sourceFile = File(sourcePath);

      if (extension.toLowerCase() == '.jpg' ||
          extension.toLowerCase() == '.jpeg') {
        final compressedData = await FlutterImageCompress.compressWithFile(
          sourcePath,
          quality: 80,
          minWidth: 1920,
        );

        if (compressedData != null) {
          await File(targetPath).writeAsBytes(compressedData);
          return targetPath;
        }
      }

      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      print('Error saving photo: $e');
      return sourcePath;
    }
  }

  static Future<bool> deleteAllPhotos() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photosDir = path.join(appDir.path, 'photos');
      final Directory photosDirObj = Directory(photosDir);

      if (await photosDirObj.exists()) {
        await photosDirObj.delete(recursive: true);
        return true;
      }
      return true;
    } catch (e) {
      print('Error deleting all photos: $e');
      return false;
    }
  }
}
