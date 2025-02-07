import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/database_services.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';
import 'package:helphive_flutter/core/widgets/custom_input_field.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final String postId;
  final String name;
  final String description;
  final String street;
  final String when;
  final String whatsappNumber;

  const EditTask({
    super.key,
    required this.postId,
    required this.name,
    required this.description,
    required this.street,
    required this.when,
    required this.whatsappNumber,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _streetController;
  late TextEditingController _whenController;
  late TextEditingController _whatsappController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _streetController = TextEditingController(text: widget.street);
    _whenController = TextEditingController(text: widget.when);
    _whatsappController = TextEditingController(text: widget.whatsappNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _streetController.dispose();
    _whenController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _whenController.text.isEmpty ||
        _whatsappController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Alle Felder müssen ausgefüllt werden.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
    });

    final updatedData = {
      'Name': _nameController.text,
      'Description': _descriptionController.text,
      'Street': _streetController.text,
      'When': _whenController.text,
      'WhatsappNumber': _whatsappController.text,
    };

    try {
      await DatabaseService().updatePost(widget.postId, updatedData);

      // show a success SnackBar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beitrag erfolgreich aktualisiert!'),
          backgroundColor: colorSoftGreen,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage =
            'Fehler beim Aktualisieren des Beitrags. Bitte versuchen Sie es später erneut.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _whenController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Version'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              CustomTextField(
                controller: _nameController,
                labelText: 'Title',
                icon: Icons.title,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Beschreibung',
                icon: Icons.description,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _streetController,
                labelText: 'Straße',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _whenController,
                    labelText: 'Wann?',
                    icon: Icons.calendar_today,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _whatsappController,
                labelText: 'WhatsApp Nummer',
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),
              // Conditionally show the error message widget
              if (_errorMessage != null)
                CustomErrorMessage(errorMessage: _errorMessage!),
              const SizedBox(height: 60),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'Fertig',
                      onPressed: _updatePost,
                      type: ButtonType.secondary,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
