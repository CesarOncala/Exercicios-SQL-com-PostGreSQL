/*create table Departamento(
	Cod integer,
	Nome varchar(255) not null,
	Endereco varchar(500),
	Orcamento decimal,
	GCPF integer,
	Inicio Date,
	
	Primary Key (Cod)
	--Foreign Key (GCPF) references Empregado(CPF)
)

alter table Departamento 
add foreign key (GCPF) references Empregado(CPF)

create table Empregado(
	CPF char(11),
	Nome varchar(255) not null,
	Sexo char(1),
	Salario decimal,
	Depto integer not null,
	
	primary Key (CPF)
	--foreign Key (Depto) references Departamento(Cod)
)

alter table Empregado add foreign key (Depto) references Departamento(Cod)


create table Projeto (
	Cod integer,
	Nome varchar(255) not null,
	Endereco varchar(500),
	Orcamento decimal,
	Depto integer not null,
	
	primary key (Cod)
	--foreign key (Depto) references Departamento(Cod)
)


alter table Projeto add  foreign key (Depto) references Departamento(Cod)*/


/*create table Dependente(
	ECPF char(11),
	Nome varchar(255) not null,
	Parentesto varchar(150),
	Sexo char(1),
	
	primary key (ECPF,Nome),
	foreign key (ECPF) references Empregado(CPF)

)

create table Participa (
	Empregado char(11),
	Projeto integer,
	Horas Time,
	
	primary key (Empregado,Projeto),
	foreign key (Empregado) references Empregado(CPF),
	foreign key (Projeto) references Projeto(Cod)
)*/

-- 1. Qual é o nome e CPF de cada empregado?
'select' Nome as "Nome" , CPF as "CPF"
from Empregado 

-- 2. Qual é o nome e valor do orçamento de cada departamento?
select Nome as "Nome do Departamento", Orcamento as "Valor do Orçamento"
from Departamento

-- 3. Qual é o nome e salário das mulheres que ganham mais de R$ 4200,00?
select Nome as "Nome"
from Empregado
where Salario > 4200.00 and Sexo = 'F'

-- 4. Quais os nomes dos departamentos que não possuem gerente?
select Nome as "Departamento", GCPF
from Departamento
where GCPF is  null

-- 5. Qual é o nome de cada empregado e de sua esposa ou marido?
select emp.Nome as "Nome do Empregado", depen.Nome as "Conjuge"
from Empregado emp
join dependente depen on depen.ECPF = emp.CPF 
where upper(depen.parentesco) = upper('Esposa') or upper(depen.parentesco) = upper('Marido')

-- 6. Qual o nome de cada empregado e do departamento onde trabalha
select emp.Nome as "Nome do Empregado", dep.Nome as "Departamento"
from Empregado emp
join departamento dep on dep.Cod = emp.depto
order by emp.Nome

-- 7. Qual o nome de cada departamento, do seu gerente e a data em que ele se tornou gerente?
select dep.Nome  "Departamento", emp.Nome "Gerente", dep.Inicio "Data de Inicio"
from Departamento dep
join empregado emp on emp.CPF = dep.GCPF

-- 8. Qual o nome de cada projeto e do departamento que o controla?
select prj.Nome "Nome do Projeto", dep.Nome "Departamento"
from projeto prj
join departamento dep on dep.cod = prj.depto


-- 9. Qual o nome de cada empregado, seus dependentes e parentesco?
select emp.Nome as "Nome do Empregado", dep.Nome "Nome do Familiar", dep.parentesco "Grau de Parentesco"
from Empregado emp
join dependente dep on dep.ECPF = emp.cpf

-- 10. Quais os nomes das esposas dos empregados que trabalham no projeto Alfa?

select dep.Nome "Esposa"
from dependente dep
join empregado  emp on  emp.CPF = dep.ECPF
join participa on participa.empregado = emp.CPF
join projeto on projeto.cod = participa.projeto
where dep.parentesco = 'Esposa' and projeto.nome = 'Alfa'


