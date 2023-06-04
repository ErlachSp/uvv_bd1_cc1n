/*
Este é um banco de dados(bd) fictício da uvv para fins de praticar sobre banco de dados 1.
Neste bd foi criado cada tabela e estrutura seguindo um modelo de banco de dados que está representado na imagem como pdf.
*/

DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS 'erlach'@'localhost';
--excluindo banco de dados uvv e usuario caso exista

CREATE USER 'erlach'@'localhost' IDENTIFIED BY 'erlach';
--criação de usuario e permissões

CREATE DATABASE uvv;

GRANT ALL ON uvv.*  TO 'erlach'@'localhost';
flush privileges;

USE uvv;

CREATE TABLE produtos (
       produto_id                NUMERIC(38)  NOT NULL,
       nome                      VARCHAR(255) NOT NULL,
       preco_unitario            NUMERIC(10,2),
       detalhes                  LONGBLOB,
       imagem                    LONGBLOB,
       imagem_mime_type          VARCHAR(512),
       imagem_arquivo            VARCHAR(512),
       imagem_cherset            VARCHAR(512),
       imagem_ultima_atualizacao DATE,
       
       PRIMARY KEY (produto_id)
);

ALTER TABLE produtos
ADD CONSTRAINT ck_preco_unitario_produtos
CHECK
(preco_unitario > 0);
--restrição para valor não ser negativo

ALTER TABLE produtos
COMMENT 'tabela sobre informações sobre os produtos';

ALTER TABLE produtos MODIFY COLUMN produto_id                NUMERIC(38)
COMMENT 'numero de identificação do produto';

ALTER TABLE produtos MODIFY COLUMN nome                      VARCHAR(255)
COMMENT 'nome do produto';

ALTER TABLE produtos MODIFY COLUMN preco_unitario            NUMERIC(10, 2)
COMMENT 'preço unitário do produto';

ALTER TABLE produtos MODIFY COLUMN detalhes                  BLOB
COMMENT 'detalhes do produto';

ALTER TABLE produtos MODIFY COLUMN imagem                    BLOB
COMMENT 'imagem do produto';

ALTER TABLE produtos MODIFY COLUMN imagem_mime_type          VARCHAR(512)
COMMENT 'identificador de tipo de dado do arquivo da imagem';

ALTER TABLE produtos MODIFY COLUMN imagem_arquivo            VARCHAR(512)
COMMENT 'arquivo da imagem';

ALTER TABLE produtos MODIFY COLUMN imagem_cherset            VARCHAR(512)
COMMENT 'codificação de caracteres da imagem';

ALTER TABLE produtos MODIFY COLUMN imagem_ultima_atualizacao DATE
COMMENT 'ultuma atualização da imagem';


CREATE TABLE lojas (
       loja_id                 NUMERIC(38)  NOT NULL,
       nome                    VARCHAR(255) NOT NULL,
       endereco_web            VARCHAR(100),
       endereco_fisico         VARCHAR(512),
       latitude                NUMERIC,
       longitude               NUMERIC,
       logo                    LONGBLOB,
       logo_mime_type          VARCHAR(512),
       logo_arquivo            VARCHAR(512),
       logo_charset            VARCHAR(512),
       logo_ultima_atualizacao DATE,
       
       PRIMARY KEY (loja_id)
);

ALTER TABLE lojas
ADD CONSTRAINT ck_endereco
CHECK
(endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);
--checagem de endereço web e endereço fisico para uma delas não sejam nulas

ALTER TABLE lojas
COMMENT 'tabela informando o cadastro da loja';

ALTER TABLE lojas MODIFY COLUMN loja_id                 NUMERIC(38)
COMMENT 'numero de identificação da loja';

ALTER TABLE lojas MODIFY COLUMN nome                    VARCHAR(255)
COMMENT 'nome da loja';

ALTER TABLE lojas MODIFY COLUMN endereco_web            VARCHAR(100)
COMMENT 'endereço web da loja';

