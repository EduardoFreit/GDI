INSERT INTO TB_Curso VALUES (001, 'Engenharia da Computação', 10.00);
INSERT INTO TB_Curso VALUES (002, 'Letras', 8.50);
INSERT INTO TB_Curso VALUES (003, 'Matemática', 9.52);
INSERT INTO TB_Curso VALUES (004, 'Ciência Política', 7.60);
INSERT INTO TB_Curso VALUES (005, 'Ciência da Computação', 6.20);
INSERT INTO TB_Curso VALUES (006, 'Arquitetura', 8.24);

INSERT INTO TB_Bacharelado VALUES (001, 'Engenharia da Computação', 10.00, 'Informática');
INSERT INTO TB_Bacharelado VALUES (004, 'Ciência Política', 7.60, 'Política');
INSERT INTO TB_Bacharelado VALUES (005, 'Ciência da Computação', 6.20, 'Informática');
INSERT INTO TB_Bacharelado VALUES (006, 'Arquitetura', 8.24, 'Urbanismo');

INSERT INTO TB_Licenciatura VALUES (002, 'Letras', 8.50, 'Metodologia');
INSERT INTO TB_Licenciatura VALUES (003, 'Matemática', 9.52, 'Pedagogia');

INSERT INTO TB_Aluno VALUES (0000,'Victor', to_date('07/04/1998', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 001),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 1111),TP_Endereco(00000, 'Rua dos Bobos'));
INSERT INTO TB_Aluno VALUES (1111,'Maria' , to_date('27/11/1998', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 006),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 2222),TP_Endereco(00020, 'Rua dos Caras Dahoras'));
INSERT INTO TB_Aluno VALUES (2222,'Lucas' , to_date('23/08/1967', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 003),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 3333),TP_Endereco(00040, 'Rua de Cima'));
INSERT INTO TB_Aluno VALUES (3333,'Allex' , to_date('21/12/1987', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 002),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 4444),TP_Endereco(00060, 'Rua de Baixo'));
INSERT INTO TB_Aluno VALUES (4444,'Karol' , to_date('02/02/1990', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 005),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 5555),TP_Endereco(00080, 'Rua Esburacada'));
INSERT INTO TB_Aluno VALUES (5555,'Sammy' , to_date('13/09/1943', 'dd/mm/yyyy'), (SELECT REF(C) FROM TB_Curso C WHERE C.CODIGO = 004),(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO = 1111),TP_Endereco(57020, 'Rua Formosa'));

INSERT INTO TB_Professor VALUES (11, to_date('28/02/1990', 'dd/mm/yyyy'), 'ACM', TP_EMAILS(TP_EMAIL('acm@cin.ufpe.br')));
INSERT INTO TB_Professor VALUES ('RMAS', 22, to_date('21/03/1987', 'dd/mm/yyyy'), TP_EMAILS(TP_EMAIL('rmas@cin.ufpe.br'),TP_EMAIL('mestre', 'gmail')));--chamando construtor Item 5
INSERT INTO TB_Professor VALUES (33, to_date('19/12/1972', 'dd/mm/yyyy'), 'PSGMN', TP_EMAILS(TP_EMAIL('psgmn@cin.ufpe.br'),TP_EMAIL('psgmn@gmail.com.br')));
INSERT INTO TB_Professor VALUES (44, to_date('09/10/1965', 'dd/mm/yyyy'), 'Romena', TP_EMAILS(TP_EMAIL('romena@cin.ufpe.br'), TP_EMAIL('romena@gmail.com.rm'), TP_EMAIL('romena@hotmail.com.rm')));
INSERT INTO TB_Professor VALUES (55, to_date('14/07/1978', 'dd/mm/yyyy'), 'Américo', TP_EMAILS(TP_EMAIL('americo@cin.ufpe.br')));
INSERT INTO TB_Professor VALUES (66, to_date('23/05/1980', 'dd/mm/yyyy'), 'Castor', TP_EMAILS(TP_EMAIL('castor@cin.ufpe.br')));
INSERT INTO TB_Professor VALUES (77, to_date('02/06/1985', 'dd/mm/yyyy'), 'ASG', TP_EMAILS(TP_EMAIL('asg@cin.ufpe.br')));

