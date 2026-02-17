import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/user_profile_repository.dart';

class TeamSelectScreen extends StatefulWidget {
  const TeamSelectScreen({super.key});

  @override
  State<TeamSelectScreen> createState() => _TeamSelectScreenState();
}

class _TeamSelectScreenState extends State<TeamSelectScreen> {
  final UserProfileRepository _userProfileRepository = UserProfileRepository();
  String? _savingTeamId;

  Future<void> _onSelectTeam({
    required User user,
    required String teamId,
    required String teamName,
  }) async {
    setState(() => _savingTeamId = teamId);
    try {
      await _userProfileRepository.ensureUserProfile(user);
      await _userProfileRepository.saveFavoriteTeam(
        uid: user.uid,
        teamId: teamId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Equipo guardado: $teamName')));
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo guardar: ${e.code}')));
    } finally {
      if (mounted) {
        setState(() => _savingTeamId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Inicia sesion para elegir un equipo.')),
      );
    }

    final teamsRef = FirebaseFirestore.instance
        .collection('teams')
        .where('isActive', isEqualTo: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Elige tu equipo favorito')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userProfileRepository.watchUserProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final selectedTeamId = snapshot.data!
              .data()?['favoriteTeamId']
              ?.toString();

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: teamsRef.snapshots(),
            builder: (context, teamsSnapshot) {
              if (teamsSnapshot.hasError) {
                return Center(child: Text('Error: ${teamsSnapshot.error}'));
              }
              if (!teamsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = teamsSnapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(child: Text('No hay equipos activos.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final d = docs[i];
                  final data = d.data();
                  final name = (data['name'] ?? d.id).toString();
                  final isSelected = selectedTeamId == d.id;
                  final isSaving = _savingTeamId == d.id;

                  return Card(
                    child: ListTile(
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        isSelected
                            ? 'Equipo seleccionado'
                            : 'Toca para seleccionar',
                      ),
                      trailing: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.chevron_right,
                            ),
                      onTap: isSaving
                          ? null
                          : () => _onSelectTeam(
                              user: currentUser,
                              teamId: d.id,
                              teamName: name,
                            ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
