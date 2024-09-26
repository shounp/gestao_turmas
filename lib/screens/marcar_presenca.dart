import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> adicionarPresenca(int usuarioId, int turmaId) async {
  try {
    var url = Uri.parse('http://192.168.1.2:3000/adicionarPresenca');  // Substitua pelo IP correto do servidor
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuarioId': usuarioId,
        'turmaId': turmaId,
      }),
    );

    if (response.statusCode == 200) {
      print('Presença adicionada com sucesso.');
    } else {
      print('Erro ao adicionar presença: ${response.body}');
    }
  } catch (e) {
    print('Erro ao adicionar presença: $e');
  }
}
