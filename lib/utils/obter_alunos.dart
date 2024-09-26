import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> obterAlunosTurma(int turmaId) async {
  try {
    var url = Uri.parse('http://192.168.1.2:3000/obterAlunosTurma');  // Substitua pelo IP correto do servidor
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'turmaId': turmaId}),
    );

    if (response.statusCode == 200) {
      var alunosData = jsonDecode(response.body) as List<dynamic>;
      var alunos = alunosData.map((aluno) => aluno['aluno_id']).toList();
      print(alunos);
    } else {
      print('Erro ao obter alunos da turma: ${response.body}');
    }
  } catch (e) {
    print('Erro ao obter alunos da turma: $e');
  }
}
