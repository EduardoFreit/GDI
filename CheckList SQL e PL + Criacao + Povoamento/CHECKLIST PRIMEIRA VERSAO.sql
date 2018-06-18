------------------------------------------------------------ CHECKLIST -------------------------------------------------------------------

-- 1, 6
-- Exibe os cursos que possuem nota_mec entre 7 e 9 em ordem decrescente.
SELECT * FROM Curso WHERE nota_mec BETWEEN 7 AND 9 ORDER BY nota_mec DESC;

-- 2
-- Exibe os professores que nasceram nos anos 70;
SELECT * FROM Professor WHERE data_nasc BETWEEN to_date('01/01/1970', 'dd/mm/yyyy') AND to_date('12/12/1979', 'dd/mm/yyyy');

-- 3
-- Exibe o nome das disciplinas que começam com a letra 'F'.
SELECT nome FROM Disciplina WHERE nome LIKE 'F%';

-- 4
-- Exibe o nome dos alunos que possuem Iniciação Científica.
SELECT nome FROM Aluno WHERE cpf_aluno IN (SELECT cpf_aluno FROM Ic);

-- 5
-- Exibe o nome dos alunos que não possuem padrinhos
SELECT nome FROM Aluno WHERE cpf_padrinho IS NULL;

-- 7, 24
-- Cria uma view com o nome e um email de cada professor.
CREATE VIEW P_NomeEmail AS SELECT P.nome, E.email FROM Professor P, Email E WHERE P.cpf_professor = E.cpf_professor;

-- 8, 21
-- Exibe o nome dos professores que possuem mais de um email cadastrado.
SELECT nome FROM P_NomeEmail GROUP BY nome HAVING COUNT(nome) > 1;

-- 9
-- Deleta a view.
DROP VIEW P_NomeEmail;

-- 15
-- Adiciona a coluna cr na tabela Aluno.
ALTER TABLE Aluno ADD cr NUMBER(4,2);

-- 14
-- Modifica o tipo da coluna cr da tabela Aluno.
ALTER TABLE Aluno MODIFY cr VARCHAR2(10);

-- 16
-- Deleta a coluna cr da tabela Aluno.
ALTER TABLE Aluno DROP COLUMN cr;

-- 17
-- Exibe o nome e a média geral de cada aluno.
SELECT A.nome, AVG(C.media) AS Media_Geral FROM Aluno A, Cursa C WHERE A.cpf_aluno = C.cpf_aluno GROUP BY A.nome;

-- 17, 18, 43
-- Exibe a diferença entre o valor do investimento no projeto e a média total dos investimentos de todos os projetos.
SELECT P.titulo, (P.investimento - (SELECT AVG(investimento) FROM Projeto)) AS DIFF_FROM_AVG FROM Projeto P;

-- 20
-- Exibe o nome de todos os alunos que cursam alguma disciplina.
SELECT DISTINCT A.nome FROM Aluno A, Cursa C WHERE C.cpf_aluno = A.cpf_aluno;

-- 39
-- Deleta da tabela Cursa as entradas em que a média da entrada é menor que a média daquela respectiva disciplina.
DELETE FROM Cursa C1 WHERE C1.media < (SELECT AVG(C2.media) FROM Cursa C2 WHERE C1.codigo_disc = C2.codigo_disc);

-- 42
-- Exibe a maior média geral dos alunos.
SELECT MAX(Media_Geral) AS Maior_CR FROM (SELECT A.nome, AVG(C.media) AS Media_Geral FROM Aluno A, Cursa C WHERE A.cpf_aluno = C.cpf_aluno GROUP BY A.nome);


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
-- 71 e 89
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

-- 74 Não deixa deletar nenhum curso, sem condições
CREATE OR REPLACE TRIGGER delete_curso
BEFORE DELETE ON CURSO
FOR EACH ROW
BEGIN
RAISE_APPLICATION_ERROR(-20011, 'Nenhum curso pode ser deletado');
END;
/
-- Teste 74
DELETE FROM CURSO
WHERE CODIGO = 1;


-- 85 Se o professor for excluido, seus projetos tambem serao
CREATE OR REPLACE TRIGGER delete_prof
AFTER DELETE ON professor 
FOR EACH ROW
BEGIN
    IF(:OLD.cpf IS NOT NULL) THEN
        DELETE FROM projeto WHERE projeto.cpf_prof = :OLD.cpf;
    END IF;
END;    
/

-- Consulta que usa uma funçaõ ja existente
-- 86
SELECT Nome, nota_mec
FROM Curso 
WHERE nota_mec > (SELECT UNIQUE media_cursos FROM Curso)
ORDER BY nota_mec DESC;



-- Aparece nome do professor da disciplina, quantidades de aluno da disciplina, e Email do professor da disciplina, nas disci -
--plinas que a qntdidade de alunos esteja entre a média e o máximo, ordenamdo a consulta pelo nome do professor e pelo nome da disciplina
-- 44, 45
SELECT P.nome, D.nome, D.qnt_alunos, E.e_mail AS bbb FROM professor P
FULL OUTER JOIN disciplina D ON P.cpf = D.cpf_professor
FULL OUTER JOIN email E ON D.cpf_professor = E.cpf_professor
WHERE D.qnt_alunos BETWEEN (SELECT AVG(qnt_alunos) FROM disciplina) AND (SELECT MAX(qnt_alunos) FROM disciplina)
ORDER BY P.nome, D.nome; 

