DELETE FROM log_auditoria;

DELETE FROM inscricoes;

DELETE FROM usuarios;

CREATE TABLE usuarios (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    prioridade NUMBER(1) CHECK (prioridade BETWEEN 1 AND 3),
    saldo NUMBER(10, 2) DEFAULT 0
);

CREATE TABLE inscricoes (
    id NUMBER PRIMARY KEY,
    evento_id NUMBER NOT NULL,
    usuario_id NUMBER REFERENCES usuarios(id),
    status VARCHAR2(20) DEFAULT 'PRESENT',
    valor_pago NUMBER(10, 2) NOT NULL,
    tipo VARCHAR2(20)
);

CREATE TABLE log_auditoria (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    inscricao_id NUMBER REFERENCES inscricoes(id),
    motivo VARCHAR2(255),
    data DATE DEFAULT SYSDATE
);

DELETE FROM log_auditoria;
DELETE FROM inscricoes;
DELETE FROM usuarios;

INSERT INTO usuarios (id, nome, email, prioridade, saldo) 
VALUES (1, 'João Pedro', 'jp@fiap.com.br', 1, 0);

INSERT INTO usuarios (id, nome, email, prioridade, saldo) 
VALUES (2, 'Maria', 'maria@fiap.com.br', 2, 0);

INSERT INTO usuarios (id, nome, email, prioridade, saldo) 
VALUES (3, 'Carlos', 'carlos@fiap.com.br', 3, 0);


INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (101, 3, 1, 'PRESENT', 100.00, 'VIP');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (102, 90, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (103, 91, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (104, 92, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (105, 93, 2, 'PRESENT', 50.00, 'COMUM');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (201, 1, 1, 'PRESENT', 100.00, 'COMUM');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (202, 1, 3, 'PRESENT', 150.00, 'VIP');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (203, 2, 2, 'PRESENT', 200.00, 'COMUM');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (106, 3, 2, 'PRESENT', 100.00, 'COMUM');

INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) 
VALUES (107, 3, 3, 'PRESENT', 100.00, 'COMUM');

COMMIT;
