import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create_page.dart';
import 'google_sign_in.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Widget buildNode(Problem node) => Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.album),
                  title: Text(node.prob),
                  subtitle: Text(node.sdesc),
                ),
              ),
              Text(
                node.vote.toString(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 40,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Color(0xffCF0A0A)),
                ),
                onPressed: () {
                  final docProblems = FirebaseFirestore.instance
                      .collection('user')
                      .doc(node.id);
                  docProblems.delete();
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Downvote'),
                onPressed: () {
                  final docProblems = FirebaseFirestore.instance
                      .collection('user')
                      .doc(node.id);

                  docProblems.update({
                    'vote': node.vote - 1,
                  });
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Upvote'),
                onPressed: () {
                  final docProblems = FirebaseFirestore.instance
                      .collection('user')
                      .doc(node.id);
                  docProblems.update({
                    'vote': node.vote + 1,
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );

class _MyAppState extends State<MyApp> {
  Stream<List<Problem>> readProblem() => FirebaseFirestore.instance
      .collection('user')
      .orderBy('vote', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Problem.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build-Solution'),
        backgroundColor: Color(0xFF00ABB3),
        actions: [
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      ),
      body: StreamBuilder<List<Problem>>(
        stream: readProblem(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          } else if (snapshot.hasData) {
            final node = snapshot.data!;

            return ListView(children: node.map(buildNode).toList());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF3C4048),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Cpage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
