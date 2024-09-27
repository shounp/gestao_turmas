const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');  // Para habilitar requisições de diferentes origens

const app = express();
const port = 3000;

// Habilitar CORS
app.use(cors());
app.use(express.json());

// Conexão com o MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'teste'
});

app.get('/checkConnection', (req, res) => {
  db.connect((err) => {
    if (err) {
      res.status(500).send('Erro ao conectar ao banco de dados');
    } else {
      res.send('Está conectado');
    }
  });
});

// Rota para obter o ID do usuário
app.get('/getUserId/:username', (req, res) => {
  const username = req.params.username;

  db.query('SELECT id FROM usuarios WHERE usuario = ? LIMIT 1', [username], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar o usuário');
    }

    if (results.length > 0) {
      res.json({ userId: results[0].id });
    } else {
      res.status(404).json({ message: 'Usuário não encontrado' });
    }
  });
});

// Rota para obter as turmas do usuário
app.get('/getTurmas/:username', (req, res) => {
  const username = req.params.username;

  // Primeiro, obtenha o ID do usuário
  db.query('SELECT id FROM usuarios WHERE usuario = ? LIMIT 1', [username], (err, userResults) => {
    if (err) {
      return res.status(500).send('Erro ao buscar o usuário');
    }

    if (userResults.length === 0) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }

    const userId = userResults[0].id;

    // Agora obtenha as turmas do usuário
    db.query('SELECT turma_id FROM alunos_turmas WHERE aluno_id = ?', [userId], (err, turmaResults) => {
      if (err) {
        return res.status(500).send('Erro ao buscar turmas');
      }

      if (turmaResults.length === 0) {
        return res.status(404).json({ message: 'Nenhuma turma encontrada' });
      }

      const turmaIds = turmaResults.map(row => row.turma_id);

      // Finalmente, obtenha os detalhes das turmas
      db.query('SELECT nome FROM turmas WHERE id IN (?)', [turmaIds], (err, turmaDetalhes) => {
        if (err) {
          return res.status(500).send('Erro ao buscar detalhes das turmas');
        }

        res.json(turmaDetalhes);
      });
    });
  });
});

// Rota para adicionar aluno à turma
app.post('/adicionarAlunoTurma', (req, res) => {
  const { usuario, codigoAcesso } = req.body;

  // Primeiro, obtenha o ID do aluno pelo nome de usuário
  db.query('SELECT id FROM usuarios WHERE usuario = ? LIMIT 1', [usuario], (err, userResults) => {
    if (err) {
      return res.status(500).send('Erro ao buscar o usuário');
    }

    if (userResults.length === 0) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }

    const alunoId = userResults[0].id;

    // Agora, verifique se o código de acesso da turma é válido
    db.query('SELECT id FROM turmas WHERE chave_acesso = ? LIMIT 1', [codigoAcesso], (err, turmaResults) => {
      if (err) {
        return res.status(500).send('Erro ao buscar a turma');
      }

      if (turmaResults.length === 0) {
        return res.status(404).json({ message: 'Código de acesso inválido' });
      }

      const turmaId = turmaResults[0].id;

      // Inserir o aluno na turma
      db.query('INSERT INTO alunos_turmas (aluno_id, turma_id) VALUES (?, ?)', [alunoId, turmaId], (err, results) => {
        if (err) {
          return res.status(500).send('Erro ao adicionar aluno à turma');
        }

        res.status(200).json({ message: 'Aluno adicionado à turma com sucesso' });
      });
    });
  });
});

// Rota para buscar usuários por IDs
app.post('/buscarUsuarios', (req, res) => {
  const { alunoIds } = req.body;

  if (!alunoIds || alunoIds.length === 0) {
    return res.status(400).send('Lista de IDs de alunos não fornecida.');
  }

  const placeholders = alunoIds.map(() => '?').join(', ');

  db.query(`SELECT * FROM usuarios WHERE id IN (${placeholders})`, alunoIds, (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar usuários');
    }

    res.status(200).json(results);
  });
});

// Rota para buscar a turma de um usuário
app.get('/buscarTurma/:usuarioId', (req, res) => {
  const usuarioId = req.params.usuarioId;

  db.query('SELECT turma_id FROM alunos_turmas WHERE aluno_id = ?', [usuarioId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar turma do usuário');
    }

    if (results.length === 0) {
      return res.status(404).send('Usuário não está associado a nenhuma turma.');
    }

    res.status(200).json({ turmaId: results[0].turma_id });
  });
});

