-- PL básicas ROSINALDO

-- 48, 51, 53, 56, 57, 60
-- retorna a quantidade de cursos da universidade e uma divisão do cursos por intervalo de média
DECLARE
    qnt_curso NUMBER;
    CURSOR c_curso IS (SELECT * FROM curso);
    v_curso c_curso%ROWTYPE;
BEGIN
    SELECT COUNT(*) INTO qnt_curso FROM curso;
    dbms_output.put_line('A quantidade de cursos é : ' || qnt_curso);

    OPEN c_curso;
    LOOP
        FETCH c_curso INTO v_curso;
        EXIT WHEN c_curso%NOTFOUND;

        IF (v_curso.nota_mec < 7) THEN
            dbms_output.put_line('O curso : ' || v_curso.nome || 'tem nota do mec inferior a 7');
        ELSIF (v_curso.nota_mec > 7 AND v_curso.nota_mec < 9) THEN
            dbms_output.put_line('O curso : ' || v_curso.nome || 'tem nota do mec entre 7 e 9');
        ELSE
            dbms_output.put_line('O curso : ' || v_curso.nome || 'tem nota do mec superior a 9');
        END IF;
    END LOOP;
END;


-- 52, 54, 59
-- retorna uma mensagem dizendo se o código da disciplina é IMPAR OU PAR
DECLARE 
    CURSOR c_disc IS (SELECT * FROM disciplina);
    v_codigo NUMBER;
    v_qnt_alunos NUMBER;
    v_cpf NUMBER;
    v_nome VARCHAR2(20);
    a NUMBER := 1;
    b NUMBER;
    qnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO qnt FROM disciplina;
    OPEN c_disc;
    WHILE a <= qnt LOOP
        FETCH c_disc INTO v_codigo, v_qnt_alunos, v_cpf, v_nome;
        b := MOD (v_codigo,2);
        CASE b
            WHEN 0 THEN
                dbms_output.put_line('A disciplina : ' || v_nome || 'tem codigo de curso PAR');
            WHEN 1 THEN
                dbms_output.put_line('A disciplina : ' || v_nome || 'tem codigo de curso IMPAR');
        END CASE;
        a := a + 1;
    END LOOP;
END;


-- retorna o códiga e a capacidade das salas localizadas no CCEN
-- 61
DECLARE
    CURSOR c_sala (v_centro VARCHAR2) IS (SELECT codigo, capacidade FROM sala WHERE centro = v_centro);
    v_sala c_sala%ROWTYPE;
BEGIN
    OPEN c_sala('CCEN');
    LOOP
        FETCH c_sala INTO v_sala;
        EXIT WHEN c_sala%NOTFOUND;
        dbms_output.put_line('A sala de codigo ' || v_sala.codigo || ' e capacidade '|| v_sala.capacidade ||  ' está localizada no CCEN');
    END LOOP;
END;


-- retorna o códiga e a capacidade das salas localizadas no CCEN (igual ao de cima mas de um jeito bem mais simples)
-- 55, 62
BEGIN
    FOR v_sala IN (SELECT * FROM sala) LOOP
        IF v_sala.centro = 'CCEN' THEN
            dbms_output.put_line('A sala de codigo ' || v_sala.codigo || ' e capacidade '|| v_sala.capacidade ||  ' está localizada no CCEN');
        END IF;
    END LOOP;
END;


-- Insere uma nova iniciação científica
-- 64
CREATE OR REPLACE PROCEDURE insereIC(
v_codigo ic.codigo%TYPE,
v_data_inic ic.data_inic%TYPE,
v_tema ic.tema%TYPE,
v_cpf_aluno ic.cpf_aluno%TYPE) AS

BEGIN
    INSERT INTO ic VALUES (v_codigo, v_data_inic, v_tema, v_cpf_aluno);
    COMMIT;
END insereIC;

-- Teste do procedimento anterior
BEGIN
    insereIC(4,'30/11/15','IoT',2222);
END;


-- pega o código do curso de um aluno com determinado CPF
--  49, 65
CREATE OR REPLACE PROCEDURE codigo_aluno(
v_cpf_aluno IN OUT aluno.cpf_aluno%TYPE,
v_codigo_curso OUT aluno.codigo_curso%TYPE) AS

BEGIN
    SELECT codigo_curso INTO v_codigo_curso FROM aluno WHERE cpf_aluno = v_cpf_aluno;
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_codigo_curso := -1;
        dbms_output.put_line('Não existe aluno com o CPF especificado');

END codigo_aluno;


-- Bloco que chama PROCUDERE (que pega o código do curso de um aluno com determinado CPF) e printa o código
--  49, 65
DECLARE
    v_cpf aluno.cpf_aluno%TYPE := '5555';
    v_codigo aluno.codigo_curso%TYPE;
