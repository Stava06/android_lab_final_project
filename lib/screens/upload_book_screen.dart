import 'package:flutter/material.dart';

class UploadBookScreen extends StatefulWidget {
  final String fileType;
  final String ageGroup;

  const UploadBookScreen({
    super.key,
    required this.fileType,
    required this.ageGroup,
  });

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedDummyFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickDummyFile() {
    if (_isUploading) return;
    setState(() {
      final sanitizedTitle = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase()
          : 'book';
      _selectedDummyFile = 'mock_${sanitizedTitle}_demo.${widget.fileType}';
    });
  }

  Future<void> _startUpload() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDummyFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Please tap below to select a dummy file.'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Animate upload progress from 0 to 100%
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _uploadProgress = i / 20.0;
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '"${_nameController.text.trim()}" uploaded successfully!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context, _nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.fileType == 'pdf' ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Upload Book Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro text
              const Text(
                'Add a New Book',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in the title and select a dummy file to upload to the "${widget.ageGroup}" category (${widget.fileType.toUpperCase()}).',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Title input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                ),
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _nameController,
                  enabled: !_isUploading,
                  decoration: InputDecoration(
                    labelText: 'Book Title',
                    hintText: 'Enter the book name',
                    prefixIcon: Icon(Icons.book_rounded, color: themeColor),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a book title';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    if (_selectedDummyFile != null) {
                      _pickDummyFile();
                    }
                  },
                ),
              ),
              const SizedBox(height: 28),

              // File Selection Box
              const Text(
                'File Attachment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDummyFile,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _selectedDummyFile != null
                        ? const Color(0xFF10B981).withValues(alpha: 0.04)
                        : themeColor.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedDummyFile != null
                          ? const Color(0xFF10B981)
                          : themeColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedDummyFile != null
                              ? const Color(0xFF10B981).withValues(alpha: 0.1)
                              : themeColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedDummyFile != null
                              ? Icons.cloud_done_rounded
                              : Icons.cloud_upload_rounded,
                          size: 36,
                          color: _selectedDummyFile != null ? const Color(0xFF10B981) : themeColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedDummyFile != null
                            ? 'Attached: $_selectedDummyFile'
                            : 'Tap here to attach dummy file',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _selectedDummyFile != null
                              ? const Color(0xFF0F766E)
                              : const Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selectedDummyFile != null
                            ? 'Size: ${(1.2 + (_nameController.text.length * 0.15)).toStringAsFixed(2)} MB'
                            : 'Format: .${widget.fileType.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Upload state or Submit button
              if (_isUploading) ...[
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        color: themeColor,
                        backgroundColor: themeColor.withValues(alpha: 0.12),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Uploading to server...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _startUpload,
                    icon: const Icon(Icons.cloud_upload_rounded),
                    label: const Text(
                      'START DUMMY UPLOAD',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