app.post('/adicionarPresenca/:usuarioId/:turmaId', (req, res) => {
  const { usuarioId, turmaId } = req.params;

  if (!usuarioId || !turmaId) {
    return res.status(400).send('IDs do usuário e turma não fornecidos.');
  }

  const dataAtual = new Date().toISOString().slice(0, 19).replace('T', ' ');

  // Corrigido: removido o campo "id", que será gerado automaticamente
  db.query(
    'INSERT INTO presenca (data, presenca, usuario_id, turma_id) VALUES (?, ?, ?, ?)',
    [dataAtual, true, usuarioId, turmaId],
    (err) => {
      if (err) {
        return res.status(500).send('Erro ao adicionar presença.');
      }

      res.status(200).send('Presença adicionada com sucesso.');
    }
  );
});





app.get('/obterAlunosTurma/:turmaId', (req, res) => {
  const turmaId = req.params.turmaId;

  db.query(
    'SELECT u.id as aluno_id, u.usuario as nome FROM alunos_turmas at JOIN usuarios u ON at.aluno_id = u.id WHERE at.turma_id = ?',
    [turmaId],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao buscar alunos da turma.');
      }

      if (results.length === 0) {
        return res.status(404).send('Nenhum aluno encontrado para esta turma.');
      }

      res.status(200).json(results);
    }
  );
});


// Rota para cadastrar usuário
app.post('/cadastrarUsuario', (req, res) => {
  const { nome, email, senha, tipoUsuario } = req.body;

  if (!nome || !email || !senha || !tipoUsuario) {
    return res.status(400).send('Todos os campos são obrigatórios.');
  }

  db.query(
    'INSERT INTO usuarios (usuario, email, senha, tipoUsuario) VALUES (?, ?, ?, ?)',
    [nome, email, senha, tipoUsuario],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao criar o usuário.');
      }

      res.status(200).send('Usuário criado com sucesso.');
    }
  );
});

// Rota para adicionar uma turma
app.post('/adicionarTurma', (req, res) => {
  const { nome, professor, horarios, chaveAcesso } = req.body;

  if (!nome || !professor || !horarios || !chaveAcesso) {
    return res.status(400).send('Todos os campos são obrigatórios.');
  }

  // Verificar se o professor existe no banco de dados
  db.query('SELECT id FROM usuarios WHERE usuario = ? LIMIT 1', [professor], (err, professorResults) => {
    if (err) {
      return res.status(500).send('Erro ao buscar o professor.');
    }

    if (professorResults.length === 0) {
      return res.status(404).send('Professor não encontrado.');
    }

    const idProf = professorResults[0].id;

    // Inserir a nova turma no banco de dados
    db.query(
      'INSERT INTO turmas (nome, professor_responsavel, horario, chave_acesso) VALUES (?, ?, ?, ?)',
      [nome, idProf, horarios, chaveAcesso],
      (err, results) => {
        if (err) {
          return res.status(500).send('Erro ao adicionar a turma.');
        }

        res.status(200).send('Turma adicionada com sucesso.');
      }
    );
  });
});

// Rota para adicionar presença
app.post('/adicionarPresenca', (req, res) => {
  const { usuarioId, turmaId } = req.body;

  if (!usuarioId || !turmaId) {
    return res.status(400).send('IDs do usuário e da turma são obrigatórios.');
  }

  const dataAtual = new Date().toISOString().slice(0, 19).replace('T', ' ');

  db.query(
    'INSERT INTO presenca (data, presenca, usuario_id, turma_id) VALUES (?, ?, ?, ?)',
    [dataAtual, true, usuarioId, turmaId],
    (err) => {
      if (err) {
        return res.status(500).send('Erro ao adicionar presença.');
      }

      res.status(200).send('Presença adicionada com sucesso.');
    }
  );
});

// Rota para obter alunos de uma turma específica
app.get('/obterAlunosTurma/:turmaId', (req, res) => {
  const turmaId = req.params.turmaId;

  db.query('SELECT aluno_id FROM alunos_turmas WHERE turma_id = ?', [turmaId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao obter alunos da turma.');
    }

    if (results.length === 0) {
      return res.status(404).send('Nenhum aluno encontrado para esta turma.');
    }

    res.status(200).json(results);
  });
});

// Rota para obter os dados da turma por nome
app.get('/obterDadosTurma/:nome', (req, res) => {
  const nome = req.params.nome;

  db.query('SELECT * FROM turmas WHERE nome = ?', [nome], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar os dados da turma.');
    }

    res.status(200).json(results);
  });
});

// Rota para buscar presenças
app.get('/buscarPresencas/:usuarioId/:turmaId', (req, res) => {
  const { usuarioId, turmaId } = req.params;

  db.query(
    'SELECT * FROM presenca WHERE usuario_id = ? AND turma_id = ? AND presenca = 1',
    [usuarioId, turmaId],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao buscar presenças.');
      }

      if (results.length === 0) {
        return res.status(404).json({ message: 'Nenhuma presença encontrada para o usuário nesta turma.' });
      }

      res.status(200).json(results);
    }
  );
});


