import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuscarUsuarios extends StatefulWidget {
  final List<int> alunoIds;

  BuscarUsuarios({required this.alunoIds});

  @override
  _BuscarUsuariosState createState() => _BuscarUsuariosState();
}

class _BuscarUsuariosState extends State<BuscarUsuarios> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    buscarUsuarios();
  }

  Future<void> buscarUsuarios() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarUsuarios');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'alunoIds': widget.alunoIds}),
      );

      if (response.statusCode == 200) {
        setState(() {
          usuarios = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar usuários: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar usuários: $e')),
      );
    }
  }

  Future<int?> buscarTurmaDoUsuario(int usuarioId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/buscarTurma/$usuarioId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['turmaId'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar turma: ${response.statusCode}')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar turma: $e')),
      );
      return null;
    }
  }

  Future<void> adicionarPresenca(int usuarioId, int turmaId) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/adicionarPresenca');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuarioId': usuarioId, 'turmaId': turmaId}),
      );

      if (response.statusCode == 200) {
        print('Presença adicionada com sucesso.');
      } else {
        print('Erro ao adicionar presença: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao adicionar presença: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos cadastrados na turma'),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text('Nome: ${usuario['usuario']}'),
            subtitle: Text('Email: ${usuario['email']}'),
            trailing: ElevatedButton(
              onPressed: () async {
                final turmaId = await buscarTurmaDoUsuario(usuario['id']);
                if (turmaId != null) {
                  adicionarPresenca(usuario['id'], turmaId);
                } else {
                  print('Usuário não está associado a uma turma.');
                }
              },
              child: Text('Adicionar presença'),
            ),
          );
        },
      ),
    );
  }
}
