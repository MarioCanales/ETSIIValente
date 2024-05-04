import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileUtils {
  static Future<String?> selectSaveFile() async {
    // Use file picker to allow the user to select a file location and provide a filename.
    return await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['.json'],
      dialogTitle: 'Guardar circuito',
      fileName: 'Circuito1.json'
    );
  }

  static Future<String?> selectFile() async {
    // Use file picker to allow the user to select a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['.json'],
      dialogTitle: 'Save Circuit Data',
    );

    if (result != null) {
      // Return the path of the selected file.
      return result.paths.first;
    } else {
      return null; // Return null if the user cancels the file picker.
    }
  }

  static Future<void> writeToFile(String filePath, String jsonData) async {
    // Write the serialized JSON data to the selected file.
    File file = File(filePath);
    await file.writeAsString(jsonData);
  }
}