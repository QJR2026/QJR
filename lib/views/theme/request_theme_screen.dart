import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:motivational/app/my_app_view.dart';
import '../../providers/theme_provider.dart';
import '/extensions/size_box_extension.dart';
import '/utils/custom_snackbar.dart';
import '/utils/form_validators.dart';
import '/utils/my_colors.dart';
import '../auth/widget/auth_button.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/my_textfield.dart';
import '../widgets/theme_image_upload_box.dart';

class RequestThemeScreen extends StatefulWidget {
  const RequestThemeScreen({super.key});

  @override
  State<RequestThemeScreen> createState() => _RequestThemeScreenState();
}

class _RequestThemeScreenState extends State<RequestThemeScreen> {
  static const int _maxImageSizeBytes = 5 * 1024 * 1024;
  static const List<String> _allowedExtensions = ['png', 'jpg', 'jpeg'];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageTap() async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) {
      await _pickImage();
      return;
    }

    if (status.isPermanentlyDenied) {
      _showOpenSettingsDialog();
      return;
    }

    final result = await Permission.photos.request();
    if (result.isGranted || result.isLimited) {
      await _pickImage();
    } else if (result.isPermanentlyDenied) {
      _showOpenSettingsDialog();
    } else {
      CustomSnackBar.showError(
        message: 'Photo library permission is required to upload an image.',
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedFile == null) return;

    final extension = pickedFile.path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      CustomSnackBar.showError(message: 'Only PNG and JPG images are allowed.');
      return;
    }

    final file = File(pickedFile.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > _maxImageSizeBytes) {
      CustomSnackBar.showError(message: 'Image size should not exceed 5 MB.');
      return;
    }

    setState(() => _selectedImage = file);
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Permission Required',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: MyColors.blackTypeColor,
          ),
        ),
        content: const Text(
          'Photo library access has been permanently denied. Please enable it from settings to upload an image.',
          style: TextStyle(color: MyColors.blackTypeColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: MyColors.blackTypeColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppSettings.openAppSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: MyColors.blackTypeColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<ThemeProvider>().requestTheme(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          image: _selectedImage,
        );

    if (success && mounted) {
      MyApp.gState.pop();
      CustomSnackBar.showPrimary(message: 'Theme request submitted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (kToolbarHeight * 2).vSpace(),
                const CustomBackButton(),
                25.vSpace(),
                const FittedBox(
                  child: Text(
                    'Request a Theme',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),
                const Text(
                  'You will receive motivational quotes at your chosen time.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                30.vSpace(),
                MyTextFormField(
                  backgroundColor: Colors.transparent,
                  hintText: 'Theme Title',
                  controller: _titleController,
                  bottomSpace: 16,
                  validator: (v) => FormValidators.requiredFieldValidator(
                    v,
                    fieldName: 'Theme Title',
                  ),
                ),
                MyTextFormField(
                  backgroundColor: Colors.transparent,
                  hintText: 'Theme Description',
                  controller: _descriptionController,
                  maxLines: 5,
                  bottomSpace: 16,
                  validator: (v) => FormValidators.requiredFieldValidator(
                    v,
                    fieldName: 'Theme Description',
                  ),
                ),
                ThemeImageUploadBox(
                  image: _selectedImage,
                  onTap: _handleImageTap,
                  onRemove: () => setState(() => _selectedImage = null),
                ),
                35.vSpace(),
                Consumer<ThemeProvider>(
                  builder: (context, provider, _) {
                    return Align(
                      child: AuthButton(
                        buttonWidth: 390,
                        text: 'Submit Theme Request',
                        loading: provider.requestThemeLoading,
                        disable: provider.requestThemeLoading,
                        onPressed: _submit,
                      ),
                    );
                  },
                ),
                30.vSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
