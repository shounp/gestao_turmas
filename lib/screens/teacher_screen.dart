import 'package:flutter/material.dart';
import 'package:turmas/screens/criar_turma.dart';
import 'package:turmas/screens/turmas_professor.dart';


class PaginaProfessor extends StatelessWidget {
  final String usuario;

  const PaginaProfessor({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
        title: const Text('PROFESSOR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo Professor!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaAdicionarTurma()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all(const Size(210, 50)),
              ),
              child: const Text('Criar nova turma'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaAcessarTurmas(usuario: usuario)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
              ),
              child: const Text('Acessar minhas turmas'),
            ),
          ],
        ),
      ),
    );
  }
}