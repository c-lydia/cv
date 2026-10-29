import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

Future<bool> savePdf(Uint8List bytes) async {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);
  final link = web.HTMLAnchorElement()
    ..href = url
    ..download = 'Chheng-Lydiya-CV.pdf';
  web.document.body?.append(link);
  link.click();
  link.remove();
  Timer(const Duration(minutes: 1), () => web.URL.revokeObjectURL(url));
  return true;
}