-- 11. Qual o nome de cada projeto e dos empregados que dele participam com o número de horas semanais?

select prj.nome "Nome do Projeto", emp.Nome  "Empregado", pa.horas "Horas"
from participa pa
join empregado emp on emp.cpf = pa.empregado
join projeto prj on prj.cod = pa.projeto
group by emp.nome, prj.nome, pa.horas


-- 12. Qual o nome dos filhos dos empregados que trabalham nos departamentos de Informática e Financeiro?
select dp.Nome "Filhos"
from empregado emp
join dependente dp on dp.ecpf = emp.cpf
join departamento derp on derp.cod = emp.depto
where (derp.nome = 'Informatica' or trim(derp.nome) = trim('Financeiro')) 
and (dp.parentesco = 'Filha' or dp.parentesco = 'Filho') 


-- 13. Qual o nome dos filhos dos empregados que trabalham em projetos controlados pelo departamento de Informática?
select dp.Nome "Filhos"
from dependente dp
join empregado emp on emp.cpf = dp.ecpf
join participa ptcp on ptcp.empregado = emp.cpf
join projeto prj on prj.cod = ptcp.projeto
join departamento derp on derp.nome = 'Informatica' and prj.depto = derp.cod


-- 14. Qual o nome e o salário dos empregados que não possuem dependentes?
select emp.Nome "Empregado", emp.salario
from empregado emp
where emp.cpf not   in
(select ecpf from dependente)

select emp.Nome "Empregado", emp.salario
from empregado emp
where  not exists  (select ecpf from dependente where emp.cpf = dependente.ecpf) 

-- 15. Quais os nomes dos departamentos que não controlam nenhum projeto?
select dep.Nome "Departamento"
from departamento dep
where not exists (select proj from 
				  projeto proj
				  where dep.cod = proj.depto)
				  
				  
-- 16. Quantos empregados existem na empresa?
select count(emp.cpf) "Quantidade de funcionários"
from empregado emp

-- 17. Quanto a empresa gasta mensalmente com salários?
select sum(emp.salario) "Gastos com salários (Mensal)"
from empregado emp

-- 18. Qual é o valor do maior salário pago na empresa?
select max(emp.salario) "Maior Salário"
from empregado emp

-- 19. Qual é o valor do menor salário pago na empresa?
select min(emp.salario) "Menor Salário"
from empregado emp

-- 20. Qual é o valor do salário médio pago pela empresa?
select avg(emp.salario) "Salário Médio"
from empregado emp

-- 21. Qual é o menor valor de orçamento de projeto existente na empresa?
select min(prj.orcamento) "Menor Orçamento de Projeto"
from projeto prj

-- 22. Quais os nomes dos empregados que ganham esse maior salário?
select emp.Nome "Empregado"
from empregado emp
where emp.salario = (select max(salario)from empregado)

-- 23. Quais são os nomes e departamentos dos empregados que ganham abaixo do salário médio?
select emp.Nome "Empregado", dep.Nome "Departamento"
from empregado emp
join departamento dep on dep.cod = emp.depto
where emp.salario < (select avg(salario) from empregado)

-- 24. Quantos empregados do departamento de Informática possuem salário igual ao salário máximo?
select count(emp.cpf) total, emp.nome
from empregado emp
join departamento dep on dep.cod = emp.depto and dep.nome = 'Informatica'
group by emp.salario, emp.nome
having emp.salario =  (select max(salario)
					   from empregado emp2
					   join departamento dep on dep.cod = emp2.depto and dep.nome = 'Informatica') 
					   
-- 25. Quais os nomes dos gerentes que ganham acima do salário médio pago pela empresa?
 
select emp.nome "Gerente"
from empregado emp
join departamento derp on derp.gcpf = emp.cpf
group by emp.salario, emp.nome
having emp.salario < ( select avg(salario)
  from empregado emp
  join departamento derp on derp.gcpf = emp.cpf)

