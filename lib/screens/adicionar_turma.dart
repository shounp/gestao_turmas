import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaAdicionarAlunoTurma extends StatefulWidget {
  final String usuario;

  const PaginaAdicionarAlunoTurma({super.key, required this.usuario});

  @override
  _PaginaAdicionarAlunoTurmaState createState() => _PaginaAdicionarAlunoTurmaState();
}

class _PaginaAdicionarAlunoTurmaState extends State<PaginaAdicionarAlunoTurma> {
  final TextEditingController codigoAcessoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
        title: const Text('Adicionar Aluno à Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: codigoAcessoController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
                labelText: 'Código de Acesso',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final codigoAcesso = codigoAcessoController.text;
                try {
                  // Faz a requisição HTTP para a API
                  var url = Uri.parse('http://192.168.1.2:3000/adicionarAlunoTurma');
                  var response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'usuario': widget.usuario, 'codigoAcesso': codigoAcesso}),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Aluno adicionado à turma com sucesso!"),
                      ),
                    );
                  } else if (response.statusCode == 404) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Código de acesso inválido"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erro ao adicionar aluno à turma"),
                      ),
                    );
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
                        child: Text("Erro ao adicionar aluno à turma: $e"),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 31, 15, 97)),
                minimumSize: MaterialStateProperty.all(const Size(210, 50)),
              ),
              child: const Text('Adicionar Aluno à Turma'),
            ),
          ],
        ),
      ),
    );
  }
}
