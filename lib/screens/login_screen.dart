import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:turmas/screens/teacher_screen.dart';
import './aluno_screen.dart';
import './cadastro_screen.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  String _tipoUsuario = 'Professor';

  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Função de login que faz uma requisição à API para autenticação
  Future<void> login() async {
    final String usuario = _usuarioController.text;
    final String senha = _senhaController.text;

    try {
      var url = Uri.parse('http://192.168.1.2:3000/auth/login');  // Substitua pelo IP correto do seu servidor
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usuario': usuario,
          'senha': senha,
          'tipoUsuario': _tipoUsuario,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Navegar para a tela correta dependendo do tipo de usuário
        if (data['tipoUsuario'] == 'Professor') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaginaProfessor(
                usuario: data['usuario'],
                senha: senha,
                tipoUsuario: _tipoUsuario,
              ),
            ),
          );
        } else if (data['tipoUsuario'] == 'Aluno') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaginaAluno(
                usuario: data['usuario'],
                senha: senha,
                tipoUsuario: _tipoUsuario,
              ),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text("Usuário ou senha incorretos"),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } else {
        throw Exception('Erro ao autenticar: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text("Erro de conexão: $e"),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  // Função de navegação para a tela de cadastro
  void _realizarCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaCadastro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 31, 15, 97),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: DropdownButton<String>(
                value: _tipoUsuario,
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoUsuario = newValue!;
                  });
                },
                focusColor: Colors.transparent,
                underline: Container(),
                items: <String>['Professor', 'Aluno'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Usuário',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500),
                ),
                backgroundColor: const Color.fromARGB(255, 135, 206, 250), // Azul claro
              ),
              onPressed: login,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white), // Texto branco
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: _realizarCadastro,
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Color.fromARGB(255, 135, 206, 250)), // Azul claro para o texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
