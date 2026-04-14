/*******************************************************************************
  PROJETO: Eco-Awareness 2026 - Checkpoint 2
  AUTOR: João Pedro Pereira Camilo   e Pamella Christiny Chaves Brito
  DESCRIÇÃO: Script de criação, carga e testes para o sistema de cashback.
*******************************************************************************/

-- 1. LIMPEZA DE AMBIENTE (CLEANUP)
-- Removemos os dados e tabelas existentes para garantir um teste do zero (idempotência).
-- A ordem de exclusão respeita as chaves estrangeiras (FKs).
DROP TABLE log_auditoria;
DROP TABLE inscricoes;
DROP TABLE usuarios;


-- 2. DEFINIÇÃO DA ESTRUTURA (DDL)
-- Criação das tabelas principais com constraints de integridade.

-- Tabela de Usuários: Armazena o perfil e o saldo acumulado.
CREATE TABLE usuarios (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    prioridade NUMBER(1) CHECK (prioridade BETWEEN 1 AND 3),
    saldo NUMBER(10, 2) DEFAULT 0
);

-- Tabela de Inscrições: Relaciona usuários a eventos e define o tipo de entrada.
CREATE TABLE inscricoes (
    id NUMBER PRIMARY KEY,
    evento_id NUMBER NOT NULL,
    usuario_id NUMBER REFERENCES usuarios(id),
    status VARCHAR2(20) DEFAULT 'PRESENT',
    valor_pago NUMBER(10, 2) NOT NULL,
    tipo VARCHAR2(20) -- Ex: 'VIP' ou 'COMUM'
);

-- Tabela de Log: Auditoria imutável dos cashbacks processados.
CREATE TABLE log_auditoria (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    inscricao_id NUMBER REFERENCES inscricoes(id),
    motivo VARCHAR2(255),
    data DATE DEFAULT SYSDATE
);


-- 3. CARGA DE DADOS PARA TESTES (DML)
-- Inserção de cenários reais para validar as regras de negócio no PL/SQL.

-- Inserindo Participantes base
INSERT INTO usuarios (id, nome, email, prioridade, saldo) VALUES (1, 'João Pedro', 'jp@fiap.com.br', 1, 0);
INSERT INTO usuarios (id, nome, email, prioridade, saldo) VALUES (2, 'Maria', 'maria@fiap.com.br', 2, 0);
INSERT INTO usuarios (id, nome, email, prioridade, saldo) VALUES (3, 'Carlos', 'carlos@fiap.com.br', 3, 0);

-- CENÁRIO EVENTO 1: Teste de processamento múltiplo
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (201, 1, 1, 'PRESENT', 100.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (202, 1, 3, 'PRESENT', 150.00, 'VIP');

-- CENÁRIO EVENTO 2: Teste de processamento individual
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (203, 2, 2, 'PRESENT', 200.00, 'COMUM');

-- CENÁRIO EVENTO 3: Validação completa das Regras de Negócio
-- João: VIP (Deve receber 20%)
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (101, 3, 1, 'PRESENT', 100.00, 'VIP');

-- Maria: Fidelidade (Histórico de 4 eventos anteriores + Evento 3 = >3 presenças. Deve receber 25%)
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (102, 90, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (103, 91, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (104, 92, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (105, 93, 2, 'PRESENT', 50.00, 'COMUM');
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (106, 3, 2, 'PRESENT', 100.00, 'COMUM');

-- Carlos: Padrão (Primeira participação COMUM. Deve receber 10%)
INSERT INTO inscricoes (id, evento_id, usuario_id, status, valor_pago, tipo) VALUES (107, 3, 3, 'PRESENT', 100.00, 'COMUM');

COMMIT;


-- 4. CONSULTAS DE VERIFICAÇÃO (AUDITORIA)
-- Utilize estes SELECTs após rodar o processamento no site para validar os resultados.

-- Verifica se o saldo dos usuários foi atualizado corretamente
SELECT nome, saldo FROM usuarios;

-- Verifica os logs detalhados gerados pelo bloco PL/SQL
SELECT * FROM log_auditoria;