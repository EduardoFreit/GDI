INSERT INTO Curso(codigo, nome, nota_mec) VALUES (001, 'Engenharia da Computação', 10.00);
INSERT INTO Curso(codigo, nome, nota_mec) VALUES (002, 'Letras', 8.50);
INSERT INTO Curso(codigo, nome, nota_mec) VALUES (003, 'Matemática', 9.52);
INSERT INTO Curso(codigo, nome, nota_mec) VALUES (004, 'Ciência Política', 7.60);
INSERT INTO Curso(codigo, nome, nota_mec) VALUES (005, 'Ciência da Computação', 6.20);
INSERT INTO Curso(codigo, nome, nota_mec) VALUES (006, 'Arquitetura', 8.24);

INSERT INTO Bacharelado(codigo, linha_de_pesquisa) VALUES (001, 'Informática');
INSERT INTO Bacharelado(codigo, linha_de_pesquisa) VALUES (004, 'Política');
INSERT INTO Bacharelado(codigo, linha_de_pesquisa) VALUES (005, 'Informática');
INSERT INTO Bacharelado(codigo, linha_de_pesquisa) VALUES (006, 'Urbanismo');

INSERT INTO Licenciatura(codigo, disciplinas_obrigatorias) VALUES (002, 'Metodologia');
INSERT INTO Licenciatura(codigo, disciplinas_obrigatorias) VALUES (003, 'Pedagogia');

INSERT INTO Endereco(cep, descricao) VALUES (00000, 'Rua dos Bobos');
INSERT INTO Endereco(cep, descricao) VALUES (00020, 'Rua dos Caras Dahoras');
INSERT INTO Endereco(cep, descricao) VALUES (00040, 'Rua de Cima');
INSERT INTO Endereco(cep, descricao) VALUES (00060, 'Rua de Baixo');
INSERT INTO Endereco(cep, descricao) VALUES (00080, 'Rua Esburacada');
INSERT INTO Endereco(cep, descricao) VALUES (57020, 'Rua Formosa');

INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (0000, to_date('07/04/1998', 'dd/mm/yyyy'), 001, NULL, 'Vitor', 00020);
INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (1111, to_date('26/03/1998', 'dd/mm/yyyy'), 006, 0000, 'Maria', 57020);
INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (2222, to_date('07/06/1998', 'dd/mm/yyyy'), 003, 1111, 'Lucas', 00080);
INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (3333, to_date('25/08/1998', 'dd/mm/yyyy'), 002, 2222, 'Allex', 00040);
INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (4444, to_date('13/11/1998', 'dd/mm/yyyy'), 005, 1111, 'Karol', 00000);
INSERT INTO Aluno(cpf_aluno, data_nasc, codigo_curso, cpf_padrinho, nome, cep) VALUES (5555, to_date('02/01/1999', 'dd/mm/yyyy'), 004, 0000, 'Sammy', 00060);

INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (11, to_date('28/02/1990', 'dd/mm/yyyy'), 'ACM');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (22, to_date('21/03/1987', 'dd/mm/yyyy'), 'RMAS');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (33, to_date('19/12/1972', 'dd/mm/yyyy'), 'PSGMN');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (44, to_date('09/10/1965', 'dd/mm/yyyy'), 'Romena');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (55, to_date('14/07/1978', 'dd/mm/yyyy'), 'Américo');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (66, to_date('23/05/1980', 'dd/mm/yyyy'), 'Castor');
INSERT INTO Professor(cpf_professor, data_nasc, nome) VALUES (77, to_date('02/06/1985', 'dd/mm/yyyy'), 'ASG');

INSERT INTO Email(email, cpf_professor) VALUES ('acm@cin.ufpe.br', 11);
INSERT INTO Email(email, cpf_professor) VALUES ('rmas@cin.ufpe.br', 22);
INSERT INTO Email(email, cpf_professor) VALUES ('psgmn@cin.ufpe.br', 33);
INSERT INTO Email(email, cpf_professor) VALUES ('romena@ufpe.br', 44);
INSERT INTO Email(email, cpf_professor) VALUES ('americo@ufpe.br', 55);
INSERT INTO Email(email, cpf_professor) VALUES ('castor@cin.ufpe.br', 66);
INSERT INTO Email(email, cpf_professor) VALUES ('fjclf@cin.ufpe.br', 66);
INSERT INTO Email(email, cpf_professor) VALUES ('asg@cin.ufpe.br', 77);

INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (01, 0050, 11, 'IP');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (02, 0050, 33, 'AVLC');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (03, 0020, 66, 'Desenvolvimento iOS');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (04, 0050, 44, 'Cálculo I');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (05, null, 44, 'Cálculo II');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (06, null, 44, 'Cálculo III');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (07, null, 55, 'Física I');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (08, null, 55, 'Física II');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (09, null, 55, 'Física III');
INSERT INTO Disciplina(codigo_disc, qnt_alunos, cpf_professor, nome) VALUES (10, 0030, 22, 'Métodos Numéricos');

INSERT INTO Sala(codigo, capacidade, centro) VALUES (002, 050, 'CCEN');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (003, 060, 'CCEN');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (004, 070, 'CCEN');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (005, 090, 'CCEN');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (013, 120, 'Área 2');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (015, 110, 'Área 2');
INSERT INTO Sala(codigo, capacidade, centro) VALUES (112, 050, 'CIN');

INSERT INTO Ic(codigo, data_inic, tema, cpf_aluno) VALUES (01, to_date('19/02/2018', 'dd/mm/yyyy'), 'IoT', 0000);
INSERT INTO Ic(codigo, data_inic, tema, cpf_aluno) VALUES (02, to_date('19/02/2017', 'dd/mm/yyyy'), 'TNA', 1111);
INSERT INTO Ic(codigo, data_inic, tema, cpf_aluno) VALUES (03, to_date('19/02/2016', 'dd/mm/yyyy'), 'PSB', 5555);

INSERT INTO Projeto(cpf_professor, titulo, descricao, investimento) VALUES (77, 'LMS', 'Learning Management Systems', 200000.00);
INSERT INTO Projeto(cpf_professor, titulo, descricao, investimento) VALUES (22, 'OTI', 'Otimization', 15000.00);
INSERT INTO Projeto(cpf_professor, titulo, descricao, investimento) VALUES (66, 'GIT', 'Code Analytics', 100000.00);

INSERT INTO Cursa(cpf_aluno, codigo_disc, media) VALUES (0000, 1, 10.0);
INSERT INTO Cursa(cpf_aluno, codigo_disc, media) VALUES (0000, 2, 9.50);
INSERT INTO Cursa(cpf_aluno, codigo_disc, media) VALUES (2222, 5, 8.50);
INSERT INTO Cursa(cpf_aluno, codigo_disc, media) VALUES (2222, 1, 5.00);
INSERT INTO Cursa(cpf_aluno, codigo_disc, media) VALUES (4444, 10, 4.00);

alter session set nls_timestamp_format = 'dd/mm/yyyy hh24:mi:ss.ff';

INSERT INTO Aula(codigo_sala, cpf_aluno, cpf_professor, horario) VALUES (004, 2222, 33, '12/04/2018 10:00:00.00');
INSERT INTO Aula(codigo_sala, cpf_aluno, cpf_professor, horario) VALUES (004, 2222, 33, '10/04/2018 08:00:00.00');