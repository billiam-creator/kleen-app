import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import 'add_client_screen.dart';

class ClientListScreen extends ConsumerWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
        data: (clients) {
          if (clients.isEmpty) {
            return const Center(child: Text('No clients yet. Tap + to add one.'));
          }
          return ListView.separated(
            itemCount: clients.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = clients[i];
              return ListTile(
                title: Text(c.name),
                subtitle: Text('${c.phone} · ${c.area ?? "No area"} · ${c.source}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddClientScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}