import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  _PaginaCadastroState createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String? tipoUsuario;

  Future<void> _realizarCadastro(BuildContext context) async {
    final nome = nomeController.text;
    final email = emailController.text;
    final senha = senhaController.text;

    try {
      var url = Uri.parse('http://192.168.1.2:3000/cadastrarUsuario');  // Substitua pelo IP correto do servidor
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'tipoUsuario': tipoUsuario
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text("Conta criada com sucesso!"),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text("Erro ao criar usuário: ${response.body}"),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFC72C41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text("Erro ao criar usuário: $e"),
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
        title: const Text('CADASTRO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: tipoUsuario,
              onChanged: (String? newValue) {
                setState(() {
                  tipoUsuario = newValue;
                });
              },
              underline: Container(),
              focusColor: Colors.transparent,
              items: <String>['Aluno', 'Professor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Tipo de Usuário'),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _realizarCadastro(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color.fromARGB(255, 31, 15, 97),
              ),
              child: const Text(
                'CADASTRAR',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
