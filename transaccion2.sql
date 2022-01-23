create or replace procedure transaccion_dos(int,int,int,int,varchar,varchar,numeric,int,varchar)
language plpgsql
as
$$
declare
cantidads integer;
conteo integer;
total integer;
begin
SELECT cantidad into cantidads FROM  public.materias_ano where code_materia_ano=$4;
select count(*) into conteo from pensum where  codigo_docente=$2 and code_curso=$3 and code_materia_ano=$4;
	
if(conteo>0)then
raise exception 'Ya creado una clase similar';
else
total=cantidads+1;
insert into Pensum(id_pensum,codigo_docente,code_curso,code_materia_ano)VALUES ($1,$2,$3,$4);
INSERT INTO  horario(id_horario,id_pensum,horas,dias,cantidad_de_horas)VALUES($1,$1,$5,$6,$7);
INSERT INTO  tutorias(code_tutoria,id_pensum,horario)VALUES ($8,$1,$9);
UPDATE materias_ano  SET cantidad = total WHERE code_materia_ano = $4;
end if;
	exception
		when sqlstate '23514' then
		raise exception 'No se realizo la transaccion exedio el limite de clase de esa materia por año';
		rollback;
	commit;
end;
$$

call public.transaccion_dos(171,2,2,3,'prueba'::varchar,'martes'::varchar,9::numeric,1012,'prueba2'::varchar)