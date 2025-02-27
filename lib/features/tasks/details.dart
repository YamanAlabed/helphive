import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';


class TaskDetails extends StatefulWidget {
  final String username;
  final String title;
  final String description;
  final String street;
  final String when;
  final String whatsappNumber;
  final DateTime createdAt;
  final String imageUrl;

  const TaskDetails({
    super.key,
    required this.username,
    required this.title,
    required this.description,
    required this.street,
    required this.when,
    required this.whatsappNumber,
    required this.createdAt,
    required this.imageUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  String? errorMessage;
  bool _isHelpOffered = false;

  String formatWhatsappNumber(String number) {
    if (number.startsWith('0')) {
      number = number.substring(1);
    }
    return '49$number';
  }

  Future<void> _sendNotification() async {
    // Notification sending logic here
  }

  void _toggleHelpButton() {
    setState(() {
      _isHelpOffered = !_isHelpOffered;
    });

    if (_isHelpOffered) {
      _sendNotification();
    }
  }

  Widget buildImage() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Image.network(
      widget.imageUrl,
      width: double.infinity,
      height: screenHeight * 0.25,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: screenHeight * 0.25,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
        );
      },
    );
  }

  Widget buildDetailSection(
      String title, String content, String contactNumber, String address) {
    return Container(
      decoration: BoxDecoration(
        color: colorSoftWhite,
        border: Border.all(
          color: colorSoftWhite,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.access_time, color: colorDarkGray, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.when,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              const Icon(FontAwesomeIcons.whatsapp,
                  color: colorDarkGray, size: 16),
              const SizedBox(width: 8),
              Text(
                contactNumber,
                style: const TextStyle(
                  color: colorDarkGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FontAwesomeIcons.locationDot,
                  color: colorDarkGray, size: 16),
              const SizedBox(width: 8),
              Text(
                address,
                style: const TextStyle(
                  color: colorDarkGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStyledUsername(String username) {
    return Container(
      decoration: BoxDecoration(
        color: colorSoftWhite,
        border: Border.all(
          color: colorSoftWhite,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: colorDarkGray,
            radius: 20,
            child: Icon(Icons.person, color: colorCoolGray),
          ),
          const SizedBox(width: 12),
          Text(
            username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorDarkGray,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  buildStyledUsername(
                    widget.username,
                  ),
                  const SizedBox(height: 10),
                  buildDetailSection(
                    'Beschreibung:',
                    widget.description,
                    widget.whatsappNumber,
                    widget.street,
                  ),
                  const SizedBox(height: 5),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CustomErrorMessage(errorMessage: errorMessage!),
                    ),
                  const SizedBox(height: 0),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: _isHelpOffered ? 'Abbrechen' : 'Teilnehmen',
                        type: _isHelpOffered
                            ? ButtonType.alert
                            : ButtonType.secondary,
                        onPressed: _toggleHelpButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
