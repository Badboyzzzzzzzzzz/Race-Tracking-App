// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/model/participant.dart';
import 'package:race_tracker/ui/provider/async_values.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/widgets/add_participant_button.dart';
import 'package:race_tracker/ui/widgets/input_field.dart';
import 'package:race_tracker/ui/widgets/participant_card.dart';

class ParticipantManagementScreen extends StatefulWidget {
  const ParticipantManagementScreen({super.key});

  @override
  State<ParticipantManagementScreen> createState() =>
      _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState
    extends State<ParticipantManagementScreen> {
  final TextEditingController _bibNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _bibNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addParticipant(BuildContext context) async {
    final bibNumber = _bibNumberController.text.trim();
    final name = _nameController.text.trim();
    await context.read<ParticipantProvider>().addParticipant(bibNumber,name);
    await context
        .read<ParticipantProvider>()
        .fetchParticipants(); // Refresh list

    _bibNumberController.clear();
    _nameController.clear();
  }

  void _removeParticipant(BuildContext context, Participant p) async {
    await context.read<ParticipantProvider>().removeParticipant(p);
    await context
        .read<ParticipantProvider>()
        .fetchParticipants(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParticipantProvider>();
    final participantsValue = provider.participants;

    Widget content;

    switch (participantsValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(child: Text('Error: ${participantsValue.error}'));
        break;
      case AsyncValueState.empty:
        content = const Center(child: Text('No participants found.'));
        break;
      case AsyncValueState.success:
        final participants = participantsValue.data!;
        content = ListView.separated(
          itemCount: participants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = participants[index];
            return ParticipantCard(
              bibNumber: p.bibNumber,
              name: p.name,
              onDelete: () => _removeParticipant(context, p),
            );
          },
        );
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Participant Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),

            // Input Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InputField(
                    controller: _bibNumberController,
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
                  onPressed: () => _addParticipant(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
