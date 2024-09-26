# Sistema de Gestão de Turmas

Este projeto é uma aplicação em Flutter integrada com um backend em Node.js que permite a gestão de turmas de alunos e professores. Ele inclui funcionalidades como login, cadastro de usuários, adição e listagem de turmas, e registro de presença dos alunos.

## Estrutura do projeto

* Tela de login: Os usuários (professores e alunos) podem fazer login com suas credenciais.
* Página do Professor: Permite que os professores criem novas turmas e acessem suas turmas existentes.
* Página do Aluno: Permite que os alunos acessem suas turmas e registrem sua presença.
* Listagem de Turmas: Professores podem acessar as turmas que criaram, e os alunos podem visualizar as turmas em que estão matriculados.

## Backend: Node.js com Express

* API RESTful: Usada para autenticação, criação de usuários, gestão de turmas e registro de presença.
* Banco de Dados MySQL: Armazena informações sobre usuários, turmas e presenças.

## Funcionalidades

### 1. Login e Autenticação
* Professores e alunos podem fazer login utilizando nome de usuário e senha.
* Verificação de credenciais via requisição à API em Node.js.

### 2. Gestão de Usuários
* Professores podem criar turmas.
* Alunos podem se inscrever em turmas e registrar presença.

### 3. Gestão de Turmas
* Professores podem visualizar as turmas que criaram e alunos podem acessar as turmas às quais estão inscritos.
* Listagem dinâmica das turmas no frontend, utilizando requisições HTTP para o backend.

### 4. Registro de Presença
* Alunos podem registrar presença em turmas específicas.
* As informações são armazenadas no banco de dados MySQL.

## Como rodar o projeto

### Pré-requisitos
* Flutter (versão mínima 2.x)
* Node.js (versão mínima 14.x)
* MySQL (configurado e rodando)

### Instalação do backend

#### 1. Clone o repositório:

```bash
git clone https://github.com/seuusuario/nome-do-repositorio.git
```

#### 2. Instale as dependências do Node.js:

```bash
cd backend
npm install
```

#### 3.Configure o banco de dados MySQL:

* Crie um banco de dados chamado turmas_db
* Crie as tabelas necessárias através do seguinte comando:

```bash
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario VARCHAR(255),
  email VARCHAR(255),
  senha VARCHAR(255),
  tipoUsuario ENUM('Aluno', 'Professor')
);

CREATE TABLE turmas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255),
  professor_responsavel INT,
  horario VARCHAR(255),
  chave_acesso VARCHAR(255)
);

CREATE TABLE alunos_turmas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  aluno_id INT,
  turma_id INT
);

CREATE TABLE presenca (
  id INT AUTO_INCREMENT PRIMARY KEY,
  data DATE,
  presenca BOOLEAN,
  usuario_id INT,
  turma_id INT
);
```

#### 4.Execute o servidor Node.js:

```bash
npm start
```

Obs: o backend estará rodando em http://localhost:3000

### Instalação do Frontend

#### 1. No diretório raiz, instale as dependências:

Execute o seguinte comando na pasta raiz do projeto:

```bash
flutter pub get
```

#### 2. Inicie o aplicativo flutter:

Ainda na pasta raiz do projeto execute o seguinte comando:

```bash
flutter run
```

## Endpoints da API

### Autenticação

* POST /verifyUserCredentials - Verifica as credenciais do usuário.

* * Body:

```bash
{
  "username": "string",
  "password": "string",
  "tipoUsuario": "Aluno" | "Professor"
}
```

* POST /getUserId - Retorna o ID do usuário.

* * Body:
```bash
{
  "username": "string",
  "password": "string",
  "tipoUsuario": "Aluno" | "Professor"
}
```

### Turmas

* GET /getTurmas/:usuarioId - Retorna as turmas associadas ao usuário.
* POST /adicionarPresenca - Adiciona a presença de um aluno em uma turma.


## Contribuições 

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou fazer um pull request.

## Licença 

Este projeto está licenciado sob a MIT License.