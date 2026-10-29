import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../platform/save_pdf.dart';

class ExportCvButton extends StatefulWidget {
  const ExportCvButton({super.key, this.save});
  final Future<bool> Function(Uint8List)? save;
  @override
  State<ExportCvButton> createState() => _ExportCvButtonState();
}

class _ExportCvButtonState extends State<ExportCvButton> {
  bool _busy = false;
  Future<void> _export() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final data = await rootBundle.load('assets/cv/Chheng-Lydiya-CV.pdf');
      await (widget.save ?? savePdf)(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save the CV. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: _busy ? null : _export,
    icon: _busy
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.download_outlined, size: 18),
    label: Text(_busy ? 'Preparing PDF…' : 'Download CV (PDF)'),
  );
}
