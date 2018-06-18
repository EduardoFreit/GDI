--Item 6: Retorna o nome do aluno / --Item 8: Retorna qual o comparativo das idades dos alunos
SELECT A.get_nome() FROM TB_Aluno A WHERE A.cpf_aluno = 0000;

SET SERVEROUTPUT ON;
DECLARE
    aux tp_Aluno;
    aux_Data DATE;
    aux_result NUMBER;
    aux_Nome VARCHAR2(30);
    aux_Nome2 VARCHAR2(30);
BEGIN
    SELECT A.data_nasc,A.nome INTO aux_Data,aux_Nome2 FROM tb_Aluno A WHERE A.cpf_aluno = 1111;
    aux := NEW tp_Aluno(NULL, NULL , aux_Data, NULL, NULL ,NULL);
    SELECT A.get_nome(),A.Comp_Idade(aux) INTO aux_Nome,aux_result FROM TB_Aluno A WHERE A.cpf_aluno = 0000;
    
    IF (aux_result = 1) THEN
            dbms_output.put_line(aux_Nome || ' nasceu depois de: ' || aux_Nome2);
        ELSIF(aux_result = 1) THEN
            dbms_output.put_line(aux_Nome || ' nasceu no mesmo dia de: ' || aux_Nome2);
        ELSE
           dbms_output.put_line(aux_Nome || ' nasceu antes de: ' || aux_Nome2);
    END IF;
END;
/

--Item 7: Retorna a situação do Curso a parti da média_mec
SELECT C.Situacao() FROM TB_Curso C WHERE C.codigo = '001';

SET SERVEROUTPUT ON;
DECLARE --Imprime a situação do curso de código 1
    Situc VARCHAR2(30);
BEGIN
    SELECT C.Situacao() INTO Situc FROM TB_Curso C WHERE C.codigo = 1;
    dbms_output.put_line(Situc);
END;
/
--Item 9: Chamando o método abstrato
SELECT P.get_nome() FROM TB_Professor P WHERE P.cpf_professor = 11;

--11 adiciona o atributo titulo a professor
ALTER TYPE tp_professor ADD ATTRIBUTE (titulo VARCHAR2(20)) CASCADE;
/

--12 aumenta o tamanho maximo do nome de professor
ALTER TYPE tp_professor MODIFY ATTRIBUTE (nome VARCHAR2(40)) CASCADE;
/

-- 14 modifica o atributo nome do tipo curso
ALTER TYPE tp_curso MODIFY ATTRIBUTE nome VARCHAR(40) CASCADE;
/

-- 15 adiciona um atributo ao tipo curso
ALTER TYPE tp_curso ADD ATTRIBUTE (duracao_anos NUMBER) INVALIDATE;
/ 

-- 13 exclui um atributo do tipo curso
ALTER TYPE tp_curso DROP ATTRIBUTE (duracao_anos) INVALIDATE;
/
ALTER TYPE tp_professor DROP ATTRIBUTE (titulo) INVALIDATE;
/

-- 19 mostra o nome do curso pegando a referencia de curso em aluno, que por sua vez é pego como referencia em aula
SELECT DISTINCT A.REF_Aluno.REF_Curso.nome
FROM TB_AULA A
WHERE codigo_sala = 004
/

-- 20 ( consulta o nome dos alunos e a  descrição dos seus cursos, quando a nota do curso é maior que 7)
SELECT A.nome, DEREF (A.REF_Curso) AS CURSO FROM tb_Aluno A WHERE A.REF_CURSO.NOTA_MEC > 7;
/

-- 21 (exibe os dados das instâncias dos objetos da tabela licenciatura)
SELECT VALUE (L) Cursos_licenciatura FROM TB_LICENCIATURA L;
/

--22 E 25 usa table para visualizar os valores de um varray(no caso os emais do professor com o cpf 44) 
SELECT * 
FROM TABLE(SELECT Emails 
		   FROM TB_professor 
		   WHERE cpf_professor = 44);