BEGIN
    codigo_aluno (v_cpf, v_codigo);
    IF v_codigo != -1 THEN
        dbms_output.put_line('O codigo do curso do aluno com cpf ' || v_cpf || ' é ' || v_codigo);
    END IF;
END;


-- procedimento que diz a quantidade de alunos em cada disciplina
-- 63 
CREATE OR REPLACE PROCEDURE qnt_aluno_disc AS
BEGIN
    FOR v_reg IN (SELECT nome, qnt_alunos FROM disciplina ) LOOP
        IF (v_reg.qnt_alunos IS NULL) THEN
            dbms_output.put_line('A disciplina ' || v_reg.nome || ' não tem alunos');
        ELSE
            dbms_output.put_line('A disciplina ' || v_reg.nome || ' tem ' || v_reg.qnt_alunos || ' alunos');
        END IF;
    END LOOP;
    COMMIT;
END qnt_aluno_disc;

-- Teste do procedimento anterior
BEGIN
    qnt_aluno_disc();
END;


-- Função que retorna a médoa das notas do mec dos cursos
-- 67
CREATE OR REPLACE FUNCTION media_cursos RETURN NUMBER IS
media NUMBER(3,2);
BEGIN
    SELECT AVG(nota_mec) INTO media FROM curso;
    RETURN media;
END media_cursos;

-- Teste para a função anterior
DECLARE
    media NUMBER (3,2);
BEGIN
    media := media_cursos;
    dbms_output.put_line('A média das notas do mec de todos os cursos é : ' || media);
END;



-- -- Função que retorna as salas de um determinado centro quem tem a capacidade maior que X
-- 68, 69, 70

CREATE OR REPLACE FUNCTION dados_aluno(v_data_nasc OUT aluno.data_nasc%TYPE,
                                        v_cpf_aluno IN OUT aluno.cpf_aluno%TYPE,
                                        v_cpf_padrinho OUT aluno.cpf_padrinho%TYPE,
                                        v_nome OUT aluno.nome%TYPE,
                                        v_cep OUT aluno.cep%TYPE) RETURN ic.tema%TYPE IS

v_tema_ic ic.tema%TYPE;

BEGIN
    SELECT data_nasc, cpf_padrinho, nome, cep 
    INTO v_data_nasc, v_cpf_padrinho, v_nome, v_cep 
    FROM aluno 
    WHERE cpf_aluno = v_cpf_aluno;

    SELECT tema 
    INTO v_tema_ic 
    FROM ic 
    WHERE cpf_aluno = v_cpf_aluno;

    RETURN v_tema_ic;
END dados_aluno;

-- Teste para função anterior com chamada
DECLARE 
    v_tema_ic ic.tema%TYPE;
    v_cep aluno.cep%TYPE;
    v_nome aluno.nome%TYPE;
    v_cpf_padrinho aluno.cpf_padrinho%TYPE;
    v_cpf_aluno aluno.cpf_aluno%TYPE := '2222';
    v_data_nasc aluno.data_nasc%TYPE;
    v_cod_curso aluno.codigo_curso%TYPE;

BEGIN
    v_tema_ic := dados_aluno(v_data_nasc, v_cpf_aluno, v_cpf_padrinho, v_nome, v_cep);
    codigo_aluno(v_cpf_aluno, v_cod_curso);

    dbms_output.put_line('Nome : ' || v_nome);
    dbms_output.put_line('Data de nascimento : ' || v_data_nasc);
    dbms_output.put_line('Cpf do padrinho : ' || v_cpf_padrinho);
    dbms_output.put_line('Código do curso : ' || v_cod_curso);
    dbms_output.put_line('Tema da iniciação científica : ' || v_tema_ic);
    dbms_output.put_line('Cep : ' || v_cep);
END;



-- Pacotes
/* O pacote recebe o cpf de um jogador e imprime seu nome. */

CREATE OR REPLACE PACKAGE nomeAlunoX AS
    FUNCTION nomeAluno (v_cpf aluno.cpf_aluno%TYPE) RETURN aluno.nome%TYPE;
    PROCEDURE getNomeAluno (v_cpf IN aluno.cpf_aluno%TYPE);
END nomeAlunoX;
/

CREATE OR REPLACE PACKAGE BODY nomeAlunoX AS
    FUNCTION nomeAluno (v_cpf aluno.cpf_aluno%TYPE) RETURN aluno.nome%TYPE IS
    
    Jnome aluno.nome%TYPE;
    BEGIN
        SELECT nome INTO Jnome
        FROM aluno A
        WHERE A.cpf_aluno = v_cpf;  
     RETURN Jnome;
    END nomeAluno;
    
    PROCEDURE getNomeAluno (v_cpf IN aluno.cpf_aluno%TYPE) IS
    
    aux aluno.nome%TYPE;
    BEGIN
        aux := nomeAluno(v_cpf);
    
        dbms_output.put_line(aux);
    END getNomeAluno;

END nomeAlunoX;




