create schema test; -- Criação de schema dedicado

/*
 * 
 * Criação das tabelas
 *
 */

CREATE TABLE test.venda(
	venda_id int8 NOT NULL,
	data_emissao date NOT NULL,
	horariomov varchar(8) DEFAULT '00:00:00'::character varying NOT NULL,
	produto_id varchar(25) DEFAULT ''::character varying NOT NULL,
	qtde_vendida float8 NULL,
	valor_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
	filial_id int8 DEFAULT 1 NOT NULL,
	item int4 DEFAULT 0 NOT NULL,
	unidade_medida varchar(3) NULL,
	CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov)
);

CREATE TABLE test.pedido_compra(
	pedido_id float8 DEFAULT 0 NOT NULL,
	data_pedido date NULL,
	item float8 DEFAULT 0 NOT NULL,
	produto_id varchar(25) DEFAULT '0' NOT NULL,
	descricao_produto varchar(255) NULL,
	ordem_compra float8 DEFAULT 0 NOT NULL,
	qtde_pedida float8 NULL,
	filial_id int4 NULL,
	data_entrega date NULL,
	qtde_entregue float8 DEFAULT 0 NOT NULL,
	qtde_pendente float8 DEFAULT 0 NOT NULL,
	preco_compra float8 DEFAULT 0 NULL,
	fornecedor_id int4 DEFAULT 0 NULL,
	CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id , produto_id, item)
);


CREATE TABLE test.entradas_mercadoria (
	data_entrada date NULL,
	nro_nfe varchar(255) NOT NULL,
	item float8 DEFAULT 0 NOT NULL,
	produto_id varchar(25) DEFAULT '0' NOT NULL,
	descricao_produto varchar(255) NULL,
	ordem_compra float8 default 0 not null,  --Esta coluna está relacionada ao pedido_compra.ordem_compra 
	qtde_recebida float8 NULL,
	filial_id int4 NULL,
	custo_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
	CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (ordem_compra, item, produto_id, nro_nfe)
);	

/*
 * 
 * PARTE 1
 *
 */

-- 1.1 Consulta de quantidade de produtos vendidos no mês de fevereiro.
select 
	vend.produto_id,
	prod.descricao_produto,
	sum(qtde_vendida) qt_total
from test.venda vend
inner join (
	select distinct 
	pr.produto_id,
	pr.descricao_produto
	from test.pedido_compra pr
) prod on prod.produto_id = vend.produto_id
where data_emissao >= '2025-02-01'
and data_emissao < '2025-03-01'
group by vend.produto_id, prod.descricao_produto
order by vend.produto_id;


-- 1.2 Consulta de produtos com quantidades de entrega pendentes.
select 
	comp.produto_id,
	comp.descricao_produto,
	sum(comp.qtde_pedida) qtde_pedida_total,
	sum(comp.qtde_entregue) qtde_entregue_total,
	sum(comp.qtde_pendente) qtde_pendente_total
from test.pedido_compra	comp
group by comp.produto_id, comp.descricao_produto
having sum(comp.qtde_pendente) > 0
order by comp.produto_id;


-- 1.3 Consulta de produtos sem consumo (vendas), requisitados e não recebidos.
select 
	comp.produto_id,
	comp.descricao_produto,
	sum(comp.qtde_pedida) qtde_pedida_total,
	sum(comp.qtde_entregue) qtde_entregue_total,
	sum(comp.qtde_pendente) qtde_pendente_total
from test.pedido_compra	comp
where comp.data_entrega >='2025-02-01'
and comp.data_entrega < '2025-03-01'
and comp.produto_id not in 
	(select distinct v.produto_id 
	from test.venda v 
	where v.produto_id = comp.produto_id
	and v.data_emissao >= '2025-02-01'
	and v.data_emissao < '2025-03-01')
group by comp.produto_id, comp.descricao_produto
having sum(comp.qtde_entregue) = 0
order by comp.produto_id;



-- 2 Transformação de dados.
select 
	produto_id || ' - ' || descricao_produto as , 
	qtde_pedida as "Quantidade requisitada",
	to_char(data_pedido, 'dd/mm/yyyy')
from test.pedido_compra;





