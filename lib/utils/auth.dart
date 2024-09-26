import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  // Método para verificar as credenciais do usuário
  Future<bool> verifyUserCredentials(String username, String password, String tipoUsuario) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/verifyUserCredentials');  // Substitua pelo IP correto do servidor
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'tipoUsuario': tipoUsuario,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['valid'] as bool;
      } else {
        print('Erro ao verificar credenciais: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao verificar credenciais: $e');
      return false;
    }
  }

  // Novo método para obter o ID do usuário
  Future<int?> getUserId(String username, String password, String tipoUsuario) async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/getUserId');  // Endpoint para obter o ID do usuário
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'tipoUsuario': tipoUsuario,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['userId'] as int;  // Retorna o ID do usuário
      } else {
        print('Erro ao obter ID do usuário: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro ao obter ID do usuário: $e');
      return null;
    }
  }
}
