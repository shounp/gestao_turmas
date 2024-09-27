import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExcluirPresencaScreen extends StatefulWidget {
  final int turmaId;

  const ExcluirPresencaScreen({super.key, required this.turmaId});

  @override
  _ExcluirPresencaScreenState createState() => _ExcluirPresencaScreenState();
}

class _ExcluirPresencaScreenState extends State<ExcluirPresencaScreen> {
  List<Map<String, dynamic>> presencas = [];

  @override
  void initState() {
    super.initState();
    buscarPresencas();
  }

  Future<void> buscarPresencas() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarPresencasPorTurma/${widget.turmaId}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var presencasData = jsonDecode(response.body) as List<dynamic>;

        // Obter nomes dos usuários e substituir no lugar do ID
        for (var presenca in presencasData) {
          var nomeUsuario = await buscarNomeUsuario(presenca['usuario_id']);
          setState(() {
            presencas.add({
              'id': presenca['id'],
              'nome_usuario': nomeUsuario,
              'data': presenca['data'],
            });
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar presenças: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar presenças: $e')),
      );
    }
  }

  Future<String> buscarNomeUsuario(int usuarioId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarNomeUsuario/$usuarioId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var usuarioData = jsonDecode(response.body);
        return usuarioData['nome'];
      } else {
        return 'Desconhecido';
      }
    } catch (e) {
      return 'Erro';
    }
  }

  Future<void> excluirPresenca(int presencaId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/excluirPresenca/$presencaId');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          presencas.removeWhere((presenca) => presenca['id'] == presencaId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença excluída com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir presença: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir presença: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir Presenças'),
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
      ),
      body: presencas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: presencas.length,
              itemBuilder: (context, index) {
                final presenca = presencas[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Nome: ${presenca['nome_usuario']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data: ${presenca['data']}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        excluirPresenca(presenca['id']);
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
                  ),
                );
              },
            ),
    );
  }
}
