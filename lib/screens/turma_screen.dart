import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TurmaScreen extends StatelessWidget {
  final String nome;
  final int usuarioId;
  final int turmaId;

  const TurmaScreen({super.key, required this.nome, required this.usuarioId, required this.turmaId});

  // Função para marcar a presença
  Future<void> marcarPresenca(BuildContext context, int usuarioId, int turmaId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/adicionarPresenca');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': usuarioId,
          'turmaId': turmaId,
        }),
      );

      if (response.statusCode == 200) {
        print('Presença marcada com sucesso.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença marcada com sucesso!')),
        );
      } else {
        print('Erro ao marcar presença: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao marcar presença: ${response.body}')),
        );
      }
    } catch (e) {
      print('Erro de conexão: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da turma: $nome'),
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
            const SizedBox(height: 20), // Espaçamento entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                marcarPresenca(context, usuarioId, turmaId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 31, 15, 97), // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Adicionar Presença',
                style: TextStyle(fontSize: 18, color: Colors.white), // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
