-- Funções
create function testeSoma(x integer, y integer) returns int as $$
	select x + y
$$language sql

select testeSoma(1,2)

drop function firstpl

create or replace function firstPl(x integer, out test char(255),out test2 integer) returns setof RECORD/*table(variavel2 char(255), x1 integer)*/ as $$ 
	declare variavel char(255) default '';
	begin
	
	case
		when x>0 and x<=14 then variavel = 'Olá Amigo';
		when x>14 then variavel = 'Olá Amiga';
		else  variavel := 'Olá Pessoal';
	end case;
	
	 --variavel := x * 2;
	 test = variavel;
	 test2 = x;
	 
	 return query select test,test2;
	 
	end;
$$ language plpgsql;


select * from firstPl(15)

do &&   && -- chamada anonima

-- return setof 'nome da tabela' traz um conjunto de dados ao invés de exclusivamenteo  primeiro

drop function incrementacpf

create or replace function NumerosPrimos(qtyNPrimo integer) returns  setof integer as $$
declare itensQty integer;
declare isPrimo integer default 0;
begin
	
	itensqty = qtyNPrimo;

	
	for	i in 1..itensqty  loop
			
		begin
			 for anterior in 1..(i)   loop	
					case 
					   when (i % anterior) = 0 then  isprimo := isprimo +1;
					   else isprimo := isprimo + 0;
					end case;					
			end loop;
		end;
				
		begin
		  if isprimo = 2 then return next i;
		  end if;
		end;
		raise notice 'Value: %', i;
		isprimo := 0;
	
		
	end loop;
end
$$ language plpgsql

select  NumerosPrimos(100)

-- Triggers
 
-- transaction
begin transaction

drop table itensqty

commit

--








