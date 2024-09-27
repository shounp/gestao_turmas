import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaAdicionarTurma extends StatelessWidget {
  final TextEditingController disciplinaController = TextEditingController();
  final TextEditingController professorController = TextEditingController();
  final TextEditingController horariosController = TextEditingController();
  final TextEditingController chaveAcessoController = TextEditingController();

  PaginaAdicionarTurma({super.key});

  Future<void> _adicionarTurma(BuildContext context) async {
    final nome = disciplinaController.text;
    final professor = professorController.text;
    final horarios = horariosController.text;
    final chaveAcesso = chaveAcessoController.text;

    try {
      var url = Uri.parse('http://192.168.1.2:3000/adicionarTurma');  // Substitua pelo IP correto do servidor
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'professor': professor,
          'horarios': horarios,
          'chaveAcesso': chaveAcesso,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Turma adicionada com sucesso!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao adicionar turma: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao adicionar turma: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0a6d92),
        title: const Text('ADICIONAR TURMA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: disciplinaController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Disciplina',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: professorController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Professor',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: horariosController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Horário',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: chaveAcessoController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Chave de Acesso',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _adicionarTurma(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0a6d92), // Cor de fundo do botão
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Adicionar Turma',
                style: TextStyle(fontSize: 18, color: Colors.white), // Cor branca para o texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