INSERT INTO TB_Disciplina VALUES (01, 100, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 11), 'IP');
INSERT INTO TB_Disciplina VALUES (02, 050, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 33), 'AVLC');
INSERT INTO TB_Disciplina VALUES (03, 010, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 66), 'Desenvolvimento iOS');
INSERT INTO TB_Disciplina VALUES (04, 100, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 44), 'Cálculo I');
INSERT INTO TB_Disciplina VALUES (05, 100, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 44), 'Cálculo II');
INSERT INTO TB_Disciplina VALUES (06, 100, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 44), 'Cálculo III');
INSERT INTO TB_Disciplina VALUES (07, 050, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 55), 'Física I');
INSERT INTO TB_Disciplina VALUES (08, 050, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 55), 'Física II');
INSERT INTO TB_Disciplina VALUES (09, 050, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 55), 'Física III');
INSERT INTO TB_Disciplina VALUES (10, 050, (SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 22), 'Métodos Numéricos');

INSERT INTO TB_Sala VALUES (002, 050, 'CCEN');
INSERT INTO TB_Sala VALUES (003, 060, 'CCEN');
INSERT INTO TB_Sala VALUES (004, 070, 'CCEN');
INSERT INTO TB_Sala VALUES (005, 090, 'CCEN');
INSERT INTO TB_Sala VALUES (013, 120, 'Área 2');
INSERT INTO TB_Sala VALUES (015, 110, 'Área 2');
INSERT INTO TB_Sala VALUES (112, 050, 'CIN');

INSERT INTO TB_Ic VALUES (01, to_date('19/02/2018', 'dd/mm/yyyy'), 'IoT',(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  0000));
INSERT INTO TB_Ic VALUES (02, to_date('19/02/2017', 'dd/mm/yyyy'), 'TNA',(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  1111));
INSERT INTO TB_Ic VALUES (03, to_date('19/02/2016', 'dd/mm/yyyy'), 'PSB',(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  5555));

INSERT INTO TB_Projeto VALUES (77,(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 77), 'LMS', 'Learning Management Systems', 200000.00);
INSERT INTO TB_Projeto VALUES (22,(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 22), 'OTI', 'Otimization', 15000.00);
INSERT INTO TB_Projeto VALUES (66,(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 66), 'GIT', 'Code Analytics', 100000.00);

INSERT INTO TB_Cursa VALUES (0000, 01,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  0000),(SELECT REF(D) FROM TB_Disciplina D WHERE D.codigo_disc =  01), 10.0);
INSERT INTO TB_Cursa VALUES (0000, 02,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  0000),(SELECT REF(D) FROM TB_Disciplina D WHERE D.codigo_disc =  02), 9.50);
INSERT INTO TB_Cursa VALUES (2222, 05,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  2222),(SELECT REF(D) FROM TB_Disciplina D WHERE D.codigo_disc =  05), 8.50);
INSERT INTO TB_Cursa VALUES (2222, 01,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  2222),(SELECT REF(D) FROM TB_Disciplina D WHERE D.codigo_disc =  01), 5.00);
INSERT INTO TB_Cursa VALUES (4444, 10,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  4444),(SELECT REF(D) FROM TB_Disciplina D WHERE D.codigo_disc =  10), 4.00);

alter session set nls_timestamp_format = 'dd/mm/yyyy hh24:mi:ss.ff';

INSERT INTO TB_Aula VALUES (004, 2222, 33,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  2222),(SELECT REF(S) FROM TB_SALA S WHERE S.codigo =  004),(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 33), '12/04/2018 10:00:00.00');
INSERT INTO TB_Aula VALUES (004, 2222, 33,(SELECT REF(A) FROM TB_Aluno A WHERE A.CPF_ALUNO =  2222),(SELECT REF(S) FROM TB_SALA S WHERE S.codigo =  004),(SELECT REF(P) FROM TB_Professor P WHERE P.cpf_professor = 33), '10/04/2018 08:00:00.00');