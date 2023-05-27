/*
a
*/
DROP DATABASE IF EXISTS uvv;
DROP USER     IF EXISTS erlach;
--excluindo banco de dados uvv e usuario caso exista

CREATE USER erlach WITH createdb createrole encrypted password 'erlach';
--criação de usuario e permissões

CREATE DATABASE uvv 
    WITH 
    OWNER             = erlach
    TEMPLATE          = template0
    ENCODING          = 'UTF8'
    LC_COLLATE        = 'pt_BR.UTF-8'
    LC_CTYPE          = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;
--criando BD

\c "dbname=uvv user=erlach password=erlach";
--comando para entrar no banco de dados automaticamente e usuario

CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION erlach;
--criação do esquema loja

ALTER USER erlach
SET SEARCH_PATH TO lojas, "$user", public;
--alterando o esquema como padrão 'lojas'

CREATE TABLE lojas.produtos (
       produto_id 		 NUMERIC (38)    NOT NULL,
       nome                      VARCHAR(255)    NOT NULL,
       preco_unitario            NUMERIC (10,2),
       detalhes                  BYTEA,
       imagem                    BYTEA,
       imagem_mime_type          VARCHAR (512),
       imagem_arquivo            VARCHAR (512),
       imagem_cherset            VARCHAR (512),
       imagem_ultima_atualizacao DATE,
	   
       CONSTRAINT produto_pk PRIMARY KEY (produto_id)
);

ALTER TABLE lojas.produtos
ADD CONSTRAINT ck_preco_unitario_produtos
CHECK
(preco_unitario > 0);
--restrição para valor não ser negativo

COMMENT ON TABLE  lojas.produtos                           IS 'tabela sobre informações sobre os produtos';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'preço unitário do produto';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'detalhes do produto';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'identificador de tipo de dado do arquivo da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'arquivo da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_cherset            IS 'codificação de caracteres da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'ultuma atualização da imagem';


CREATE TABLE lojas.lojas (
       loja_id                 NUMERIC (38)  NOT NULL,
       nome                    VARCHAR (255) NOT NULL,
       endereco_web            VARCHAR (100),
       endereco_fisico         VARCHAR (512),
       latitude                NUMERIC,
       longitude               NUMERIC,
       logo                    BYTEA,
       logo_mime_type          VARCHAR (512),
       logo_arquivo            VARCHAR (512),
       logo_charset            VARCHAR (512),
       logo_ultima_atualizacao DATE,
	   
       CONSTRAINT loja_pk PRIMARY KEY (loja_id)
);

ALTER TABLE lojas.lojas
ADD CONSTRAINT ck_endereco
CHECK
(endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);
--checagem de endereço web e endereço fisico para uma delas não sejam nulas

COMMENT ON TABLE  lojas.lojas                         IS 'tabela informando o cadastro da loja';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'endereço web da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'endereço fisico da loja';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'localização em latitude da loja';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'localização em longitude da loja';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'identificador de tipo de dado do arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'arquivo do lojo da loja';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'codificação de caracteres da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'ultima atualização da logo ';


CREATE TABLE lojas.estoques (
       estoque_id  NUMERIC (38) NOT NULL,
       loja_id     NUMERIC (38) NOT NULL,
       produto_id  NUMERIC (38) NOT NULL,
       quantidade  NUMERIC (38),
	   
       CONSTRAINT estoque_pk PRIMARY KEY (estoque_id)
);

ALTER TABLE lojas.estoques
ADD CONSTRAINT ck_quantidade_estoques
CHECK
(quantidade > 0);
--checagem para que quantidade não seja zero

COMMENT ON TABLE  lojas.estoques            IS 'tabela informando sobre os estoque';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'numero de identificação do estoque';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidades no estoque';


