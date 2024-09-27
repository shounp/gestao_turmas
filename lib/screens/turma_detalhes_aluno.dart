import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TurmaScreen extends StatefulWidget {
  final String nome;
  final int usuarioId;
  final int turmaId;

  const TurmaScreen({required this.nome, required this.usuarioId, required this.turmaId});

  @override
  _TurmaScreenState createState() => _TurmaScreenState();
}

class _TurmaScreenState extends State<TurmaScreen> {
  List<Map<String, dynamic>> dados = [];
  List<String> datasPresencas = [];
  String? erroMensagem;

  @override
  void initState() {
    super.initState();
    obterDadosPorNome(widget.nome);
    buscarPresencas(widget.usuarioId, widget.turmaId);
  }

  Future<void> obterDadosPorNome(String nome) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/obterDadosTurma/$nome');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var dadosData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          dados = List<Map<String, dynamic>>.from(dadosData);
        });
      } else {
        setState(() {
          erroMensagem = 'Erro ao obter dados da turma: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        erroMensagem = 'Erro ao obter dados da turma: $e';
      });
    }
  }

  Future<void> buscarPresencas(int usuarioId, int turmaId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarPresencas/$usuarioId/$turmaId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var presencasData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          datasPresencas = presencasData
              .map((item) => formatarData(item['data'].toString()))
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        erroMensagem = 'Erro ao buscar presenças: $e';
      });
    }
  }

  // Função para formatar a data
  String formatarData(String dataISO) {
    DateTime data = DateTime.parse(dataISO);
    return '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
  }

  Future<String> buscarNomeProfessor(int id) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarNomeProfessor/$id');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var professorData = jsonDecode(response.body);
        return professorData['nome'] as String;
      } else {
        setState(() {
          erroMensagem = 'Erro ao buscar nome do professor: ${response.body}';
        });
        return '';
      }
    } catch (e) {
      setState(() {
        erroMensagem = 'Erro ao buscar nome do professor: $e';
      });
      return '';
    }
  }

  // Função para marcar presença
  Future<void> marcarPresenca() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/adicionarPresenca/${widget.usuarioId}/${widget.turmaId}');
      var response = await http.post(url);

      if (response.statusCode == 200) {
        setState(() {
          erroMensagem = 'Presença marcada com sucesso!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença marcada com sucesso!')),
        );
      } else {
        setState(() {
          erroMensagem = 'Erro ao marcar presença: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        erroMensagem = 'Erro de conexão ao marcar presença: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (erroMensagem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erroMensagem!)),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Turma: ${widget.nome}'),
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
      ),
      body: dados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                        subtitle: Text('Carregando informações...'),
                      );
                    }

                    if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Turma: ${item['nome']}'),
                        subtitle: Text('Erro ao buscar nome do professor'),
                      );
                    }

                    final nomeProfessor = snapshot.data ?? 'Desconhecido';

                    final subtitleChildren = <Widget>[
                      Text('Horário: ${item['horario']}'),
                      Text('Professor Responsável: $nomeProfessor'),
                      const SizedBox(height: 8),
                      Text('Chave de Acesso: ${item['chave_acesso']}'),
                      const Divider(),
                      const Text('Minhas Presenças:'),
                      datasPresencas.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: datasPresencas.map((data) => Text('Data: $data')).toList(),
                            )
                          : const Text('Nenhuma presença registrada'),
                      const SizedBox(height: 16),
                      // Botão de Marcar Presença
                      ElevatedButton(
                        onPressed: () {
                          marcarPresenca();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Marcar Presença',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Turma: ${item['nome']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subtitleChildren,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
