import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './turma_detalhes_aluno.dart';

class AcessarTurmasAluno extends StatefulWidget {
  final String usuario;
  final String senha;
  final String tipoUsuario;

  const AcessarTurmasAluno({
    super.key, 
    required this.usuario,
    required this.senha,
    required this.tipoUsuario,
  });

  @override
  _AcessarTurmasAlunoState createState() => _AcessarTurmasAlunoState();
}

class _AcessarTurmasAlunoState extends State<AcessarTurmasAluno> {
  List<Map<String, dynamic>> turmas = [];
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    obterUsuarioId(); // Buscar o usuarioId
  }

  // Função para obter o ID do usuário
  Future<void> obterUsuarioId() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/getUserId');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': widget.usuario,
          'password': widget.senha,
          'tipoUsuario': widget.tipoUsuario
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          usuarioId = data['userId'];
        });
        obterTurmasUsuario(); // Agora que o usuarioId foi obtido, buscar as turmas
      } else {
        print('Erro ao obter ID do usuário: ${response.statusCode}');
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
            child: Text("Erro ao obter ID do usuário: $e"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  // Função para buscar as turmas do usuário no servidor
  Future<void> obterTurmasUsuario() async {
    if (usuarioId == null) return;

    try {
      var url = Uri.parse('http://192.168.1.2:3000/getTurmasPorAluno/$usuarioId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var turmasData = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          turmas = turmasData.map((turma) {
            return {
              'turma_id': turma['id'], // O ID da turma
              'nome': turma['nome'],
              'professor_responsavel': turma['professor_responsavel'],
              'horario': turma['horario'],
              'chave_acesso': turma['chave_acesso'],
            };
          }).toList();
          print(turmas); // Exibir o conteúdo das turmas para garantir que está correto
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
      body: usuarioId == null
          ? const Center(child: CircularProgressIndicator()) // Exibe o indicador de carregamento enquanto o usuário ID é carregado
          : Container(
              alignment: Alignment.center,
              child: turmas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma turma encontrada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: turmas.length,
                      itemBuilder: (context, index) {
                        final turma = turmas[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: ListTile(
                            title: Text(turma['nome'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Professor: ${turma['professor_responsavel']}'),
                                Text('Horário: ${turma['horario']}'),
                                Text('Chave de Acesso: ${turma['chave_acesso']}'),
                              ],
                            ),
                            onTap: () {
                              if (usuarioId != null && turma['turma_id'] != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TurmaScreen(
                                      nome: turma['nome'],
                                      usuarioId: usuarioId!,
                                      turmaId: turma['turma_id'], // Garantindo que a chave correta seja 'turma_id'
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Erro: Usuário ou turma não identificados")),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
