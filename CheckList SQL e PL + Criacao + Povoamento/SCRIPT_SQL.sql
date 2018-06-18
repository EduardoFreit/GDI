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
--DROP VIEW P_NomeEmail;

-- 14
-- Modifica o tipo da coluna cr da tabela Aluno.
ALTER TABLE Aluno MODIFY nome VARCHAR2(50);

-- 15
-- Adiciona a coluna cr na tabela Aluno.
ALTER TABLE Aluno ADD cr NUMBER(4,2);

-- 16
-- Deleta a coluna cr da tabela Aluno.
ALTER TABLE Aluno DROP COLUMN cr;

-- 17
-- Exibe o nome e a média geral de cada aluno.
SELECT A.nome, AVG(C.media) AS Media_Geral FROM Aluno A, Cursa C WHERE A.cpf_aluno = C.cpf_aluno GROUP BY A.nome;

-- 17, 18, 43
-- Exibe a diferença entre o valor do investimento no projeto e a média total dos investimentos de todos os projetos.
SELECT P.titulo, (P.investimento - (SELECT AVG(investimento) FROM Projeto)) AS DIFF_FROM_AVG FROM Projeto P;

--Seleciona os professores e seus CPFs e mostra quantas disciplinas cada um ministra e a quantidade máxima de alunos
--que cada professor eh "respondável" (são mostrados apenas professores com quantidade de alunos maior que a média)
-- responde: 19,22,23
SELECT COUNT(D.codigo_disc), SUM(D.qnt_alunos), D.cpf_professor, P.nome 
FROM disciplina D, professor P
WHERE P.cpf_professor = D.cpf_professor
GROUP BY D.cpf_professor,P.nome
HAVING SUM(D.qnt_alunos) > (SELECT AVG(qnt_alunos) FROM disciplina); 

-- 20
-- Exibe o nome de todos os alunos que cursam alguma disciplina.
SELECT DISTINCT A.nome FROM Aluno A, Cursa C WHERE C.cpf_aluno = A.cpf_aluno;

--Mostra o professor o horário de sua aula e os alunos que estão cotados a participar dela(aula) e seus respectivos horários;
-- 25
SELECT AU.codigo_sala, A.nome AS NOME_ALUNO, A.cpf_aluno AS CPF_ALUNO, P.nome AS NOME_PROF, P.cpf_professor AS CPF_PROF, AU.horario 
FROM aluno A, professor P, aula AU
WHERE A.cpf_aluno = AU.cpf_aluno
AND P.cpf_professor = AU.cpf_professor;

--Quais os professores tem email cadastrados
-- 26
SELECT P.nome, P.cpf_professor AS CPF_PROFESSOR 
FROM professor P
INNER JOIN email E ON P.cpf_professor = E.cpf_professor;

--Retornas s alunos que não estão fazendo inciacao cientifica
-- 27
SELECT A.nome, A.cpf_aluno AS CPF_ALUNO 
FROM aluno A
LEFT OUTER JOIN ic I ON A.cpf_aluno = I.cpf_aluno
WHERE I.cpf_aluno IS NULL;

--Seleciona os professores envolvidos em um projeto (mostrando nome, cpf e a descrição do projeto)
-- 28
SELECT P.nome, P.cpf_professor AS CPF_PROF, PP.descricao 
FROM professor P
RIGHT OUTER JOIN projeto PP ON P.cpf_professor = PP.cpf_professor;

--Mostra o todos os endereços cadastrados, associando ao Aluno(tbm mostra endereços cadastrados sem aluno associado)
-- 29
SELECT A.cpf_aluno, E.descricao, E.cep 
FROM aluno A
FULL OUTER JOIN endereco E ON e.cep = A.cep; 

--Mostra o nome o CPF e a média dos ALUNOS que tem media maior que algum aluno que cursa a discipliana de código 0
-- 30
SELECT A.nome, A.cpf_aluno, C.media 
FROM aluno A, cursa C
WHERE C.media > SOME (SELECT media FROM cursa WHERE codigo_disc = 10)
AND A.cpf_aluno = C.cpf_aluno;

