// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/model/participant.dart';
import 'package:race_tracker/theme/theme.dart';
import 'package:race_tracker/ui/provider/async_values.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/widgets/add_participant_button.dart';
import 'package:race_tracker/ui/widgets/input_field.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';
import 'package:race_tracker/ui/widgets/participant_card.dart';

class ParticipantManagementScreen extends StatefulWidget {
  const ParticipantManagementScreen({super.key});

  @override
  State<ParticipantManagementScreen> createState() =>
      _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState
    extends State<ParticipantManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bibNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _bibNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateBibNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'BIB number is required';
    }

    final numericRegex = RegExp(r'^\d+$');
    if (!numericRegex.hasMatch(value)) {
      return 'BIB number must be an integer';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  void _addParticipant(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final bibNumber = _bibNumberController.text.trim();
      final name = _nameController.text.trim();

      final success = await context.read<ParticipantProvider>().addParticipant(
        bibNumber,
        name,
      );

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BIB number $bibNumber already exists'),
            backgroundColor: TrackerTheme.red,
          ),
        );
        return;
      }

      // Clear form only after successful addition

      _bibNumberController.clear();
      _nameController.clear();
    }
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
      appBar: AppBar(
        backgroundColor: TrackerTheme.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Participant Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: TrackerTheme.primary,
              ),
            ),
            Image.asset('assets/images/logo.png', width: 80, height: 80),
          ],
        ),
      ),
      backgroundColor: TrackerTheme.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: TrackerTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'BIB',
                      style: AppTextStyles.title.copyWith(
                        color: TrackerTheme.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Name',
                      style: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // Input Row
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputField(
                      keyboardType: TextInputType.number,
                      validator: _validateBibNumber,
                      controller: _bibNumberController,
                      hintText: 'ID',
                      showBorder: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: InputField(
                      validator: _validateName,
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
            ),
            const SizedBox(height: 16),
            Expanded(child: content),
          ],
        ),
      ),
      bottomNavigationBar: Navigationbar(currentIndex: 0),
    );
  }
}
