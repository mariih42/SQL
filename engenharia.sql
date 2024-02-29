-- Criar e usar banco de dados

create database engenharia
go

use database engenharia
go

--tabela Funcionário

create table Funcionario
(
	idFunc		int not null primary key identity,
	nome		varchar(50) not null,
	cpf		varchar(14) not null unique,
	dataNasc	varchar(10) not null,
	status		int null check(status in(1,2))
)
go

-- tabela de Dependentes

create table Dependentes
(
	idDependente	int not null primary key identity,
	nome		varchar(50) not null,
	idade		int not null,
	parentesco	varchar(200) not null,
	IdFunc		int not null,
	foreign key (IdFunc) references Funcionario(idFunc)
)
go

-- tabela de Departamentos

create table Departamentos
(
	idDepto		int not null primary key identity,
	nome		varchar(50) not null,
	local		varchar(100) not null,
	telefone	varchar(10) not null unique
)
go

-- tabela de Tecnico

create table Tecnico
(
	idFunc		int not null primary key,
	idTecnico	int not null,
	qtdHora		float,
	valorHora	money,
	salario		money not null,
	foreign key(idFunc) references Funcionario(idFunc)
)
go

-- tabela de Engenheiro

create table Engenheiro
(
	idFunc		int not null primary key,
	especialidade	varchar(500),
	anosExp		int not null,
	-- 1 - junior | 2 - master | 3- sênior
	classificacao	int not null check(classificacao in(1,2,3)),
	idDepto		int not null references Departamentos(idDepto),
	foreign key(idFunc) references Funcionario(idFunc)
)
go


-- tabela Projeto

create table Projeto
(
	idProjeto	int not null primary key identity,
	nome		varchar(50) not null,
	local		varchar(150) not null,
	orçamento	money,
	deptoId		int not null,
	foreign key (deptoId) references Departamentos(idDepto)
)
go

-- ligar engenheiro a projeto

create table EngenheiroProjeto
(
	idEngenheiro int not null,
	idFunc	int not null,
    	idProjeto	int not null,
	qtdHoras int	null,
	primary key (idEngenheiro, idProjeto),
    	foreign key (idEngenheiro) references Engenheiro(idFunc),
    	foreign key (idProjeto) references Projeto(idProjeto)
)
go

-- ligar técnico a projeto

create table TecnicoProjeto
(
	idTecnico	int not null,
	idProjeto	int not null,
	salario		money,
	qtdHoras	int null,
	primary key(idTecnico, idProjeto),
	foreign key (idTecnico) references Funcionario(idFunc),
	foreign key (idProjeto) references Projeto(idProjeto)
)
go

-- cadastrar Departamentos


create procedure sp_CadDepto
(
	@nome		varchar(50),
	@local		varchar(100),
	@telefone	varchar(15)
)
as
begin

	insert into Departamentos(nome, local, telefone)
	values (@nome, @local, @telefone)
end
go

exec sp_CadDepto 'Engenharia', 'Rio Preto', '988093561'
go

exec sp_CadDepto 'Recursos Humanos', 'Rio Preto', '981605528'
go

exec sp_CadDepto 'Financeiro', 'Rio Preto', '981257090'
go

-- cadastrar engenheiro. 

create procedure sp_CadEngenheiro
(
	@nome		varchar(50),
	@cpf		varchar(14),
	@dataNasc	varchar(10),
	@anosExp	int,
	@especialidade	varchar(50),
	@classificacao	int,
	@IdDepto	int,
	@status		int
)
as 
begin


	insert into Funcionario(nome, cpf, dataNasc, status)
	values (@nome, @cpf, @dataNasc, @status)

	insert into Engenheiro(idFunc, especialidade, anosExp, classificacao, idDepto)
	values (@@IDENTITY, @especialidade, @anosExp, @classificacao, @IdDepto)
 end
 go

-- 5 engenheiros

    
exec sp_CadEngenheiro 1, 'Geraldo dos Santos', '349.881.240-88', '1964-05-19', 5, 'Engenheiro Mecânico', 1, 2, 1
go
	
exec sp_CadEngenheiro 2, 'Joana Matazzini', '012.807.020-01', '1984-02-02', 7, 'Engenheira Civil', 2, 1, 1
go

exec sp_CadEngenheiro 3, 'Joaquim Cardozo', '324.519.200-25', '1897-08-26', 16, 'Engenheiro Estrutural', 3, 1, 1
go

exec sp_CadEngenheiro 4, 'Mário Schenberg', '974.847.400-39', '1914-07-02', 14, 'Engenheiro Elétrico', 3, 1, 1
go

exec sp_CadEngenheiro 5, 'Evaristo de Moraes Filho', '867.990.190-33', '1914-07-05', 13, 'Engenheiro Químico', 3, 1, 1
go


	select * from Engenheiro
	go 


-- procedure para cadastrar técnico.

create procedure sp_CadTecnico
(
	@idFunc			int,
	@nome			varchar(50),
	@cpf			varchar(11),
	@dataNasc		varchar(15),
	@qtdHora		float,
	@valorHora		money,
	@salario		money
)
as
begin 

insert into Funcionario(nome, cpf, dataNasc, status)
values (@nome, @cpf, @dataNasc, @status)

insert into Tecnico(idFunc, qtdHora, valorHora, salario)
values (@@IDENTITY, @qtdHora, @valorHora, @salario)
end
go

exec sp_CadTecnico 6,'Jorge Rodrigues', '077.954.120-09', '1982-10-25', 135, 525.00, 2500.00
go

exec sp_CadTecnico 7,'Alexandre Stefanno', '400.153.160-76', '1994-12-08', 95, 489.00, 1950.00
go

