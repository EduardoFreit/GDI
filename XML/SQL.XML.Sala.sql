SET serveroutput ON;
DECLARE
    ctx dbms_xmlgen.ctxhandle;
    resulta clob;
BEGIN
    ctx := dbms_xmlgen.newContext('select S.codigo, S.centro from TB_Sala S');
    DBMS_XMLGEN.setRowsetTag(ctx, 'SALAS');
    DBMS_XMLGEN.setRowTag(ctx,'SALA');
    resulta := dbms_xmlgen.getXML(ctx);
    dbms_output.put_line(resulta);
    dbms_xmlgen.closeContext(ctx);
END;
/