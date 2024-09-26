// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:turmas/screens/teacher_screen.dart';
import '../utils/auth.dart';
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

  Future <void> login() async {
  final String usuario = _usuarioController.text;
  final String senha = _senhaController.text;

  final dbHelper = DatabaseHelper();
  int? usuarioId = await dbHelper.getUserId(usuario, senha, _tipoUsuario);  // Usando o novo método getUserId

  if (usuarioId != null) {
    if (_tipoUsuario == 'Professor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaginaProfessor(usuario: usuario)),  // Passando o nome do usuário
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaginaAluno(usuario: usuario)),  // Passando o nome do usuário
      );
    }
  } else {
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
          child: const Text("Usuário e senha não encontrados"),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}



  void _realizarCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  const PaginaCadastro()),
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
                items: <String>['Professor', 'Aluno']
                    .map<DropdownMenuItem<String>>((String value) {
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
                  backgroundColor: const Color.fromARGB(255, 31, 15, 97),
                  
                ),
                onPressed: login,
                child: const Text('Login'),
              
                  
                ),
              
          
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: _realizarCadastro,
              child: const Text('Cadastrar', style: TextStyle(color: Color.fromARGB(255, 31, 15, 97)),),
            ),
          ],
        ),
      ),
    );
  }
}
