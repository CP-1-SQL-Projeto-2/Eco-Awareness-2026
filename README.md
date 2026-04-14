# 🌿 Eco-Awareness 2026 - Sistema de Cashback Progressivo

O **Eco-Awareness 2026** é uma solução integrada desenvolvida para o **Checkpoint 2** do curso da FIAP. O sistema foca na automação de recompensas para participantes de eventos de sustentabilidade, utilizando uma integração robusta entre uma interface Web (Flask) e lógica procedimental de banco de dados (Oracle PL/SQL).

---

## 🚀 Funcionalidades Principais

- **Processamento em Lote:** Utilização de **Cursores Explícitos** em PL/SQL para processar múltiplos participantes de uma só vez.
- **Algoritmo de Cashback Progressivo:**
    - **Fidelidade (25%):** Para usuários com histórico superior a 3 presenças confirmadas.
    - **Categoria VIP (20%):** Para inscrições identificadas como Premium.
    - **Padrão (10%):** Para os demais participantes presentes no evento.
- **Relatórios Dinâmicos:** Exibição imediata dos logs de processamento na interface após a execução.
- **Segurança de Infraestrutura:** Uso de variáveis de ambiente para proteção de credenciais do banco de dados em ambiente de nuvem (Vercel).

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia |
| :--- | :--- |
| **Linguagem Principal** | Python 3.12 |
| **Framework Web** | Flask |
| **Banco de Dados** | Oracle SQL |
| **Lógica Procedural** | PL/SQL (Blocos Anônimos e Cursores) |
| **Hospedagem** | Vercel |
| **Versionamento** | Git + GitHub |

---

## 📐 Estrutura do Banco de Dados

O banco de dados foi modelado para garantir a rastreabilidade total das operações:

1.  **`usuarios`**: Contém os dados dos participantes e o saldo acumulado de cashback.
2.  **`inscricoes`**: Tabela de relacionamento que vincula usuários a eventos, definindo status de presença e tipo de entrada.
3.  **`log_auditoria`**: Registra cada transação efetuada pelo sistema, permitindo conferência e transparência.

---

## 👥 Divisão de Responsabilidades do Grupo

Para a execução deste projeto, a equipe dividiu as tarefas seguindo o modelo de frentes de desenvolvimento:

**Integrante 1: Back-end & Engenharia de Dados**
- Modelagem do banco de dados e criação de scripts DDL.
- Desenvolvimento da lógica procedimental em **PL/SQL** (Cálculos de cashback e manipulação de cursores).
- Configuração do driver `oracledb` e tratamento de transações (Commit/Rollback) no Python.

**Integrante 2: Front-end & DevOps**
- Criação da interface web utilizando **HTML5** e **CSS3** (Tema Dark Moderno).
- Implementação de templates dinâmicos com **Jinja2** para exibição de relatórios.
- Configuração da pipeline de deploy na **Vercel** e gerenciamento de Environment Variables.

---

## ⚙️ Instalação e Execução Local

1.  **Clone o Repositório:**
    ```bash
    git clone [https://github.com/CP-1-SQL-Projeto-2/Eco-Awareness-2026.git](https://github.com/CP-1-SQL-Projeto-2/Eco-Awareness-2026.git)
    ```
2.  **Instale as Dependências:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Configure o `.env`:**
    Crie um arquivo `.env` na raiz com suas credenciais:
    ```text
    DB_USER=seu_rm
    DB_PASSWORD=sua_senha
    DB_DSN=oracle.fiap.com.br:1521/ORCL
    ```
4.  **Inicie o Servidor:**
    ```bash
    python app.py
    ```

---

## 👥 Integrantes
João Pedro Pereira Camilo | RM 562005

Pamella Christiny Chaves Brito |  RM 565206

## 📝 Licença
Projeto desenvolvido para fins acadêmicos - **FIAP 2026**.
