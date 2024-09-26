import 'package:flutter/material.dart';
import '../utils/db_helper.dart';  // Importando o arquivo onde está a função verificarConexaoDB

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {

  @override
  void initState() {
    super.initState();
    verificarConexaoDB();  // Chamando a função de verificação de conexão ao inicializar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,  // Alterado para usar largura disponível de forma mais eficiente
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/um.jpg'), // Substitua pelo caminho e nome da sua imagem
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Centraliza verticalmente os widgets
          children: <Widget>[
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');  // Navegando para a página de login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 249, 250, 250),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(160),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, color: Color.fromARGB(255, 31, 15, 97)),
                  SizedBox(width: 8),
                  Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 31, 15, 97)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
