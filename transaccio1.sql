create or replace procedure transaccion_uno(int,money,date)
language plpgsql
as
$$
declare
	res numeric;
	cantidad numeric;
	total numeric;
	begin
	res=$2::numeric;
			SELECT  matricula.cantidad into cantidad FROM public.matricula where code_matricula =$1;
			total=cantidad-res;	
			
if(total=0.00) then
insert into matricula_pago(code_matricula,pago,fecha)values ($1,$2,$3);
	UPDATE matricula SET cantidad =total where code_matricula=$1;
UPDATE MATRICULA_detalle SET estado = 'Pagado' WHERE code_matricula =$1;
else

insert into matricula_pago(code_matricula,pago,fecha)values ($1,$2,$3);
	UPDATE matricula SET cantidad =total where code_matricula=$1;
UPDATE MATRICULA_detalle SET estado = 'En progreso' WHERE code_matricula =$1;
end if;
	exception
		when sqlstate '23514' then
		raise exception 'No se realizo la transaccion exedio el pago de la deuda';
		rollback;
	commit;
	
	




	
end;


$$

call public.transaccion_uno(80,10.00::money,'2020-02-15'::date)