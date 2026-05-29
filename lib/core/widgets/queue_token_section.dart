import 'dart:io';

import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/repositories/supabase_repo/storage_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pharmacy queue token number + optional photo upload.
class QueueTokenSection extends StatefulWidget {
  final String patientUid;
  final int? initialTokenNum;
  final String? initialImageUrl;
  final ValueChanged<int?> onTokenNumChanged;
  final ValueChanged<String?> onImageUrlChanged;

  const QueueTokenSection({
    super.key,
    required this.patientUid,
    this.initialTokenNum,
    this.initialImageUrl,
    required this.onTokenNumChanged,
    required this.onImageUrlChanged,
  });

  @override
  State<QueueTokenSection> createState() => _QueueTokenSectionState();
}

class _QueueTokenSectionState extends State<QueueTokenSection> {
  late final TextEditingController _tokenController;
  String? _imageUrl;
  String? _localPreviewPath;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(
      text: widget.initialTokenNum?.toString() ?? '',
    );
    _imageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    setState(() {
      _uploading = true;
      _localPreviewPath = path;
    });

    final url = await StorageRepo(uid: widget.patientUid).uploadOrderTokenImage(
      path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (!mounted) return;
    setState(() => _uploading = false);

    if (url != null) {
      setState(() => _imageUrl = url);
      widget.onImageUrlChanged(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token photo uploaded')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed. Check Storage bucket order-tokens.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kcWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kcDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined, color: kcPrimary, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                'Pharmacy queue token',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: kcPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Enter your hospital queue number and optionally upload a photo of the token slip.',
            style: TextStyle(fontSize: 12.sp, color: kctextgrey, height: 1.35),
          ),
          SizedBox(height: 14.h),
          TextField(
            controller: _tokenController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Token number',
              hintText: 'e.g. 4521',
              prefixIcon: const Icon(Icons.tag_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            onChanged: (v) => widget.onTokenNumChanged(int.tryParse(v)),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploading ? null : _pickAndUpload,
                  icon: _uploading
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_a_photo_outlined),
                  label: Text(_imageUrl != null ? 'Replace photo' : 'Upload token photo'),
                ),
              ),
            ],
          ),
          if (_localPreviewPath != null || _imageUrl != null) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _localPreviewPath != null
                  ? Image.file(File(_localPreviewPath!), height: 100.h, width: double.infinity, fit: BoxFit.cover)
                  : Image.network(_imageUrl!, height: 100.h, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }
}
