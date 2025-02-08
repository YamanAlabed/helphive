import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/services/database_services.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';
import 'package:helphive_flutter/core/widgets/custom_input_field.dart';
import 'package:helphive_flutter/core/widgets/loading_spinner.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
  final TextEditingController _whatsappNummerController =
      TextEditingController();

  bool loading = false;
  String? _errorMessage;

  // Category selection
  String? _selectedCategory;
  final List<String> _categories = [
    'Haus',
    'Garten',
    'Mode',
    'Freizeit',
    'Technik',
    'Kurse',
    'Sonstiges'
  ];

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text(''),
            ),
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  // Dropdown for category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategorie',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: colorCoolGray),
                      ),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _titleController,
                    labelText: 'Title',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _descriptionController,
                    labelText: 'Beschreibung',
                    icon: Icons.description,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _addressController,
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
                    controller: _whatsappNummerController,
                    labelText: 'WhatsApp Nummer',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomErrorMessage(errorMessage: _errorMessage!),
                    ),
                  const SizedBox(height: 60),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      text: 'Veröffentlichen',
                      onPressed: _submitPost,
                    ),
                  ),
                ],
              ),
            ),
          );
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

  Future<void> _submitPost() async {
    setState(() => _errorMessage = null);

    if (_fieldsAreEmpty()) {
      setState(() {
        _errorMessage = 'Alle Felder sind erforderlich.';
        loading = false;
      });
      return;
    }

    setState(() => loading = true);

    final String id = randomAlphaNumeric(10);
    final String? userId = AuthService().getCurrentUserId();
    final Map<String, dynamic> postsInfoMap = {
      "Id": id,
      "Name": _titleController.text,
      "Description": _descriptionController.text,
      "Street": _addressController.text,
      "When": _whenController.text,
      "WhatsappNumber": _whatsappNummerController.text,
      "userId": userId,
      "Category": _selectedCategory, // Add category here
    };

    try {
      final result = await DatabaseService().addPost(postsInfoMap, id);
      if (result == null) {
        _clearFields();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post erfolgreich veröffentlicht!'),
            backgroundColor: colorSoftGreen,
            duration: Duration(seconds: 3),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Fehler beim Veröffentlichen.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';
      });
    } finally {
      setState(() => loading = false);
    }
  }

  bool _fieldsAreEmpty() {
    return _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _whenController.text.isEmpty ||
        _whatsappNummerController.text.isEmpty;
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _whenController.clear();
    _whatsappNummerController.clear();
  }
}
