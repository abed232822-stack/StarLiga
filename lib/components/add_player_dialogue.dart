import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starliga/components/custom_text_field.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/utils/colors.dart';

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedRole = 'P';

  final Map<String, String> _rolesMap = {
    'حارس': 'GK',
    'كابتن': 'C',
    'لاعب': 'P',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return '$fieldName قصير جداً';
    }
    if (trimmed.length > 30) {
      return '$fieldName طويل جداً';
    }
    if (!RegExp(r"^[\p{L}\s]+$", unicode: true).hasMatch(trimmed)) {
      return '$fieldName يجب أن يحتوي على أحرف فقط';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال العمر';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    if (age < 12 || age > 70) {
      return 'العمر يجب أن يكون بين 12 و 70 سنة';
    }
    return null;
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      final player = Player(
        fullName: _nameController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        role: _selectedRole,
      );
      Navigator.pop(context, player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        insetAnimationCurve: Curves.bounceIn,
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Center(
                    child: Text(
                      'إضافة لاعب جديد',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomAppTextField(
                    label: 'اسم اللاعب',
                    hint: 'أدخل الاسم',
                    controller: _nameController,
                    validator: (v) => _validateName(v, 'اسم اللاعب'),
                  ),
                  const SizedBox(height: 10),
                  CustomAppTextField(
                    label: 'اسم الأب',
                    hint: 'أدخل اسم الأب',
                    controller: _fatherNameController,
                    validator: (v) => _validateName(v, 'اسم الأب'),
                  ),
                  const SizedBox(height: 10),
                  CustomAppTextField(
                    label: 'العمر',
                    hint: 'أدخل العمر',
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    validator: _validateAge,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'مركز اللاعب',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _rolesMap.entries.map((entry) {
                      final isSelected = _selectedRole == entry.value;
                      return ChoiceChip(
                        label: Text(entry.key),
                        selected: isSelected,
                        selectedColor: AppColors.accentYellow,
                        backgroundColor: AppColors.surfaceVariant,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.neutral
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              _selectedRole = entry.value;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _confirm,
                      child: const Text(
                        'تأكيد البيانات',
                        style: TextStyle(
                          color: AppColors.neutral,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
