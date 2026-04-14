-- 1. Tabela de Usuários
CREATE TABLE usuarios (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    prioridade NUMBER(1) CHECK (prioridade BETWEEN 1 AND 3),
    saldo NUMBER(10, 2) DEFAULT 0
);

-- 2. Tabela de Inscrições
CREATE TABLE inscricoes (
    id NUMBER PRIMARY KEY,
    evento_id NUMBER NOT NULL, -- Necessário para a sua tela puxar o ID
    usuario_id NUMBER REFERENCES usuarios(id),
    status VARCHAR2(20) DEFAULT 'PRESENT',
    valor_pago NUMBER(10, 2) NOT NULL,
    tipo VARCHAR2(20) -- Ex: 'VIP', 'COMUM'
);

-- 3. Tabela de Log (Com ID automático para facilitar o insert)
CREATE TABLE log_auditoria (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    inscricao_id NUMBER REFERENCES inscricoes(id),
    motivo VARCHAR2(255),
    data DATE DEFAULT SYSDATE
);