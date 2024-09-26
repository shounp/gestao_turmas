import 'package:flutter/material.dart';

class VerificarPresencaPage extends StatelessWidget {
  final String disciplina;

  const VerificarPresencaPage(this.disciplina, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Presença'),
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