/

-- 22 e 26 usa table para visualizar os valores de uma nested table (no caso os emais do professor com o cpf 44)
SELECT * 
FROM TABLE(SELECT nt_emails 
		   FROM TB_professor 
		   WHERE cpf_professor = 44);
/

-- 23
--ordena toda a tabela de acordo com o nome do curso
SELECT * FROM TB_CURSO ORDER BY NOME;
/

--exibe 2 ou mais investimentos que sao acima de 1000.Nada eh exibido se houver apenas 1 investimento 
--com o valor acima de 1000.
SELECT investimento, COUNT(*) FROM tb_projeto WHERE investimento > 1000 
GROUP BY investimento HAVING COUNT(*) > 1;
/

INSERT INTO TB_Projeto VALUES (44,(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 44), 'ac', 'alguma coisa', 15000.00);

SELECT nome
FROM tb_aluno
WHERE (cpf_aluno BETWEEN 2000 and 6000) AND nome LIKE 'S%';
/


-- 24 
SELECT A.CPF_PROFESSOR
FROM TB_PROJETO A
WHERE (A.INVESTIMENTO > ALL(1000)) AND (A.TITULO) IN ('GIT');

SELECT A.CPF_aluno
FROM tb_aluno A
WHERE A.REF_Curso.codigo = any(select codigo from tb_curso where nota_mec > 5);
/


-- 27 
--Exibe os CPF dos professores que tem mais de 10000 investido em seus projetos.
select a.cpf_professor from tb_professor a
where exists (select * from tb_projeto b
where b.cpf_professor = a.cpf_professor and investimento > 10000);
/

-- 28
--Se adicionar um professor com um cpf que ja existe na tabela, ira mostrar a mensagem 
CREATE OR REPLACE TRIGGER verificar
BEFORE INSERT ON tb_professor
FOR EACH ROW
DECLARE
	cont NUMBER;
BEGIN
	SELECT COUNT(*) INTO cont FROM tb_professor P WHERE P.CPF_PROFESSOR = :NEW.CPF_PROFESSOR;
	IF(cont>0) THEN
    	RAISE_APPLICATION_ERROR(-20020,'CPF ja cadastrado');
	END IF;
END verificar;
/
--teste
INSERT INTO TB_Professor VALUES (88, to_date('02/06/1985', 'dd/mm/yyyy'), 'ASG', TP_EMAILS(TP_EMAIL('asg@cin.ufpe.br')),tp_nt_emails(TP_EMAIL('asg@cin.ufpe.br')));

-- 29
--Não será permitido atualizar o valor do investimento se este for menor que o valor atual.
CREATE OR REPLACE TRIGGER verificar_invest
BEFORE UPDATE ON tb_projeto
FOR EACH ROW
WHEN(NEW.investimento < OLD.investimento)
DECLARE
BEGIN
    	RAISE_APPLICATION_ERROR(-20020,'Investimento nao pode ser reduzido');
END verificar_invest;
/
--teste
update tb_projeto set investimento = 100 where titulo = 'GIT';

-- 30
-- Impede qualquer tipo de alteração na tabela  Licenciatura
CREATE OR REPLACE TRIGGER Impedir_Lic BEFORE 
UPDATE OR DELETE OR INSERT ON tb_Licenciatura
DECLARE
BEGIN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20010, 'Proibido inserir cursos de Licenciatura');
        ELSIF UPDATING THEN
            RAISE_APPLICATION_ERROR(-20011, 'Proibido atualizar cursos de Licenciatura');
        ELSIF DELETING THEN
            RAISE_APPLICATION_ERROR(-20012, 'Proibido deletar cursos de Licenciatura');
        END IF;
END Impedir_Lic;
/
--teste
INSERT INTO TB_Licenciatura VALUES (011, 'Um curso ai', 3.50, 'Sem ideia');