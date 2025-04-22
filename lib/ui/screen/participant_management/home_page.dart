import 'package:flutter/material.dart';
import 'package:race_tracker/ui/widget/navigation_bar.dart';
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
  int _currentIndex = 0;

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
      appBar: AppBar(
        backgroundColor: TrackerTheme.background,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RaceTimer',
              style: AppTextStyles.heading.copyWith(
                color: TrackerTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) =>
                          Icon(Icons.error, color: TrackerTheme.red),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
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
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input ID
                      InputField(
                        controller: _idController,
                        hintText: 'ID',
                        showBorder: true,
                      ),
                      if (_idError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            _idError!,
                            style: TextStyle(
                              color: TrackerTheme.red,
                              fontSize: 12,
                            ),
                          ),
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
                      // Input Name
                      InputField(
                        controller: _nameController,
                        hintText: 'Name',
                        showBorder: true,
                      ),
                      if (_nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            _nameError!,
                            style: TextStyle(
                              color: TrackerTheme.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AddParticipantsButton(label: 'Add', onPressed: _addParticipant),
              ],
            ),
            const SizedBox(height: 16),

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
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}
