import 'package:flutter/material.dart';
import '../../widget/participant_card.dart';
import '../../widget/input_field.dart';
import '../../widget/add_participants_button.dart';
import 'package:race_tracker/theme/theme.dart';

class ParticipantManagementScreen extends StatefulWidget {
  const ParticipantManagementScreen({super.key});

  @override
  _ParticipantManagementScreenState createState() =>
      _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState
    extends State<ParticipantManagementScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<Map<String, String>> _participants = [];
  String? _idError;
  String? _nameError;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    bool isValid = true;

    // Reset errors
    setState(() {
      _idError = null;
      _nameError = null;
    });

    // ID validation
    if (id.isEmpty) {
      setState(() {
        _idError = 'ID is required';
      });
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id)) {
      setState(() {
        _idError = 'ID can only contain letters and numbers';
      });
      isValid = false;
    } else if (_participants.any((p) => p['id'] == id)) {
      setState(() {
        _idError = 'ID must be unique';
      });
      isValid = false;
    }

    // Name validation
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      isValid = false;
    }

    return isValid;
  }

  void _addParticipant() {
    if (!_validateInputs()) return;

    final id = _idController.text.trim();
    final name = _nameController.text.trim();

    setState(() {
      _participants.add({'id': id, 'name': name});
      _idController.clear();
      _nameController.clear();
    });
  }

  void _removeParticipant(String id) {
    setState(() {
      _participants.removeWhere((p) => p['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        controller: _idController,
                        hintText: 'ID',
                        showBorder: true,
                      ),
                      SizedBox(
                        height: 20,
                        child:
                            _idError != null
                                ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 12,
                                  ),
                                  child: Text(
                                    _idError!,
                                    style: TextStyle(
                                      color: TrackerTheme.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        controller: _nameController,
                        hintText: 'Name',
                        showBorder: true,
                      ),
                      SizedBox(
                        height: 20,
                        child:
                            _nameError != null
                                ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 12,
                                  ),
                                  child: Text(
                                    _nameError!,
                                    style: TextStyle(
                                      color: TrackerTheme.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AddParticipantsButton(label: 'Add', onPressed: _addParticipant),
              ],
            ),
            const SizedBox(height: 16),
            // Scrollable list of ParticipantCards
            Expanded(
              child:
                  _participants.isEmpty
                      ? const Center(child: Text('No participants yet.'))
                      : ListView.separated(
                        itemCount: _participants.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = _participants[index];
                          return ParticipantCard(
                            id: p['id']!,
                            name: p['name']!,
                            onDelete: () => _removeParticipant(p['id']!),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
