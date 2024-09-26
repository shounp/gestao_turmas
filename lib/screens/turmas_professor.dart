import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'turma_detalhes_professor.dart';

class PaginaAcessarTurmas extends StatefulWidget {
  final String usuario;

  const PaginaAcessarTurmas({super.key, required this.usuario});

  @override
  _PaginaAcessarTurmasState createState() => _PaginaAcessarTurmasState();
}

class _PaginaAcessarTurmasState extends State<PaginaAcessarTurmas> {
  List<String> turmas = []; // Lista de turmas do usuário

  @override
  void initState() {
    super.initState();
    obterTurmasUsuario();
  }

  Future<void> obterTurmasUsuario() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterTurmasProfessor/${widget.usuario}');  // Substitua pelo IP correto do servidor
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var turmasData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          turmas = turmasData.map((turma) => turma['nome'] as String).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter turmas: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter turmas do usuário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
        title: const Text('Minhas Turmas'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: turmas.map((turma) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TurmaScreen(nome: turma),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all<Size>(const Size(120, 40)),
              ),
              child: Text(turma),
            );
          }).toList(),
        ),
      ),
    );
  }
}
