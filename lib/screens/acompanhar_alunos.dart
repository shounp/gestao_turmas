import 'package:flutter/material.dart';
class AcompanharAlunosPage extends StatelessWidget {
  final String disciplina;

  const AcompanharAlunosPage(this.disciplina, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acompanhar Alunos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              disciplina,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}