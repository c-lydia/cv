import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

Future<bool> savePdf(Uint8List bytes) async {
  final location = await getSaveLocation(
    suggestedName: 'Chheng-Lydiya-CV.pdf',
    acceptedTypeGroups: const [
      XTypeGroup(label: 'PDF document', extensions: ['pdf']),
    ],
  );
  if (location == null) return false;
  await XFile.fromData(
    bytes,
    mimeType: 'application/pdf',
    name: 'Chheng-Lydiya-CV.pdf',
  ).saveTo(location.path);
  return true;
}