ALTER TABLE lojas MODIFY COLUMN endereco_fisico         VARCHAR(512)
COMMENT 'endereço fisico da loja';

ALTER TABLE lojas MODIFY COLUMN latitude                NUMERIC
COMMENT 'localização em latitude da loja';

ALTER TABLE lojas MODIFY COLUMN longitude               NUMERIC
COMMENT 'localização em longitude da loja';

ALTER TABLE lojas MODIFY COLUMN logo                    BLOB
COMMENT 'logo da loja';

ALTER TABLE lojas MODIFY COLUMN logo_mime_type          VARCHAR(512)
COMMENT 'identificador de tipo de dado do arquivo da logo';

ALTER TABLE lojas MODIFY COLUMN logo_arquivo            VARCHAR(512)
COMMENT 'arquivo do lojo da loja';

ALTER TABLE lojas MODIFY COLUMN logo_charset            VARCHAR(512)
COMMENT 'codificação de caracteres da logo';

ALTER TABLE lojas MODIFY COLUMN logo_ultima_atualizacao DATE
COMMENT 'ultima atualização da logo';


CREATE TABLE estoques (
       estoque_id NUMERIC(38) NOT NULL,
       loja_id    NUMERIC(38) NOT NULL,
       produto_id NUMERIC(38) NOT NULL,
       quantidade NUMERIC(38),
       
       PRIMARY KEY (estoque_id)
);

ALTER TABLE estoques
ADD CONSTRAINT ck_quantidade_estoques
CHECK
(quantidade > 0);
--checagem para que quantidade não seja zero

ALTER TABLE estoques
COMMENT 'tabela informando sobre os estoque';

ALTER TABLE estoques MODIFY COLUMN estoque_id NUMERIC(38)
COMMENT 'numero de identificação do estoque';

ALTER TABLE estoques MODIFY COLUMN loja_id    NUMERIC(38)
COMMENT 'numero de identificação da loja';

ALTER TABLE estoques MODIFY COLUMN produto_id NUMERIC(38)
COMMENT 'numero de identificação do produto';

ALTER TABLE estoques MODIFY COLUMN quantidade NUMERIC(38)
COMMENT 'quantidades no estoque';

CREATE TABLE clientes (
       cliente_id NUMERIC(38)  NOT NULL,
       email      VARCHAR(255) NOT NULL,
       nome       VARCHAR(255) NOT NULL,
       telefone1  VARCHAR(20),
       telefone2  VARCHAR(20),
       telefone3  VARCHAR(20),
       
       PRIMARY KEY (cliente_id)
);

ALTER TABLE clientes
COMMENT 'tabela com informações dos clientes';

ALTER TABLE clientes MODIFY COLUMN cliente_id NUMERIC(38)
COMMENT 'identificação do cliente';

ALTER TABLE clientes MODIFY COLUMN email      VARCHAR(255)
COMMENT 'email do cliente';

ALTER TABLE clientes MODIFY COLUMN nome       VARCHAR(255)
COMMENT 'nome do cliente';

ALTER TABLE clientes MODIFY COLUMN telefone1  VARCHAR(20)
COMMENT 'telefone um para contato';

ALTER TABLE clientes MODIFY COLUMN telefone2  VARCHAR(20)
COMMENT 'telefone dois para contato';

ALTER TABLE clientes MODIFY COLUMN telefone3  VARCHAR(20)
COMMENT 'telefone tres para contato';

CREATE TABLE envios (
       envio_id         NUMERIC(38)  NOT NULL,
       loja_id          NUMERIC(38)  NOT NULL,
       cliente_id       NUMERIC(38)  NOT NULL,
       endereco_entrega VARCHAR(512) NOT NULL,
       status           VARCHAR(15)  NOT NULL,
       
       PRIMARY KEY (envio_id)
);

