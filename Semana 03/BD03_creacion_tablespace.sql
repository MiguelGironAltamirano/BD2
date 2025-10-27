
--------------------------------------------------------------------------------
-- [1] TABLESPACES (ajusta rutas a tu host si no usas OMF)
--------------------------------------------------------------------------------
CREATE TABLESPACE ciclismo_data
DATAFILE 'C:\app\migue\product\21c\oradata\XE\PDB1\ciclismo_data01.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 50M MAXSIZE 2G;

CREATE TEMPORARY TABLESPACE ciclismo_temp
TEMPFILE 'C:\app\migue\product\21c\oradata\XE\PDB1\ciclismo_temp01.dbf'
SIZE 128M
AUTOEXTEND ON NEXT 50M MAXSIZE 1G;