import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'marcar_presenca.dart'; // Importar a tela para marcar presença
import 'excluir_presenca.dart'; // Importar a tela para excluir presenças

class PaginaAcessarTurmas extends StatefulWidget {
  final String usuario;

  const PaginaAcessarTurmas({super.key, required this.usuario});

  @override
  _PaginaAcessarTurmasState createState() => _PaginaAcessarTurmasState();
}

class _PaginaAcessarTurmasState extends State<PaginaAcessarTurmas> {
  List<Map<String, dynamic>> turmas = []; // Lista de turmas com informações detalhadas

  @override
  void initState() {
    super.initState();
    obterTurmasUsuario();
  }

  Future<void> obterTurmasUsuario() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterTurmasProfessor/${widget.usuario}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var turmasData = jsonDecode(response.body) as List<dynamic>;

        for (var turma in turmasData) {
          await obterDetalhesTurma(turma['nome']);
        }
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

  Future<void> obterDetalhesTurma(String nome) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/getTurmaPorNome/$nome');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var turmaDetalhes = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          turmas.addAll(turmaDetalhes.map((turma) => {
            'nome': turma['nome'],
            'horario': turma['horario'],
            'professor_responsavel': turma['professor_responsavel'],
            'chave_acesso': turma['chave_acesso'],
            'id': turma['id'],
          }));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter detalhes da turma: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter detalhes da turma: $e')),
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
      body: turmas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: turmas.length,
              itemBuilder: (context, index) {
                final turma = turmas[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          turma['nome'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Horário: ${turma['horario']}', style: const TextStyle(fontSize: 14)),
                            Text('Professor Responsável: ${turma['professor_responsavel']}', style: const TextStyle(fontSize: 14)),
                            Text('Chave de Acesso: ${turma['chave_acesso']}', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botão de Adicionar Presença
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MarcarPresencaScreen(turmaId: turma['id']),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300], // Cor azul claro
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Marcar Presença',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Cor branca do texto
                              ),
                            ),
                          ),
                          // Botão de Remover Presença
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExcluirPresencaScreen(turmaId: turma['id']),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.red[200]; // Cor quando o botão está pressionado
                                } else if (states.contains(MaterialState.hovered)) {
                                  return Colors.red[200]; // Cor quando o mouse passa sobre o botão
                                }
                                return Colors.red[900]; // Cor padrão (vermelho escuro)
                              }),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Remover Presença',
                              style: TextStyle(color: Colors.white), // Cor do texto
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
