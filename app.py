import os
import oracledb
from flask import Flask, request, render_template

app = Flask(__name__)

# Lógica de conexão com o banco (SEGURA - Usando Vercel Environment Variables)
def get_db_connection():
    try:
        return oracledb.connect(
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            dsn=os.environ.get("DB_DSN")
        )
    except Exception as e:
        print(f"Erro na conexão: {e}")
        return None
    
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/processar_cashback', methods=['POST'])
def processar_cashback():
    evento_id = request.form.get('evento_id')

    if not evento_id or not evento_id.isdigit():
        return render_template('feedback.html', message="ID do evento inválido. Por favor, insira um número válido.", status="error")
    
    plsql_block = """
        DECLARE
            CURSOR c_participantes IS
                SELECT id AS inscricao_id, usuario_id, valor_pago, tipo
                FROM inscricoes
                WHERE evento_id = :p_evento_id 
                  AND status = 'PRESENT'; -- Corrigido: O ponto e vírgula é só no final!

            v_inscricao_id inscricoes.id%TYPE;
            v_usuario_id inscricoes.usuario_id%TYPE;
            v_valor_pago inscricoes.valor_pago%TYPE;
            v_tipo inscricoes.tipo%TYPE;
            
            v_total_presencas NUMBER;
            v_taxa_cashback NUMBER;
            v_valor_estorno NUMBER;
        BEGIN
            OPEN c_participantes;
            
            LOOP
                FETCH c_participantes INTO v_inscricao_id, v_usuario_id, v_valor_pago, v_tipo;
                EXIT WHEN c_participantes%NOTFOUND;

                -- contagem de histórico
                SELECT COUNT(id)
                INTO v_total_presencas
                FROM inscricoes
                WHERE usuario_id = v_usuario_id
                  AND status = 'PRESENT';

                -- Escalonamento (25%, 20% ou 10%)
                IF v_total_presencas > 3 THEN
                    v_taxa_cashback := 0.25;
                ELSIF v_tipo = 'VIP' THEN     -- Corrigido: Em PL/SQL se escreve ELSIF (sem o E do meio)
                    v_taxa_cashback := 0.20;
                ELSE
                    v_taxa_cashback := 0.10;
                END IF;

                v_valor_estorno := v_valor_pago * v_taxa_cashback;
                
                -- Atualiza o saldo do usuário
                UPDATE usuarios
                SET saldo = NVL(saldo, 0) + v_valor_estorno
                WHERE id = v_usuario_id;

                -- Insere o log de auditoria
                INSERT INTO log_auditoria (inscricao_id, motivo, data)
                VALUES(
                    v_inscricao_id,           -- Corrigido: Faltava o "s" na sua variável
                    'Cashback: ' || (v_taxa_cashback * 100) || '% | Presenças: ' || v_total_presencas,
                    SYSDATE
                );

            END LOOP;
            CLOSE c_participantes;
        END;
    """

    conexao = None
    cursor = None
    try:
        conexao = get_db_connection()
        
        if conexao is None:
            return render_template('feedback.html', msg="Erro interno: Não foi possível conectar ao banco.", status="error")

        cursor = conexao.cursor()
        cursor.execute(plsql_block, p_evento_id=int(evento_id))
        conexao.commit()

        query_resultados = """
            SELECT u.nome, l.motivo 
            FROM log_auditoria l
            JOIN inscricoes i ON l.inscricao_id = i.id
            JOIN usuarios u ON i.usuario_id = u.id
            WHERE i.evento_id = :p_id AND l.data >= SYSDATE - (1/1440)
        """
        cursor.execute(query_resultados, p_id=int(evento_id))
        relatorio = cursor.fetchall()

        return render_template('feedback.html', 
                               msg="Sucesso! Distribuição de cashback concluída.", 
                               status="success",
                               resultados=relatorio)
    
    except Exception as e:
        if conexao:
            conexao.rollback()
        return render_template('feedback.html', 
                               msg=f"Erro ao processar cashback: {str(e)}", 
                               status="error")
    finally:
        if cursor:
            cursor.close()
        if conexao:
            conexao.close()

if __name__ == '__main__':    
    app.run(debug=True)