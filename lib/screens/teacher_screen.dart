import 'package:flutter/material.dart';
import 'package:turmas/screens/criar_turma.dart';
import 'package:turmas/screens/turmas_professor.dart';

class PaginaProfessor extends StatelessWidget {
  final String usuario;
  final String senha;
  final String tipoUsuario;

  const PaginaProfessor({super.key, required this.usuario, required this.senha, required this.tipoUsuario});

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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 135, 206, 250), // Azul claro
                minimumSize: const Size(210, 50),
              ),
              child: const Text(
                'Criar nova turma',
                style: TextStyle(color: Colors.white), // Texto branco
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaAcessarTurmas(usuario: usuario)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 135, 206, 250), // Azul claro
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Acessar minhas turmas',
                style: TextStyle(color: Colors.white), // Texto branco
              ),
            ),
          ],
        ),
      ),
    );
  }
}
