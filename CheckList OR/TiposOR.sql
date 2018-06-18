DROP TYPE tp_Aula;
DROP TYPE tp_Cursa;
DROP TYPE tp_Projeto;
DROP TYPE tp_Ic;
DROP TYPE tp_Sala;
DROP TYPE tp_Disciplina;
DROP TYPE tp_Emails;
DROP TYPE tp_Email;
DROP TYPE tp_Professor;
DROP TYPE tp_Pessoa;
DROP TYPE tp_Aluno;
DROP TYPE tp_Endereco;
DROP TYPE tp_Licenciatura;
DROP TYPE tp_Bacharelado;
DROP TYPE tp_Curso;

-------------------------

CREATE OR REPLACE TYPE tp_Curso AS OBJECT(
    codigo NUMBER,
	nome VARCHAR2(30),
	nota_mec NUMBER(4,2),
    MAP MEMBER FUNCTION Situacao RETURN VARCHAR2 --Item 7: Retorna a situação do Curso a parti da média_mec
)NOT FINAL;
/

CREATE OR REPLACE TYPE BODY tp_Curso AS --Item 7: Retorna a situação do Curso a parti da média_mec
    MAP MEMBER FUNCTION Situacao RETURN VARCHAR2 IS
    BEGIN
        IF (SELF.nota_mec >= 7.0) THEN
           RETURN 'POSITIVO';
        ELSIF(SELF.nota_mec < 7.0 AND SELF.nota_mec >= 4.0) THEN
            RETURN 'MEDIANO';
        ELSE
           RETURN 'NEGATIVO';
        END IF;
    END;
END;
/

CREATE OR REPLACE TYPE tp_Bacharelado UNDER tp_Curso(
    linha_de_pesquisa VARCHAR2(30)
)FINAL;
/

CREATE OR REPLACE TYPE tp_Licenciatura UNDER tp_Curso(
    disciplinas_obrigatorias VARCHAR2(30),
    OVERRIDING MAP MEMBER FUNCTION Situacao RETURN VARCHAR2 --Item 10: Mudando o metodo de curso
)FINAL;
/

CREATE OR REPLACE TYPE BODY tp_Licenciatura AS --Item 10: Mudando o metodo de curso em licenciatura
    OVERRIDING MAP MEMBER FUNCTION Situacao RETURN VARCHAR2 IS
    BEGIN
        IF (SELF.nota_mec >= 6.0) THEN
           RETURN 'POSITIVO';
        ELSIF(SELF.nota_mec < 6.0 AND SELF.nota_mec >= 3.0) THEN
            RETURN 'MEDIANO';
        ELSE
           RETURN 'NEGATIVO';
        END IF;
    END;
END;
/

CREATE OR REPLACE TYPE tp_Endereco AS OBJECT(
    cep NUMBER,
	descricao VARCHAR2(30)
)FINAL;
/

CREATE OR REPLACE TYPE tp_Aluno AS OBJECT(
    cpf_aluno NUMBER,
    nome VARCHAR2(30),
	data_nasc DATE,
	REF_Curso REF tp_Curso,
	REF_Padrinho REF tp_Aluno,	
	Endereco tp_Endereco,
    MEMBER FUNCTION get_nome RETURN VARCHAR2, --Item 6: Retorna o nome do aluno
    ORDER MEMBER FUNCTION Comp_Idade(Aluno tp_Aluno) RETURN NUMBER --Item 8: Retorna qual o comparativo das idades dos alunos
)FINAL;
/

CREATE OR REPLACE TYPE BODY tp_Aluno AS 
    MEMBER FUNCTION get_nome RETURN VARCHAR2 IS --Item 6: Retorna o nome do aluno
    BEGIN 
        RETURN SELF.nome;
    END;
    
    ORDER MEMBER FUNCTION Comp_Idade(Aluno tp_Aluno) RETURN NUMBER IS --Item 8: Retorna qual o comparativo das idades dos alunos
    BEGIN
        IF (SELF.data_nasc > Aluno.data_nasc) THEN
           RETURN 1;
        ELSIF(SELF.data_nasc = Aluno.data_nasc) THEN
            RETURN 0;
        ELSE
           RETURN -1;
        END IF;
    END;
    
