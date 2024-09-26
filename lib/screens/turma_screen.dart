import 'package:flutter/material.dart';
import 'marcar_presenca.dart';  // Importar o arquivo onde está a função adicionarPresenca

class TurmaScreen extends StatelessWidget {
  final String nome;

  const TurmaScreen({super.key, required this.nome});

  // Adicione o ID do usuário e da turma para adicionar a presença
  final int usuarioId = 1; // Você pode modificar para obter o ID dinamicamente
  final int turmaId = 1; // Esse valor também pode ser alterado dinamicamente

  Future<void> _adicionarPresenca() async {
    await adicionarPresenca(usuarioId, turmaId);  // Chama a função adicionarPresenca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nome),  // O nome da turma será exibido no título da AppBar
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Detalhes da turma $nome',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),  // Espaçamento entre o texto e o botão
            ElevatedButton(
              onPressed: _adicionarPresenca,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 31, 15, 97),  // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Adicionar Presença',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