--Exibe nome cpf media e data de nas cimento de alunos que média maiores que alunos nascidos antes de 1990
-- 31
SELECT A.nome, A.cpf_aluno, C.media, A.data_nasc 
FROM aluno A, cursa C
WHERE C.media > ALL(SELECT C.media FROM aluno A,cursa C WHERE A.data_nasc < TO_DATE('01-01-1990', 'DD-MM-YYYY') AND A.cpf_aluno = C.cpf_aluno)
AND A.cpf_aluno = C.cpf_aluno;

--Seleciona algun endereço que não tem nenhuma aluno com cep correspondente
-- 32 e 33
SELECT E.descricao, E.cep 
FROM endereco E
WHERE  EXISTS (SELECT * FROM aluno A WHERE (A.cep = E.cep) AND A.cpf_aluno = 1111);

--mostra os horários de aulas de todos os professores e Alunos
 -- 34
SELECT A.nome, A.cpf_aluno, AU.horario, 'Aluno' AS alun_prof FROM aluno A,aula AU WHERE A.cpf_aluno = AU.cpf_aluno
UNION
SELECT P.nome, P.cpf_professor, AU.horario, 'Professor' FROM professor P,aula AU WHERE P.cpf_professor = AU.cpf_professor
ORDER BY alun_prof DESC, horario ASC;

--Retorna o CPF dos professores que possuem email
-- 35
SELECT cpf_professor AS CPF_PROF FROM professor
INTERSECT
SELECT cpf_professor FROM email;

--Retorna o CPF dos professores que NÃO possuem email
-- 36
(SELECT cpf_professor AS CPF_PROF FROM professor)
MINUS
(SELECT cpf_professor FROM email WHERE MOD(cpf_professor,2) = 0);

--Insere uma nova linha na tabela a parti do insert
-- 37
INSERT INTO curso (codigo, nome, nota_mec) VALUES ((SELECT MAX(C.codigo) + 1 FROM curso C), 'Filosofia', 9.0);

--Atualiza o cep do endereço que não possui nenhum aluno cadastrado (nesse caso tenh
-- 38
UPDATE endereco SET descricao = 'Rua da Festa' WHERE cep = (SELECT cep FROM endereco WHERE cep = 60);

-- 39
-- Deleta da tabela Cursa as entradas em que a média da entrada é menor que a média daquela respectiva disciplina.
DELETE FROM Cursa C1 WHERE C1.media = (SELECT MIN(C2.media) FROM Cursa C2);

-- 42
-- Exibe a maior média geral dos alunos.
SELECT MAX(Media_Geral) AS Maior_CR FROM (SELECT A.nome, AVG(C.media) AS Media_Geral FROM Aluno A, Cursa C WHERE A.cpf_aluno = C.cpf_aluno GROUP BY A.nome);

-- Aparece nome do professor da disciplina, quantidades de aluno da disciplina, e Email do professor da disciplina, nas disci -
--plinas que a qntdidade de alunos esteja entre a média e o máximo, ordenamdo a consulta pelo nome do professor e pelo nome da disciplina
-- 44, 45
SELECT P.nome, D.nome, D.qnt_alunos, E.email AS bbb FROM professor P
FULL OUTER JOIN disciplina D ON P.cpf_professor = D.cpf_professor
FULL OUTER JOIN email E ON D.cpf_professor = E.cpf_professor
WHERE D.qnt_alunos BETWEEN (SELECT AVG(qnt_alunos) FROM disciplina) AND (SELECT MAX(qnt_alunos) FROM disciplina)
ORDER BY P.nome, D.nome; 

--mostra os email dos professores se existir algum professor cadastrado que tenha email tbm cadastrado
-- 46
SELECT email FROM email
WHERE EXISTS ( SELECT * FROM professor P, email E WHERE E.cpf_professor = P.cpf_professor);