END;
/

CREATE OR REPLACE TYPE tp_Email AS OBJECT(
    email VARCHAR2(30),
    CONSTRUCTOR FUNCTION tp_Email(email VARCHAR2, Domin VARCHAR2) RETURN SELF AS RESULT -- item 5 : criando um construtor paraemails de Dominios diferentes
)FINAL;
/

CREATE OR REPLACE TYPE BODY tp_Email AS CONSTRUCTOR FUNCTION tp_Email(email VARCHAR2, Domin VARCHAR2) RETURN SELF AS RESULT IS-- item 5
    BEGIN
        SELF.email := email || '@' || Domin || '.com.br';
        RETURN;
    END;
END;
/

CREATE OR REPLACE TYPE tp_Emails AS VARRAY(5) OF tp_Email;
/

CREATE OR REPLACE TYPE tp_Pessoa AS OBJECT(
	nome VARCHAR2(30),
    NOT INSTANTIABLE MEMBER FUNCTION get_nome RETURN VARCHAR2 --Item 9: Criando um método abstrato (A parti de uma classe abstrata, obviamente)
)NOT INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE tp_Professor UNDER tp_Pessoa(
    cpf_professor NUMBER,
	data_nasc DATE,   
    Emails tp_Emails,
    OVERRIDING MEMBER FUNCTION get_nome RETURN VARCHAR2 --Item 9: Instanciando método abstrato
)FINAL;
/

CREATE OR REPLACE TYPE BODY tp_Professor AS 
    OVERRIDING MEMBER FUNCTION get_nome RETURN VARCHAR2 IS --Item 9: Instanciando método abstrato
    BEGIN 
        RETURN SELF.nome;
    END;
END;
/

CREATE OR REPLACE TYPE tp_Disciplina AS OBJECT(
    codigo_disc NUMBER,
	qnt_alunos NUMBER,				
	REF_Professor REF tp_Professor,
	nome VARCHAR2(30)
)FINAL;
/

CREATE OR REPLACE TYPE tp_Sala AS OBJECT(
    codigo NUMBER,
	capacidade NUMBER,
	centro VARCHAR2(30) 
)FINAL;
/

CREATE OR REPLACE TYPE tp_Ic AS OBJECT(
    codigo NUMBER,
	data_inic DATE,
	tema VARCHAR2(100),
	REF_Aluno REF tp_Aluno
)FINAL;
/

CREATE OR REPLACE TYPE tp_Projeto AS OBJECT(
    cpf_professor NUMBER,--PRIMARY KEY 
    REF_Professor REF tp_Professor,
	titulo VARCHAR2(100),
	descricao VARCHAR2(200),
	investimento NUMBER(10,2)
)FINAL;
/

CREATE OR REPLACE TYPE tp_Cursa AS OBJECT(
    cpf_aluno NUMBER,--PRIMARY KEY 
	codigo_disc NUMBER,--PRIMARY KEY 
    REF_Aluno REF tp_Aluno,
	REF_Disciplina REF tp_Disciplina,
	media NUMBER(4,2)
)FINAL;
/

CREATE OR REPLACE TYPE tp_Aula AS OBJECT(
    codigo_sala NUMBER,--PRIMARY KEY 
	cpf_aluno NUMBER,--PRIMARY KEY 
	cpf_professor NUMBER,--PRIMARY KEY 
    REF_Aluno REF tp_Aluno,
	REF_Sala REF tp_Sala,
    REF_Professor REF tp_Professor,
	horario TIMESTAMP --PRIMARY KEY 
)FINAL;
/