// Rota para buscar o nome do professor pelo ID
app.get('/buscarNomeProfessor/:id', (req, res) => {
  const professorId = req.params.id;

  db.query('SELECT usuario FROM usuarios WHERE id = ?', [professorId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar nome do professor.');
    }

    if (results.length === 0) {
      return res.status(404).send('Professor não encontrado.');
    }

    res.status(200).json({ nome: results[0].usuario });
  });
});

// Rota para obter os dados da turma por nome
app.get('/obterDadosTurma/:nome', (req, res) => {
  const nome = req.params.nome;

  db.query('SELECT * FROM turmas WHERE nome = ?', [nome], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar os dados da turma.');
    }

    res.status(200).json(results);
  });
});

// Rota para buscar o nome do professor pelo ID
app.get('/buscarNomeProfessor/:id', (req, res) => {
  const professorId = req.params.id;

  db.query('SELECT usuario FROM usuarios WHERE id = ?', [professorId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar nome do professor.');
    }

    if (results.length === 0) {
      return res.status(404).send('Professor não encontrado.');
    }

    res.status(200).json({ nome: results[0].usuario });
  });
});

// Rota para obter turmas do professor
app.get('/obterTurmasProfessor/:usuario', (req, res) => {
  const usuario = req.params.usuario;

  // Obter o ID do professor pelo nome de usuário
  db.query('SELECT id FROM usuarios WHERE usuario = ?', [usuario], (err, professorResults) => {
    if (err) {
      return res.status(500).send('Erro ao buscar o professor.');
    }

    if (professorResults.length === 0) {
      return res.status(404).send('Professor não encontrado.');
    }

    const professorId = professorResults[0].id;

    // Agora buscar as turmas do professor
    db.query('SELECT nome FROM turmas WHERE professor_responsavel = ?', [professorId], (err, turmaResults) => {
      if (err) {
        return res.status(500).send('Erro ao buscar turmas.');
      }

      res.status(200).json(turmaResults);
    });
  });
});

// Rota para verificar as credenciais do usuário
app.post('/verifyUserCredentials', (req, res) => {
  const { username, password, tipoUsuario } = req.body;

  db.query(
    'SELECT COUNT(*) as count FROM usuarios WHERE usuario = ? AND senha = ? AND tipoUsuario = ?',
    [username, password, tipoUsuario],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao verificar credenciais.');
      }

      const isValid = results[0].count > 0;
      res.status(200).json({ valid: isValid });
    }
  );
});

// Rota para obter detalhes das turmas
app.post('/obterDetalhesTurmas', (req, res) => {
  const { turmas } = req.body;

  if (!turmas || !Array.isArray(turmas) || turmas.length === 0) {
    return res.status(400).send('Lista de turmas inválida.');
  }

  const placeholders = turmas.map(() => '?').join(', ');

  db.query(`SELECT id, nome FROM turmas WHERE id IN (${placeholders})`, turmas, (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao obter detalhes das turmas.');
    }

    res.status(200).json(results);
  });
});

// Rota para obter alunos da turma
app.post('/obterAlunosTurma', (req, res) => {
  const { turmaId } = req.body;

  if (!turmaId) {
    return res.status(400).send('ID da turma é obrigatório.');
  }

  db.query('SELECT aluno_id FROM alunos_turmas WHERE turma_id = ?', [turmaId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar alunos da turma.');
    }

    res.status(200).json(results);
  });
});

app.post('/getUserId', (req, res) => {
  const { username, password, tipoUsuario } = req.body;

  db.query(
    'SELECT id FROM usuarios WHERE usuario = ? AND senha = ? AND tipoUsuario = ? LIMIT 1',
    [username, password, tipoUsuario],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao buscar o ID do usuário.');
      }

      if (results.length > 0) {
        res.status(200).json({ userId: results[0].id });  // Envia o ID do usuário encontrado
      } else {
        res.status(404).send('Usuário não encontrado.');
      }
    }
  );
});

