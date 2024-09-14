import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuhoc_cty/chapter16/edit_entry.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'authentication_bloc.dart';

class HomePage extends StatelessWidget {
  final AuthenticationBloc _authBloc;

  HomePage(this._authBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authBloc.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('journals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No entries available'));
          }

          var entries = snapshot.data!.docs;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              var entry = entries[index];
              return ListTile(
                title: Text(entry['title']),
                subtitle: Text(entry['content']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEditBlocProvider(
                        journalEditBloc:
                            JournalEditBloc(), // Provide the necessary instance
                        child: EditEntry(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEditBlocProvider(
                journalEditBloc:
                    JournalEditBloc(), // Provide the necessary instance
                child: EditEntry(),
              ),
            ),
          );
        },
      ),
    );
  }
}
