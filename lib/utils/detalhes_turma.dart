import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> obterDetalhesTurmas(List<int> turmas) async {
  try {
    var url = Uri.parse('http://192.168.1.2:3000/obterDetalhesTurmas');  // Substitua pelo IP correto do servidor
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'turmas': turmas}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Erro ao obter detalhes das turmas: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Erro ao obter detalhes das turmas: $e');
    return [];
  }
}
