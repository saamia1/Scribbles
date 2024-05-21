import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/chat/chat_service.dart';
import '../services/auth/auth_service.dart';
import 'package:messaging_app/models/page_request.dart';
import 'package:messaging_app/services/paging/paging_service.dart';

class PagerPage extends StatefulWidget {
  const PagerPage({Key? key}) : super(key: key);

  @override
  _PagerPageState createState() => _PagerPageState();
}

class _PagerPageState extends State<PagerPage> {
  final AuthService _authService = AuthService();
  late ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();

  String? _selectedLocation;
  String? _selectedType;
  String? _selectedRecipientEmail; // State variable to hold the selected recipient's email
  late final String _selectedUid;

  // Sample data for dropdowns with custom urgency levels
  final List<String> locations = ['Location 1', 'Location 2', 'Location 3'];
  final List<String> types = ['Low Urgency', 'Medium Urgency', 'High Urgency'];

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(_authService); // Initialize _chatService here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Paging Notification'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Recipient selection input
              buildRecipientSelector(),

              // Location selection dropdown
              buildDropdown('Location:', _selectedLocation, locations, (val) => setState(() => _selectedLocation = val)),

              // Notification type dropdown
              buildDropdown('Notification Type:', _selectedType, types, (val) => setState(() => _selectedType = val)),

              // Custom message input field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Custom Message',
                  hintText: 'Enter your message here',
                ),
                controller: _messageController,
              ),

              // Send notification button
              ElevatedButton(
                onPressed: _sendNotification,
                child: const Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecipientSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text('Recipient Name:'),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('Loading...');
                }
                var recipients = snapshot.data!;
                return Autocomplete<Map<String, dynamic>>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<Map<String, dynamic>>.empty();
                    }
                    return recipients.where((Map<String, dynamic> recipient) {
                      return recipient['email'].toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (Map<String, dynamic> option) => option['email'],
                  onSelected: (Map<String, dynamic> selection) {
                    setState(() {
                      _selectedRecipientEmail = selection['email'];
                      _selectedUid = selection['uid'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String? currentValue, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentValue,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _sendNotification() {
    if (_selectedRecipientEmail == null || _selectedLocation == null || _selectedType == null || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
      ));
      return;
    }

    PagerRequest pagerRequest = PagerRequest(
      id: '', // ID will be set by Firestore when creating the document
      recipientEmail: _selectedRecipientEmail!,
      senderID: _authService.getCurrentUser()?.uid ?? '',
      senderEmail: _authService.getCurrentUser()?.email ?? '',
      timestamp: Timestamp.now(),
      notificationType: _selectedType!,
      message: _messageController.text,
      location: _selectedLocation!
    );

    // Assuming PagingService handles the logic to write to Firestore
    _chatService.sendPagingNotification(
      receiverID: _selectedUid,
      recipientEmail: _selectedRecipientEmail!,
      location: _selectedLocation!,
      notificationType: _selectedType!,
      customMessage: _messageController.text
    );
  }
}
