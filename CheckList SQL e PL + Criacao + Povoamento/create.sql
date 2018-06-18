DROP TABLE Aula;
DROP TABLE Cursa;
DROP TABLE Projeto;
DROP TABLE Ic;
DROP TABLE Sala;
DROP TABLE Disciplina;
DROP TABLE Email;
DROP TABLE Professor;
DROP TABLE Aluno;
DROP TABLE Endereco;
DROP TABLE Licenciatura;
DROP TABLE Bacharelado;
DROP TABLE Curso;

-------------------------

CREATE TABLE Curso (
	codigo NUMBER,
	nome VARCHAR2(30) NOT NULL,
	nota_mec NUMBER(4,2),
	CONSTRAINT curso_pk PRIMARY KEY (codigo),
	CONSTRAINT curso_ck CHECK (nota_mec >= 0 AND nota_mec <= 10)
);

CREATE TABLE Bacharelado (
	codigo NUMBER,
	linha_de_pesquisa VARCHAR2(30),
	CONSTRAINT bacharelado_pk PRIMARY KEY (codigo),
	CONSTRAINT bacharelado_fk FOREIGN KEY (codigo) REFERENCES Curso(codigo)
);

CREATE TABLE Licenciatura (
	codigo NUMBER,
	disciplinas_obrigatorias VARCHAR2(30),
	CONSTRAINT licenciatura_pk PRIMARY KEY (codigo),
	CONSTRAINT licenciatura_fk FOREIGN KEY (codigo) REFERENCES Curso(codigo)
);

CREATE TABLE Endereco (
	cep NUMBER,
	descricao VARCHAR2(30),
	CONSTRAINT endereco_pk PRIMARY KEY (cep)
);

CREATE TABLE Aluno (
	cpf_aluno NUMBER,
	data_nasc DATE NOT NULL,
	codigo_curso NUMBER NOT NULL,
	cpf_padrinho NUMBER,			-- Cannot be not null, because of the insert
	nome VARCHAR2(30) NOT NULL,
	cep NUMBER NOT NULL,
	CONSTRAINT aluno_pk PRIMARY KEY (cpf_aluno),
	CONSTRAINT aluno_fk1 FOREIGN KEY (cpf_padrinho) REFERENCES Aluno(cpf_aluno),
	CONSTRAINT aluno_fk2 FOREIGN KEY (codigo_curso) REFERENCES Curso(codigo),
	CONSTRAINT aluno_fk3 FOREIGN KEY (cep) REFERENCES Endereco(cep)
);

CREATE TABLE Professor (
	cpf_professor NUMBER,
	data_nasc DATE NOT NULL,
	nome VARCHAR2(30) NOT NULL,
	CONSTRAINT professor_pk PRIMARY KEY (cpf_professor)
);

CREATE TABLE Email (
	email VARCHAR2(30),
	cpf_professor NUMBER,
	CONSTRAINT email_pk PRIMARY KEY (email, cpf_professor),
	CONSTRAINT email_fk FOREIGN KEY (cpf_professor) REFERENCES Professor(cpf_professor)
);

CREATE TABLE Disciplina (
	codigo_disc NUMBER,
	qnt_alunos NUMBER,				-- We'll can update this info later, when inserting in table Cursa
	cpf_professor NUMBER NOT NULL,
	nome VARCHAR2(30)  NOT NULL,
	CONSTRAINT disciplina_pk PRIMARY KEY (codigo_disc),
	CONSTRAINT disciplina_fk FOREIGN KEY (cpf_professor) REFERENCES Professor(cpf_professor)
);

CREATE TABLE Sala (
	codigo NUMBER,
	capacidade NUMBER NOT NULL,
	centro VARCHAR2(30) NOT NULL,
	CONSTRAINT sala_pk PRIMARY KEY (codigo)
);

CREATE TABLE Ic (
	codigo NUMBER,
	data_inic DATE NOT NULL,
	tema VARCHAR2(100) NOT NULL,
	cpf_aluno NUMBER UNIQUE NOT NULL,
	CONSTRAINT ic_pk PRIMARY KEY (codigo),
	CONSTRAINT ic_fk FOREIGN KEY (cpf_aluno) REFERENCES Aluno(cpf_aluno)
);

CREATE TABLE Projeto (
	cpf_professor NUMBER,
	titulo VARCHAR2(100) NOT NULL,
	descricao VARCHAR2(200) NOT NULL,
	investimento NUMBER(10,2) NOT NULL,
	CONSTRAINT projeto_pk PRIMARY KEY (cpf_professor),
	CONSTRAINT projeto_fk FOREIGN KEY (cpf_professor) REFERENCES Professor(cpf_professor)
);

CREATE TABLE Cursa (
	cpf_aluno NUMBER,
	codigo_disc NUMBER,
	media NUMBER(4,2) NOT NULL,
	CONSTRAINT cursa_pk PRIMARY KEY (cpf_aluno, codigo_disc),
	CONSTRAINT cursa_fk1 FOREIGN KEY (cpf_aluno) REFERENCES Aluno(cpf_aluno),
	CONSTRAINT cursa_fk2 FOREIGN KEY (codigo_disc) REFERENCES Disciplina(codigo_disc),
	CONSTRAINT cursa_ck CHECK (media >= 0 AND media <= 10)
);

CREATE TABLE Aula (
	codigo_sala NUMBER,
	cpf_aluno NUMBER,
	cpf_professor NUMBER,
	horario TIMESTAMP,
	CONSTRAINT aula_pk PRIMARY KEY (codigo_sala, cpf_aluno, cpf_professor, horario),
	CONSTRAINT aula_fk1 FOREIGN KEY (codigo_sala) REFERENCES Sala(codigo),
	CONSTRAINT aula_fk2 FOREIGN KEY (cpf_aluno) REFERENCES Aluno(cpf_aluno),
	CONSTRAINT aula_fk3 FOREIGN KEY (cpf_professor) REFERENCES Professor(cpf_professor)
);