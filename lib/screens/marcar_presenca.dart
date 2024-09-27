import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarcarPresencaScreen extends StatefulWidget {
  final int turmaId;

  const MarcarPresencaScreen({super.key, required this.turmaId});

  @override
  _MarcarPresencaScreenState createState() => _MarcarPresencaScreenState();
}

class _MarcarPresencaScreenState extends State<MarcarPresencaScreen> {
  List<Map<String, dynamic>> alunos = [];

  @override
  void initState() {
    super.initState();
    buscarAlunos();
  }

  // Função para buscar os alunos da turma
  Future<void> buscarAlunos() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterAlunosTurma/${widget.turmaId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var alunosData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          alunos = alunosData.map((aluno) => {
            'id': aluno['aluno_id'],
            'nome': aluno['nome'],
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar alunos: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar alunos: $e')),
      );
    }
  }

  // Função para marcar a presença passando os parâmetros na URL
  Future<void> marcarPresenca(int alunoId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/adicionarPresenca/$alunoId/${widget.turmaId}');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença marcada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao marcar presença: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao marcar presença: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcar Presença'),
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
      ),
      body: alunos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(aluno['nome'], style: const TextStyle(fontSize: 18)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        marcarPresenca(aluno['id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200], // Cor azul claro
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Marcar Presença',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
