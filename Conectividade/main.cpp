#include <stdio.h>
#include <windows.h>
#include <sql.h>
#include <sqlext.h>
#include <sqltypes.h>
#include <bits/stdc++.h>


void sqlIAD(SQLHDBC *dbc, char command[]){ //Funcao para Inserir, Atualizar e Deletar
    SQLHSTMT stmt;
    SQLRETURN ret;
    SQLAllocHandle(SQL_HANDLE_STMT, (*dbc), &stmt);
    ret = SQLExecDirect(stmt,(SQLCHAR *)command,SQL_NTS);
}

void recoverPrint(SQLHDBC *dbc,char command[]){
    strcat(command,"SELECT * FROM DISCIPLINA WHERE ");
    char condicao[500];
    scanf(" %[^\n]",condicao);
    strcat(command, condicao);

    int linhas = 0;
    SQLHSTMT stmt;
    SQLRETURN ret;
    SQLLEN indicator[ 4 ];

    //Definindo atributos
    SQLLEN codigo_disc;
    SQLLEN qnt_alunos;
    SQLLEN cpf_professor;
    SQLCHAR nome[30] = "";

    stmt=NULL;
    SQLAllocHandle(SQL_HANDLE_STMT, (*dbc), &stmt);


    ret = SQLBindCol(stmt,1,SQL_C_LONG,&codigo_disc,0,&indicator[0]);
    ret = SQLBindCol(stmt,2,SQL_C_LONG,&qnt_alunos,0,&indicator[1]);
    ret = SQLBindCol(stmt,3,SQL_C_LONG,&cpf_professor,0,&indicator[2]);
    ret = SQLBindCol(stmt,4,SQL_C_CHAR,&nome,sizeof(nome),&indicator[3]);
    ret = SQLExecDirect(stmt,(SQLCHAR *)command,SQL_NTS);

    ret = SQLFetch(stmt);
    while(ret != SQL_NO_DATA){
        printf("codigo_disc: %d \t qnt_alunos: %d \t cpf_professor: %d \t nome: %s\n", codigo_disc, qnt_alunos, cpf_professor, nome);
        linhas++;
        ret = SQLFetch(stmt);
    }

    printf("Numero de linhas retornadas: %d\n", linhas);
}

int main(){
    SQLHENV env; //ambiente
    SQLHDBC dbc; //drive de conexao com o bd
    SQLHSTMT stmt;
    SQLRETURN ret;
    fflush(stdin);

    //manipulador de ambiente
     SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);

    // Seta o ambiente para oferecer suporte a ODBC 3
    SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (void *) SQL_OV_ODBC3, 0);

    //manipulador de conexao com a base de dados
    SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);

    /* Conecta ao DSN chamado "GDI"*/
    /* Mude "GDI" para o nome do DNS que você já criou*/
    SQLDriverConnect(dbc, NULL, (SQLCHAR*)"DSN=GDI;", SQL_NTS, NULL, 0, NULL, SQL_DRIVER_COMPLETE);

    int op = 1;

    while(op!= 5){

        printf("Escolha uma operacao:\n");
        printf("1. Insercao \n");
        printf("2. Atualizacao \n");
        printf("3. Remover \n");
        printf("4. Selecionar \n");
        printf("5. Encerrar \n");
        scanf("%d", &op);

        char command[1000]= "";

        if(op == 1 || op == 2 || op == 3){
            printf("Insira o comando SQL\n");
            scanf(" %[^\n]",command);
            sqlIAD(&dbc, command);
            op = 0;
        }

        else if (op == 4) {
            printf("Insira a condicao de selecao em DISCIPLINA\n");
            recoverPrint(&dbc,command);
            op = 0;
        }

        else if(op == 5) {
            break;
        }

        else {
            printf("Operacao Invalida\n");
        }
    }

    return 0;
}
