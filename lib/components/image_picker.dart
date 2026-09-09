import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starliga/utils/colors.dart';

class TeamImagePicker extends StatefulWidget {
  final void Function(File image) onImageSelected;

  const TeamImagePicker({super.key, required this.onImageSelected});

  @override
  State<TeamImagePicker> createState() => _TeamImagePickerState();
}

class _TeamImagePickerState extends State<TeamImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file;
      });
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 2),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: AppColors.iconInactive,
                        )
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'شعار الفريق',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