CREATE TABLE lojas.clientes (
       cliente_id  NUMERIC (38)  NOT NULL,
       email       VARCHAR (255) NOT NULL,
       nome        VARCHAR (255) NOT NULL,
       telefone1   VARCHAR (20),
       telefone2   VARCHAR (20),
       telefone3   VARCHAR (20),
	   
       CONSTRAINT cliente_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE  lojas.clientes            IS 'tabela com informações dos clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'identificação do cliente';
COMMENT ON COLUMN lojas.clientes.email      IS 'email do cliente';
COMMENT ON COLUMN lojas.clientes.nome       IS 'nome do cliente';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'telefone um para contato';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'telefone dois para contato';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'telefone tres para contato';


CREATE TABLE lojas.envios (
       envio_id          NUMERIC (38)  NOT NULL,
       loja_id           NUMERIC (38)  NOT NULL,
       cliente_id        NUMERIC (38)  NOT NULL,
       endereco_entrega  VARCHAR (512) NOT NULL,
       status            VARCHAR (15)  NOT NULL,
	   
       CONSTRAINT envio_pk PRIMARY KEY (envio_id)
);

ALTER TABLE lojas.envios
ADD CONSTRAINT ck_status_envios
CHECK
(status in ('CRIADO', 'ENVIADO', 'TRANSITO','ENTREGUE'));
--checagem para mudar status do envio

COMMENT ON TABLE  lojas.envios                  IS 'informações sobre os envios';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'numero de identificação do envio';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'identificação do cliente';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'endereço onde a entrega será feita';
COMMENT ON COLUMN lojas.envios.status           IS 'status do envio';


CREATE TABLE lojas.pedidos (
       pedido_id   NUMERIC   (38)  NOT NULL,
       data_hora   TIMESTAMP       NOT NULL,
       cliente_id  NUMERIC   (38)  NOT NULL,
       status      VARCHAR   (15)  NOT NULL,
       loja_id     NUMERIC   (38)  NOT NULL,
	   
	   CONSTRAINT pedido_pk PRIMARY KEY (pedido_id)
);

ALTER TABLE lojas.pedidos
ADD CONSTRAINT ck_status_pedidos
CHECK
(status in ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO','REEMBOLSADO', 'ENVIADO'));
--checagem para alterar status do pedido

CREATE TABLE lojas.pedidos_itens (
       pedido_id        NUMERIC (38)    NOT NULL,
       produto_id       NUMERIC (38)    NOT NULL,
       numero_da_linha  NUMERIC (38)    NOT NULL,
       preco_unitario   NUMERIC (10,2)  NOT NULL,
       quantidade       NUMERIC (38)    NOT NULL,
       envio_id         NUMERIC (38)    NOT NULL,
				
       CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id, produto_id)
);

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT ck_preco_unitario_pedidos_itens
CHECK
(preco_unitario > 0);
--checagem para que preço unitário seja maior que zero


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT ck_quantidade_pedidos_itens CHECK (quantidade > 0);
--checagem para que quantidade de intens seja maior que zero


COMMENT ON TABLE  lojas.pedidos_itens                 IS 'tabela informando os itens dos pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'identificação do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'numero da linha dos itens do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'preço unitario de cada item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'quantidades de itens do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'numero de identificação do envio';



ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY                  (produto_id)
REFERENCES  lojas.produtos   (produto_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY                 (produto_id)
REFERENCES  lojas.produtos  (produto_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY               (loja_id)
REFERENCES  lojas.lojas   (loja_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY              (loja_id)
REFERENCES  lojas.lojas  (loja_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY              (loja_id)
REFERENCES  lojas.lojas  (loja_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY                 (cliente_id)
REFERENCES  lojas.clientes  (cliente_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY                 (cliente_id)
REFERENCES  lojas.clientes  (cliente_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY               (envio_id)
REFERENCES  lojas.envios  (envio_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY                (pedido_id)
REFERENCES  lojas.pedidos  (pedido_id)
ON  DELETE NO ACTION
ON  UPDATE NO ACTION
NOT DEFERRABLE;
