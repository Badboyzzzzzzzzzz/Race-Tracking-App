import 'package:flutter/material.dart';
import '../../widget/participant_card.dart';
import '../../widget/input_field.dart';
import '../../widget/add_participants_button.dart';

class ParticipantManagementScreen extends StatefulWidget {
  const ParticipantManagementScreen({super.key});

  @override
  _ParticipantManagementScreenState createState() =>
      _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState
    extends State<ParticipantManagementScreen> {
  final TextEditingController _idController   = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<Map<String, String>> _participants = [];

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addParticipant() {
    final id   = _idController.text.trim();
    final name = _nameController.text.trim();
    if (id.isEmpty || name.isEmpty) return;

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
            // Add row always visible
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InputField(
                    controller: _idController,
                    hintText: 'ID',
                    showBorder: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: InputField(
                    controller: _nameController,
                    hintText: 'Name',
                    showBorder: true,
                  ),
                ),
                const SizedBox(width: 12),
                AddParticipantsButton(
                  label: 'Add',
                  onPressed: _addParticipant,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Scrollable list of ParticipantCards
            Expanded(
              child: _participants.isEmpty
                  ? const Center(child: Text('No participants yet.'))
                  : ListView.separated(
                      itemCount: _participants.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
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