-- 26. Quais são os projetos que possuem o menor orçamento?
select proj.nome "Projeto"
from projeto proj
group by proj.nome, proj.orcamento
having proj.orcamento = (select min(orcamento) from projeto)


-- 27. Qual o nome de cada empregado e a quantidade de projetos em que trabalha?
select emp.nome "Empregado", count(*) as "Numero projetos"
from empregado emp
join participa pctp on pctp.empregado = emp.cpf
group by emp.nome

-- 28. Qual o nome de cada empregado e o total de horas semanais em que ele trabalha em projetos?
select emp.nome "Empregado", emp.cpf, sum(pctp.horas)
from empregado emp
join participa pctp on pctp.empregado = emp.cpf
group by emp.nome, emp.cpf

-- 29. Qual o nome de cada projeto com o total de horas semanais em que os empregados trabalham nesse projeto?

select proj.nome "Projeto", sum(ptcp.horas) "Total de Horas Semanais"
from projeto proj
join participa ptcp on ptcp.projeto = proj.cod
group by proj.nome

-- 30. Qual o nome e o salário dos empregados que trabalham em 2 ou mais projetos?
select emp.nome "Empregado", sum(emp.salario) "Salário"
from empregado emp
join participa ptcp on ptcp.empregado = emp.cpf
group by ptcp.empregado, emp.nome, emp.salario
having count(emp.cpf)>=2

-- 31. Qual o nome de cada departamento, o nome do gerente e a quantidade de dependentes que o gerente possui?
select dep.nome "Departamento", emp.nome "Gerente", count(depen.ecpf) "Quantidade de Dependentes"
from departamento dep
join empregado emp on emp.cpf = dep.gcpf
join dependente depen on depen.ecpf = emp.cpf
group by dep.nome, emp.nome

-- 32. Qual o nome de cada departamento e o seu número de empregados?
select dep.nome "Departamento", count(emp.cpf) "Quantidade de empregados"
from departamento dep
join empregado emp on emp.depto = dep.cod
group by dep.nome
order by 2

-- 33. Qual o nome e o endereço do departamento que possui o maior orçamento?
select dep.nome "Departamento", dep.endereco "Endereço"
from departamento dep
where dep.orcamento = (select max(orcamento) from departamento)

-- 34. Qual o nome, o salário e o sexo dos empregados que não possuem dependentes, em ordem decrescente de salário? 
select emp.nome "Empregado", emp.salario "Salário", emp.sexo "Sexo"
from empregado emp
where not exists (select ecpf from dependente depen where emp.cpf = depen.ecpf)
order by emp.salario desc

-- 35. Para cada gerente mostrar o seu nome, salário e quantidade de dependentes, em ordem decrescente de salário.
select emp.nome "Gerente", emp.salario "Salário", count(depen.ecpf)
from empregado emp
join dependente depen on depen.ecpf = emp.cpf
join departamento dep on dep.gcpf = emp.cpf
group by emp.nome, emp.salario
order by emp.salario desc

-- 36. Quais são os nomes e gerentes dos departamentos que possuem 50 ou mais empregados?
select dep.nome "Departamento", emp.nome "Gerente"
from empregado emp
join departamento dep on dep.gcpf = emp.cpf
where (select count(empregado.depto) from empregado where empregado.depto = dep.cod )>2

/*37. Para cada departamento que possui projetos controlados por ele, mostrar o seu nome, seu orçamento, a 
soma dos orçamentos dos seus projetos e o nome do seu gerente, em ordem alfabética dos seus nomes*/

select dep.nome "Departamento", dep.orcamento "Orçamento", sum(proj.orcamento) "Soma orçamento de projetos", emp.nome "Gerente"
from departamento dep
join projeto proj on proj.depto = dep.cod
join empregado emp on emp.cpf = dep.gcpf
group by dep.nome, dep.orcamento, emp.nome
order by emp.nome asc










