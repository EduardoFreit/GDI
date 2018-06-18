DROP TABLE tb_Aula;
DROP TABLE tb_Cursa;
DROP TABLE tb_Projeto;
DROP TABLE tb_Ic;
DROP TABLE tb_Sala;
DROP TABLE tb_Disciplina;
DROP TABLE tb_Email;
DROP TABLE tb_Professor;
DROP TABLE tb_Aluno;
DROP TABLE tb_Endereco;
DROP TABLE tb_Licenciatura;
DROP TABLE tb_Bacharelado;
DROP TABLE tb_Curso;

-------------------------

CREATE TABLE tb_Curso OF tp_Curso (
    codigo PRIMARY KEY,
    nome NOT NULL,
    CONSTRAINT curso_ck CHECK (nota_mec >= 0 AND nota_mec <= 10)
);
/

CREATE TABLE tb_Bacharelado OF tp_Bacharelado (
    codigo PRIMARY KEY,
    nome NOT NULL,
    CONSTRAINT Bach_ck CHECK (nota_mec >= 0 AND nota_mec <= 10)
);
/

CREATE TABLE tb_Licenciatura OF tp_Licenciatura (
    codigo PRIMARY KEY,
    nome NOT NULL,
    CONSTRAINT Lic_ck CHECK (nota_mec >= 0 AND nota_mec <= 10)
);
/

CREATE TABLE tb_Aluno OF tp_Aluno (
    cpf_aluno PRIMARY KEY,
    nome NOT NULL,
	data_nasc NOT NULL,
	REF_Curso WITH ROWID REFERENCES tb_Curso, --WITH ROWID: Garante a integridade referencial
	REF_Padrinho WITH ROWID REFERENCES tb_Aluno,
    Endereco NOT NULL
);
/

CREATE TABLE tb_Professor OF tp_Professor (
    cpf_professor PRIMARY KEY,
	data_nasc NOT NULL,
	nome NOT NULL,
    Emails NOT NULL
);
/

CREATE TABLE tb_Disciplina OF tp_Disciplina (
    codigo_disc PRIMARY KEY,			
	REF_Professor WITH ROWID REFERENCES tb_Professor,
	nome NOT NULL
);
/

CREATE TABLE tb_Sala OF tp_Sala (
    codigo PRIMARY KEY,
	capacidade NOT NULL,
	centro NOT NULL
);
/

CREATE TABLE tb_Ic OF tp_Ic (
    codigo PRIMARY KEY,
	data_inic NOT NULL,
	tema NOT NULL,
	REF_Aluno WITH ROWID REFERENCES tb_Aluno
);
/

CREATE TABLE tb_Projeto OF tp_Projeto (
    cpf_professor PRIMARY KEY,--PRIMARY KEY 
    REF_Professor WITH ROWID REFERENCES tb_Professor,
	titulo NOT NULL,
	descricao NOT NULL,
	investimento NOT NULL
);
/

CREATE TABLE tb_Cursa OF tp_Cursa (
    REF_Aluno WITH ROWID REFERENCES tb_Aluno,
	REF_Disciplina WITH ROWID REFERENCES tb_Disciplina,
	media NOT NULL,
    CONSTRAINT cursa_pk PRIMARY KEY (cpf_aluno, codigo_disc)
);
/

CREATE TABLE tb_Aula OF tp_Aula (
    REF_Aluno WITH ROWID REFERENCES tb_Aluno,
	REF_Sala WITH ROWID REFERENCES tb_Sala,
    REF_Professor WITH ROWID REFERENCES tb_Professor,
    CONSTRAINT aula_pk PRIMARY KEY (codigo_sala, cpf_aluno, cpf_professor, horario)
);
/