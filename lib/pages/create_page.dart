import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cpage extends StatefulWidget {
  const Cpage({super.key});

  @override
  State<Cpage> createState() => _CpageState();
}

class _CpageState extends State<Cpage> {
  TextEditingController problem = TextEditingController();
  TextEditingController sDesc = TextEditingController();
  TextEditingController bDesc = TextEditingController();
  Future createProblem(
      {required String problems,
      required String sDescs,
      required String bDescs}) async {
    final docProblem = FirebaseFirestore.instance.collection('user').doc();

    final problemObject = Problem(
      id: docProblem.id,
      prob: problems,
      sdesc: sDescs,
      bdesc: bDescs,
    );

    final json = problemObject.toJson();
    await docProblem.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00ABB3),
        title: const Text('Create Thread'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: problem,
              decoration: const InputDecoration(
                hintText: 'Enter your problem',
                labelText: 'Problem',
              ),
            ),
            TextField(
              controller: sDesc,
              decoration: const InputDecoration(
                hintText: 'Describe your problem',
                labelText: 'Short Description',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            OutlinedButton(
              // style: ButtonStyle(),
              style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFF3C4048), //<-- SEE HERE
              ),
              onPressed: () {
                final pro = problem.text;
                final sd = sDesc.text;
                final bd = bDesc.text;

                createProblem(problems: pro, sDescs: sd, bDescs: bd);

                Navigator.pop(context);
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Color(0xffEEEEEE)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Problem {
  final String id;
  final String prob;
  final String sdesc;
  final String bdesc;
  int vote = 0;
  Problem({
    this.id = '',
    required this.prob,
    required this.sdesc,
    required this.bdesc,
    this.vote = 0,
  });
  Map<String, dynamic> toJson() => {
        'problem': prob,
        'short_desc': sdesc,
        'long_desc': bdesc,
        'id': id,
        'vote': vote,
      };

  static Problem fromJson(Map<String, dynamic> json) => Problem(
        prob: json['problem'],
        sdesc: json['short_desc'],
        bdesc: json['long_desc'],
        id: json['id'],
        vote: json['vote'],
      );

  int sort(other) {
    return this.vote.compareTo(other.vote);
  }
}