app.get('/getTurmasPorAluno/:userId', (req, res) => {
  const userId = req.params.userId;

  // Passo 1: Buscar as turmas relacionadas ao ID do aluno
  db.query('SELECT turma_id FROM alunos_turmas WHERE aluno_id = ?', [userId], (err, turmaResults) => {
    if (err) {
      return res.status(500).send('Erro ao buscar turmas relacionadas ao aluno');
    }

    if (turmaResults.length === 0) {
      return res.status(404).json({ message: 'Nenhuma turma encontrada para o aluno' });
    }

    // Exibir os IDs das turmas para debug
    const turmaIds = turmaResults.map(row => row.turma_id);
    console.log('Turmas encontradas para o aluno:', turmaIds);  // Log para debug

    // Passo 2: Buscar informações das turmas com base nos IDs
    db.query('SELECT id, nome, chave_acesso, professor_responsavel, horario FROM turmas WHERE id IN (?)', [turmaIds], (err, turmaDetalhes) => {
      if (err) {
        return res.status(500).send('Erro ao buscar detalhes das turmas');
      }

      if (turmaDetalhes.length === 0) {
        return res.status(404).json({ message: 'Nenhuma turma encontrada com os IDs fornecidos' });
      }

      // Exibir os detalhes das turmas para debug
      console.log('Detalhes das turmas encontradas:', turmaDetalhes);  // Log para debug

      const resultadoFinal = turmaDetalhes.map(turma => ({
        id: turma.id,
        nome: turma.nome,
        chave_acesso: turma.chave_acesso,
        professor_responsavel: turma.professor_responsavel,
        horario: turma.horario
      }));

      return res.status(200).json(resultadoFinal);
    });
  });
});


app.get('/getTurmaPorNome/:nome', (req, res) => {
  const nomeTurma = req.params.nome;

  // Buscar o ID da turma com base no nome
  db.query('SELECT id, nome, chave_acesso, professor_responsavel, horario FROM turmas WHERE nome = ?', [nomeTurma], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar turma pelo nome');
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Turma não encontrada' });
    }

    const turmaDetalhes = results.map(turma => ({
      id: turma.id,
      nome: turma.nome,
      chave_acesso: turma.chave_acesso,
      professor_responsavel: turma.professor_responsavel,
      horario: turma.horario
    }));

    return res.status(200).json(turmaDetalhes);
  });
});



// Rota para buscar presenças de um usuário específico em uma turma
app.get('/buscarPresencas/:usuarioId/:turmaId', (req, res) => {
  const { usuarioId, turmaId } = req.params;

  db.query(
    'SELECT data FROM presenca WHERE usuario_id = ? AND turma_id = ? AND presenca = 1',
    [usuarioId, turmaId],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao buscar presenças.');
      }

      if (results.length === 0) {
        return res.status(404).json({ message: 'Nenhuma presença encontrada para o usuário nesta turma.' });
      }

      res.status(200).json(results);
    }
  );
});

app.get('/buscarPresencas/:usuarioId/:turmaId', (req, res) => {
  const { usuarioId, turmaId } = req.params;

  db.query(
    'SELECT * FROM presenca WHERE usuario_id = ? AND turma_id = ? AND presenca = 1',
    [usuarioId, turmaId],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao buscar presenças.');
      }

      if (results.length === 0) {
        return res.status(404).send('Nenhuma presença encontrada para este aluno nesta turma.');
      }

      res.status(200).json(results);
    }
  );
});

app.post('/auth/login', (req, res) => {
  const { usuario, senha, tipoUsuario } = req.body;

  db.query(
    'SELECT id, usuario, tipoUsuario FROM usuarios WHERE usuario = ? AND senha = ? AND tipoUsuario = ? LIMIT 1',
    [usuario, senha, tipoUsuario],
    (err, results) => {
      if (err) {
        return res.status(500).send('Erro ao autenticar o usuário.');
      }

      if (results.length > 0) {
        // Autenticação bem-sucedida, retornando os dados do usuário
        const user = results[0];
        res.status(200).json({
          userId: user.id,
          usuario: user.usuario,
          tipoUsuario: user.tipoUsuario,
        });
      } else {
        // Usuário ou senha incorretos
        res.status(401).json({ message: 'Usuário ou senha incorretos.' });
      }
    }
  );
});

// Rota para buscar presenças por turma
app.get('/buscarPresencasPorTurma/:turmaId', (req, res) => {
  const turmaId = req.params.turmaId;

  db.query('SELECT * FROM presenca WHERE turma_id = ?', [turmaId], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Erro ao buscar presenças.', error: err });
    }

    res.status(200).json(results);
  });
});

// Rota para excluir presença por ID
app.delete('/excluirPresenca/:presencaId', (req, res) => {
  const presencaId = req.params.presencaId;

  db.query('DELETE FROM presenca WHERE id = ?', [presencaId], (err) => {
    if (err) {
      return res.status(500).json({ message: 'Erro ao excluir presença.', error: err });
    }

    res.status(200).send('Presença excluída com sucesso.');
  });
});


app.get('/buscarNomeUsuario/:usuarioId', (req, res) => {
  const usuarioId = req.params.usuarioId;

  db.query('SELECT usuario FROM usuarios WHERE id = ?', [usuarioId], (err, results) => {
    if (err) {
      return res.status(500).send('Erro ao buscar nome do usuário.');
    }

    if (results.length === 0) {
      return res.status(404).send('Usuário não encontrado.');
    }

    res.status(200).json({ nome: results[0].usuario });
  });
});


// Inicializar o servidor
app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
