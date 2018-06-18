-- 12 - Criar FK Composta
-- 13 - Usar valor DEFAULT
-- Cria uma tabela contendo o cpf do aluno, o código da disciplina cursada por ele e o cpf do professor desta disciplina
CREATE TABLE CursaComProfessor (
    cpf_professor NUMBER,
    cpf_aluno NUMBER,
    codigo_disc NUMBER,
    centro VARCHAR2(20) DEFAULT 'CIn',
    CONSTRAINT cursacomprofessor_pk PRIMARY KEY (cpf_professor, cpf_aluno, codigo_disc),
    CONSTRAINT cursacomprofessor_fk1 FOREIGN KEY cpf_professor REFERENCES Disciplina(cpf_professor),
    CONSTRAINT cursacomprofessor_fk2 FOREIGN KEY cpf_aluno REFERENCES Cursa(cpf_aluno),
    CONSTRAINT cursacomprofessor_fk3 FOREIGN KEY codigo_disc REFERENCES Cursa(codigo_disc)
);

-- 84 - Uso de TRIGGER para inserir valores em outra tabela 
-- Insere na tabela CursaComProfessor depois de uma inserção na tabela Cursa
CREATE OR REPLACE TRIGGER insertOnTable
AFTER INSERT ON Cursa
FOR EACH ROW
v_cpf_prof NUMBER;
BEGIN
    SELECT D.cpf_professor INTO v_cpf_prof FROM Disciplina D WHERE D.codigo_disc = :NEW.codigo_disc;
    INSERT INTO CursaComProfessor(cpf_professor, cpf_aluno, codigo_disc)
    VALUES (v_cpf_prof, :NEW.cpf_aluno, :NEW.codigo_disc);
END insertOnTable;
/

-- 85 - Uso de TRIGGER para atualizar valores em outra tabela 
-- Se um curso for do tipo Bacharelado adicionar 0.5 à nota do MEC dele.
CREATE OR REPLACE TRIGGER updateOnTable
AFTER INSERT ON Bacharelado
FOR EACH ROW
    old_nota_mec Curso.nota_mec%TYPE;
BEGIN
    SELECT C.nota_mec INTO old_nota_mec FROM Curso C WHERE C.codigo = :NEW.codigo;
    IF old_nota_mec <= 9.5 THEN
        UPDATE Curso C SET nota_mec = (old_nota_mec + 0.5) WHERE C.codigo = :NEW.codigo;
    END IF;
END updateOnTable
/
