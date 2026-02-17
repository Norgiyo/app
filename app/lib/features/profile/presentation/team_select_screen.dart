import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamSelectScreen extends StatelessWidget {
  const TeamSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamsRef = FirebaseFirestore.instance
        .collection('teams')
        .where('isActive', isEqualTo: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Elige tu equipo favorito')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: teamsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No hay equipos activos.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();
              final name = (data['name'] ?? d.id).toString();

              return Card(
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('ID: ${d.id}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Seleccionaste: $name (${d.id})')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
