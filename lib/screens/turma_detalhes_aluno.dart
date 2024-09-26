import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TurmaScreen extends StatefulWidget {
  final String nome;

  TurmaScreen({required this.nome});

  @override
  _TurmaScreenState createState() => _TurmaScreenState();
}

class _TurmaScreenState extends State<TurmaScreen> {
  List<Map<String, dynamic>> dados = [];
  List<String> datasPresencas = [];

  @override
  void initState() {
    super.initState();
    obterDadosPorNome(widget.nome);
    buscarPresencas();
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

  Future<void> buscarPresencas() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarPresencas');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var presencasData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          datasPresencas = presencasData.map((item) => item['data'].toString()).toList();
        });
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

              final nomeProfessor = snapshot.data;

              final subtitleChildren = <Widget>[
                Text('Horário: ${item['horario']}'),
                Text('Professor Responsável: $nomeProfessor'),
              ];

              if (datasPresencas.isNotEmpty) {
                subtitleChildren.add(Text('Chave de Acesso: ${item['chave_acesso']}'));
                subtitleChildren.add(Divider());
                subtitleChildren.add(Text('Presenças'));
                subtitleChildren.addAll(
                  datasPresencas.map((data) => Text('Data: $data')).toList(),
                );
              } else {
                subtitleChildren.add(Text('Chave de Acesso: ${item['chave_acesso']}'));
              }

              return ListTile(
                title: Text('Turma: ${item['nome']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subtitleChildren,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