exec sp_CadTecnico 8,'Augusto Contes', '024.827.420-13', '1996-04-16', 95, 489.00, 1950.00
go

exec sp_CadTecnico 9,'Hugo Kelt', '893.965.030-10', '1991-03-25', 95, 489.00, 1950.00
go

exec sp_CadTecnico 10,'Renê Soares', '910.072.600-17', '1989-09-21', 95, 489.00, 1950.00
go

exec sp_CadTecnico 11,'Ana Ritta', '732.106.020-93', '1981-10-17', 95, 489.00, 1950.00
go

exec sp_CadTecnico 12,'Paula Steffany', '946.907.110-70', '1994-11-27', 95, 489.00, 1950.00
go

exec sp_CadTecnico 13,'Walber Campos', '223.474.180-76', '1985-01-09', 95, 489.00, 1950.00
go

exec sp_CadTecnico 14,'Richard Skelps', '291.515.910-65', '1993-07-14', 95, 489.00, 1950.00
go

exec sp_CadTecnico 15,'Carla Marques', '805.310.600-55', '1990-05-16', 95, 489.00, 1950.00
go





-- procedure para cadastrar os dependentes

create procedure sp_CadDependentes
(
	@nome		varchar(100),
	@idade		int,
	@parentesco varchar(200),
	@idFunc		int
)
as
begin

 
insert into Dependentes(nome, idade, parentesco, IdFunc)
values (@nome, @idade, @parentesco, @idFunc)
end
go

-- engenheiros

-- Evaristo de Moraes Filho
exec sp_CadDependentes 'Joana Skaly da Silva', 89, 'Esposa', 5
go

exec sp_CadDependentes 'Jorge Moraes da Silva', 28, 'Filho', 5
go

-- Mário Schenberg
exec sp_CadDependentes 'Marta Schenberg', 35, 'Filha', 4
go

exec sp_CadDependentes 'Felipe Schenberg', 19, 'Neto', 4
go

--Joana Matazzini
exec sp_CadDependentes 'Ricardo Karldin', 41, 'Esposo', 2
go

exec sp_CadDependentes 'Yudi Matazzini', 15, 'Sobrinho', 2
go

-- técnicos

-- Richard Skelps
exec sp_CadDependentes 'Paulo Skelps', 16, 'Filho', 14
go

exec sp_CadDependentes 'Felipe Skelps', 12, 'Filho', 14

-- Ana Ritta

exec sp_CadDependentes 'João Costa', 36, 'Esposo', 11
go

-- Alexandre Stefanno
exec sp_CadDependentes 'Albert Steffano', 17, 'Neto', 7
go

-- Hugo Kelt
exec sp_CadDependentes 'Adriana Kelt', 32, 'Esposa', 9
go

exec sp_CadDependentes 'Luiz Fernando Kelt', 11, 'Filho', 9
go

exec sp_CadDependentes 'Marcos Kelt', 8, 'Filho', 9
go

-- Walber Campos
exec sp_CadDependentes 'Bianca Campos', 15, 'Sobrinha', 13
go

-- procedure para cadastrar Projetos. 

create procedure sp_cadProjetos
(
	@idProjeto		int,
	@nome			varchar(50),
	@local			varchar(150),
	@orcamento		money,
	@IdDepto		int
)
as 
begin

    -- Inserir projeto
    insert into Projeto (idProjeto, nome, local, orçamento, deptoId)
    values (@@IDENTITY, @nome, @local, @orcamento, @IdDepto)
end
go

exec sp_cadProjetos 1, 'Extração de óleo de xisto', 'Rio de Janeiro', 163654.00, 1 
exec sp_cadProjetos 2, 'Auxilio Projeto Brasília', 'Brasília', 16387654.00, 1 
exec sp_cadProjetos 3, 'Conjunto Arquitetônico da Pampulha', 'Belo Horizonte', 265754.00, 1 
exec sp_cadProjetos 4, 'Ponte Rio-Niterói', 'Rio de Janeiro', 584717.00, 1 
exec sp_cadProjetos 5, 'Departamento Nacional de Estradas de Rodagem (DNER)', 'Rio de Janeiro', 526525.00, 1

-- procedure para cadastrar responsáveis pelos projetos

create procedure sp_CadEngenheiroProjeto
(
	@idFunc					int,
	@idProjeto				int,
	@idEngenheiroProjeto	int
)
as 
begin

    -- Coloca a associação 
	insert into EngenheiroProjeto(idFunc, idProjeto, idEngenheiro)
	values (@@IDENTITY, @idProjeto, @idEngenheiroProjeto)
	end
	go

	exec sp_CadEngenheiroProjeto 1, 2, 3
	go
	exec sp_CadEngenheiroProjeto 1, 1, 4
	go
	exec sp_CadEngenheiroProjeto 3, 2, 2
	go
	exec sp_CadEngenheiroProjeto 3, 4, 1
	go
	exec sp_CadEngenheiroProjeto 5, 4, 2
	go



-- procedure para cadastrar os técnicos que executam projetos


create procedure sp_CadTecnicoProjeto
(
	@idTecnico int,
	@idProjeto int,
	@salario money,
	@qtdHoras int
)
as
begin

	insert into TecnicoProjeto(idTecnico, idProjeto, salario, qtdHoras)
	values(@@IDENTITY, @@IDENTITY, @salario, @qtdHoras)
	end
	go

	exec sp_CadTecnicoProjeto 6, 5, 2607.00, 561
	exec sp_CadTecnicoProjeto 11, 4, 3620.00, 720
	exec sp_CadTecnicoProjeto 12, 2, 1987.00, 241
	exec sp_CadTecnicoProjeto 8, 3, 2846.00, 482
