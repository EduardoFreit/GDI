-- 88 - Registro como parâmetro de função ou procedimento
-- Recebe um registro de um aluno e imprime quem é o padrinho.
CREATE OR REPLACE PROCEDURE NomePadrinho (info Aluno%ROWTYPE) IS
    padrinho VARCHAR2(30);
BEGIN
    IF (info.cpf_padrinho IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('O(A) aluno(a) '||info.nome||' nao possui padrinho.');
    ELSE
        SELECT A.nome INTO padrinho FROM Aluno A WHERE A.cpf_aluno = info.cpf_padrinho;
        DBMS_OUTPUT.PUT_LINE('O(A) aluno(a) '||info.nome||' eh apadrinhado por '||padrinho||'.');
    END IF;
END NomePadrinho;
/

-- 89 - Função com registro como retorno
-- Retorna o registro de um aluno a partir do cpf dele.
CREATE OR REPLACE FUNCTION getAluno (v_cpf IN Aluno.cpf_aluno%TYPE) RETURN Aluno%ROWTYPE IS
    v_aluno Aluno%ROWTYPE;
BEGIN
    SELECT * INTO v_aluno FROM Aluno A WHERE A.cpf_aluno = v_cpf;
    RETURN v_aluno;
END getAluno;
/

-- Teste da função getAluno() e do procedimento NomePadrinho()
DECLARE 
    al Aluno%ROWTYPE;
BEGIN
    al := getAluno(0000);
    NomePadrinho(al);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CPF não encontrado!');
END;
/