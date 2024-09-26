import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

Future<void> verificarConexaoDB() async {
    try {
      var url = Uri.parse('http://192.168.1.2:3000/checkConnection'); // API do backend
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);  // Deverá exibir "Está conectado"
      } else {
        print("Erro: Não foi possível conectar ao banco de dados");
      }
    } catch (e) {
      print("Erro ao conectar ao servidor: $e");
    }
  }


