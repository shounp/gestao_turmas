// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './turma_screen.dart';

class AcessarTurmasAluno extends StatefulWidget {
  final String usuario;

  const AcessarTurmasAluno({super.key, required this.usuario});

  @override
  _AcessarTurmasAlunoState createState() => _AcessarTurmasAlunoState();
}

class _AcessarTurmasAlunoState extends State<AcessarTurmasAluno> {
  List<String> turmas = []; // Lista de turmas do usuário

  @override
  void initState() {
    super.initState();
    obterTurmasUsuario();
  }

  Future<void> obterTurmasUsuario() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/getTurmas/${widget.usuario}'); // Substitua pelo IP do seu backend
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var turmasData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          turmas = turmasData.map((turma) => turma['nome'] as String).toList();
        });
      } else {
        print('Erro ao obter turmas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de conexão: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFC72C41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text("Erro ao obter turmas do usuário: $e"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
