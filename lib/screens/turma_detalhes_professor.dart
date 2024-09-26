import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './show_alunos.dart';

class TurmaScreen extends StatefulWidget {
  final String nome;

  TurmaScreen({required this.nome});

  @override
  _TurmaScreenState createState() => _TurmaScreenState();
}

class _TurmaScreenState extends State<TurmaScreen> {
  List<Map<String, dynamic>> dados = [];

  @override
  void initState() {
    super.initState();
    obterDadosPorNome(widget.nome);
  }

  Future<void> obterDadosPorNome(String nome) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterDadosTurma/$nome');  // Substitua pelo IP correto do servidor
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var dadosData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          dados = List<Map<String, dynamic>>.from(dadosData);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter dados da turma: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter dados da turma: $e')),
      );
    }
  }

  Future<String> buscarNomeProfessor(int id) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarNomeProfessor/$id');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var professorData = jsonDecode(response.body);
        return professorData['nome'] as String;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar nome do professor: ${response.body}')),
        );
        return '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar nome do professor: $e')),
      );
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turma'),
        actions: [
          TextButton(
            onPressed: () {
              if (dados.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostrarAlunos(
                      turmaId: dados[0]['id'],
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Adicionar Presença',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dados.length,
        itemBuilder: (context, index) {
          final item = dados[index];
          final professorResponsavelId = int.parse(item['professor_responsavel'].toString());

          return FutureBuilder<String>(
            future: buscarNomeProfessor(professorResponsavelId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text('Turma: ${item['nome']}'),
                  subtitle: Text('Carregando...'),
                );
              }

              if (snapshot.hasError) {
                return ListTile(
                  title: Text('Turma: ${item['nome']}'),
                  subtitle: Text('Erro ao buscar nome do professor'),
                );
              }

              final professor = snapshot.data!;

              return ListTile(
                title: Text('Turma: ${item['nome']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Horário: ${item['horario']}'),
                    Text('Professor Responsável: $professor'),
                    Text('Chave de Acesso: ${item['chave_acesso']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
