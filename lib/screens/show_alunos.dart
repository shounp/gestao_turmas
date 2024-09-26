import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:turmas/screens/buscar_user.dart';

class MostrarAlunos extends StatefulWidget {
  final int turmaId;

  MostrarAlunos({required this.turmaId});

  @override
  _MostrarAlunosState createState() => _MostrarAlunosState();
}

class _MostrarAlunosState extends State<MostrarAlunos> {
  List<Map<String, dynamic>> alunos = [];
  List<int> alunoIds = [];

  @override
  void initState() {
    super.initState();
    obterAlunosTurma();
  }

  Future<void> obterAlunosTurma() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterAlunosTurma/${widget.turmaId}');  // Substitua pelo IP correto do servidor
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var alunosData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          alunos = List<Map<String, dynamic>>.from(alunosData);
          alunoIds = alunos.map((aluno) => aluno['aluno_id'] as int).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter alunos: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter alunos da turma: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos da Turma'),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuscarUsuarios(alunoIds: alunoIds),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
            child: Text('Mostrar Alunos'),
          ),
        ),
      ),
    );
  }
}
