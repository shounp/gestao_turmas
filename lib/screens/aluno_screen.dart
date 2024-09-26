import 'package:flutter/material.dart';
import 'adicionar_turma.dart';
import './turmas_aluno.dart';

class PaginaAluno extends StatelessWidget {
  
  final String usuario;

  const PaginaAluno({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
        title: const Text('ALUNO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo Aluno!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaAdicionarAlunoTurma(usuario: usuario)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all(const Size(210, 50)),
              ),
              child: const Text('Adicionar nova turma'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcessarTurmasAluno(usuario: usuario)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all(const Size(210, 50)),
              ),
              child: const Text('Acessar minhas turmas'),
            ),
          ],
        ),
      ),
    );
  }
}