ALTER TABLE envios
ADD CONSTRAINT ck_status_envios
CHECK
(status in ('CRIADO', 'ENVIADO', 'TRANSITO','ENTREGUE'));
--checagem para mudar status do envio

ALTER TABLE envios
COMMENT 'informações sobre os envios';

ALTER TABLE envios MODIFY COLUMN envio_id         NUMERIC(38)
COMMENT 'numero de identificação do envio';

ALTER TABLE envios MODIFY COLUMN loja_id          NUMERIC(38)
COMMENT 'numero de identificação da loja';

ALTER TABLE envios MODIFY COLUMN cliente_id       NUMERIC(38)
COMMENT 'identificação do cliente';

ALTER TABLE envios MODIFY COLUMN endereco_entrega VARCHAR(512)
COMMENT 'endereço onde a entrega será feita';

ALTER TABLE envios MODIFY COLUMN status           VARCHAR(15)
COMMENT 'status do envio';


CREATE TABLE pedidos (
       pedido_id  NUMERIC(38) NOT NULL,
       data_hora  DATETIME    NOT NULL,
       cliente_id NUMERIC(38) NOT NULL,
       status     VARCHAR(15) NOT NULL,
       loja_id    NUMERIC(38) NOT NULL,
       
       PRIMARY KEY (pedido_id)
);

ALTER TABLE pedidos
ADD CONSTRAINT ck_status_pedidos
CHECK
(status in ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO','REEMBOLSADO', 'ENVIADO'));
--checagem para alterar status do pedido

ALTER TABLE pedidos
COMMENT 'tabelas com informações de pedidos.';

ALTER TABLE pedidos MODIFY COLUMN pedido_id  NUMERIC(38)
COMMENT 'identificação do pedido';

ALTER TABLE pedidos MODIFY COLUMN data_hora  TIMESTAMP
COMMENT 'data e hora do pedido';

ALTER TABLE pedidos MODIFY COLUMN cliente_id NUMERIC(38)
COMMENT 'identificação do cliente';

ALTER TABLE pedidos MODIFY COLUMN status     VARCHAR(15)
COMMENT 'status sobre o pedido';

ALTER TABLE pedidos MODIFY COLUMN loja_id    NUMERIC(38)
COMMENT 'numero de identificação da loja';


CREATE TABLE pedidos_itens (
       pedido_id       NUMERIC(38)   NOT NULL,
       produto_id      NUMERIC(38)   NOT NULL,
       numero_da_linha NUMERIC(38)   NOT NULL,
       preco_unitario  NUMERIC(10,2) NOT NULL,
       quantidade      NUMERIC(38)   NOT NULL,
       envio_id        NUMERIC(38)   NOT NULL,
       
       PRIMARY KEY (pedido_id, produto_id)
);

ALTER TABLE pedidos_itens
ADD CONSTRAINT ck_preco_unitario_pedidos_itens
CHECK
(preco_unitario > 0);
--checagem para que preço unitário seja maior que zero

ALTER TABLE pedidos_itens ADD CONSTRAINT ck_quantidade_pedidos_itens CHECK (quantidade > 0);
--checagem para que quantidade de intens seja maior que zero


ALTER TABLE pedidos_itens
COMMENT 'tabela informando os itens dos pedidos.';

ALTER TABLE pedidos_itens MODIFY COLUMN pedido_id       NUMERIC(38)
COMMENT 'identificação do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN produto_id      NUMERIC(38)
COMMENT 'numero de identificação do produto';

ALTER TABLE pedidos_itens MODIFY COLUMN numero_da_linha NUMERIC(38)
COMMENT 'numero da linha dos itens do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN preco_unitario  NUMERIC(10, 2)
COMMENT 'preço unitario de cada item do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN quantidade      NUMERIC(38)
COMMENT 'quantidades de itens do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN envio_id        NUMERIC(38)
COMMENT 'numero de identificação do envio';


ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES   produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES   produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES   lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES   lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES   lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES   clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES   clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES   envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES   pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
