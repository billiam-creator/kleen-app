import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/providers.dart';

// Edit this list: add each Facebook group you post in by name.
const leadSources = [
  'Facebook: Kiserian group',
  'Facebook: Kinoo group',
  'TikTok',
  'Referral',
  'Word of mouth',
  'Other',
];

class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _area = TextEditingController();
  final _notes = TextEditingController();
  String? _source;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _area.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(dbProvider);
    await db.addClient(ClientsCompanion.insert(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      source: _source!,
      area: Value(_area.text.trim().isEmpty ? null : _area.text.trim()),
      addressNotes: Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
    ));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add client')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().length < 9 ? 'Enter a valid phone' : null,
            ),
            TextFormField(
              controller: _area,
              decoration: const InputDecoration(labelText: 'Area (Kinoo, Kiserian...)'),
              textCapitalization: TextCapitalization.words,
            ),
            DropdownButtonFormField<String>(
              value: _source,
              decoration: const InputDecoration(labelText: 'How did they hear about you?'),
              items: [for (final s in leadSources) DropdownMenuItem(value: s, child: Text(s))],
              onChanged: (v) => setState(() => _source = v),
              validator: (v) => v == null ? 'Pick a source' : null,
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Address notes (gate, dog, etc.)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}