--mostra os email dos professores se existir algum professor cadastrado que tenha email tbm cadastrado
-- 46
SELECT e_mail FROM email
WHERE EXISTS ( SELECT * FROM professor P, email E WHERE E.cpf_professor = P.cpf);

--Seleciona os professores e seus CPFs e mostra quantas disciplinas cada um ministra e a quantidade máxima de alunos
--que cada professor eh "respondável" (são mostrados apenas professores com quantidade de alunos maior que a média)
-- responde: 19,22,23
SELECT COUNT(D.codigo), SUM(D.qnt_alunos), D.cpf_professor, P.nome FROM disciplina D, professor P
WHERE P.cpf = D.cpf_professor
GROUP BY D.cpf_professor,P.nome
HAVING SUM(D.qnt_alunos) > (SELECT AVG(qnt_alunos) FROM disciplina); 

--Mostra o professor o horário de sua aula e os alunos que estão cotados a participar dela(aula) e seus respectivos horários;
-- 25
SELECT AU.codigo, A.nome AS NOME_ALUNO, A.cpf AS CPF_ALUNO, P.nome AS NOME_PROF, P.cpf AS CPF_PROF, AU.horario FROM aluno A, professor P, aula AU
WHERE A.cpf = AU.cpf_aluno
AND P.cpf = AU.cpf_prof;

--Quais os professores tem email cadastrados
-- 26
SELECT P.nome, P.CPF AS CPF_PROFESSOR FROM professor P
INNER JOIN email E ON P.cpf = E.cpf_professor;

--Retornas s alunos que não estão fazendo inciacao cientifica
-- 27
SELECT A.nome, A.cpf AS CPF_ALUNO FROM aluno A
LEFT OUTER JOIN iniciacao I ON A.cpf = I.cpf_aluno
WHERE I.cpf_aluno IS NULL; 

--Seleciona os professores envolvidos em um projeto (mostrando nome, cpf e a descrição do projeto)
-- 28
SELECT P.nome, P.cpf AS CPF_PROF, PP.descricao FROM professor P
RIGHT OUTER JOIN projeto PP ON P.cpf = PP.cpf_prof;

--Mostra o todos os endereços cadastrados, associando ao Aluno(tbm mostra endereços cadastrados sem aluno associado)
-- 29
SELECT A.cpf, E.descricao, E.cep FROM aluno A
FULL OUTER JOIN endereco E ON e.cep = A.cep; 

--Mostra o nome o CPF e a média dos ALUNOS que tem media maior que algum aluno que cursa a discipliana de código 0
-- 30
SELECT A.nome, A.cpf, C.media FROM aluno A, cursa C
WHERE C.media > SOME (SELECT media FROM cursa WHERE codigo_disc = 0)
AND A.cpf = C.cpf_aluno;

--Exibe nome cpf media e data de nas cimento de alunos que média maiores que alunos nascidos antes de 1990
-- 31
SELECT A.nome, A.cpf, C.media, A.dt_nasc FROM aluno A, cursa C
WHERE C.media > ALL(SELECT C.media FROM aluno A,cursa C WHERE A.dt_nasc < TO_DATE('01-01-1990', 'DD-MM-YYYY') AND A.cpf = C.cpf_aluno)
AND A.cpf = C.cpf_aluno;

--Seleciona algun endereço que não tem nenhuma aluno com cep correspondente
-- 32 e 33
SELECT E.descricao, E.cep FROM endereco E
WHERE NOT EXISTS (SELECT * FROM aluno A WHERE (A.cep = E.cep) );

--mostra os horários de aulas de todos os professores e Alunos
 -- 34
SELECT A.nome, A.cpf, AU.horario, 'Aluno' AS alun_prof FROM aluno A,aula AU WHERE A.cpf = AU.cpf_aluno
UNION
SELECT P.nome, P.cpf, AU.horario, 'Professor' FROM professor P,aula AU WHERE P.cpf = AU.cpf_prof
ORDER BY alun_prof DESC, horario ASC;

--Retorna o CPF dos professores que possuem email
-- 35
SELECT cpf AS CPF_PROF FROM professor
INTERSECT
SELECT cpf_professor FROM email;

--Retorna o CPF dos professores que NÃO possuem email
-- 36
SELECT cpf AS CPF_PROF FROM professor
MINUS
SELECT cpf_professor FROM email;

--Insere uma nova linha na tabela a parti do insert
-- 37
INSERT INTO curso (codigo, nome, nota_mec)
SELECT MAX (C.codigo) + 1, 'Arte da Guerra', 90) FROM curso C;

--Atualiza o cep do endereço que não possui nenhum aluno cadastrado (nesse caso tenh
-- 38
UPDATE endereco SET cep = 995 WHERE cep = (SELECT cep FROM endereco WHERE cep = 999);


