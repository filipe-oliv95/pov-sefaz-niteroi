# Superset

## Conexão com Trino
Chamado: https://suporte.tecnisys.com.br/glpi/plugins/formcreator/front/issue.form.php?id=10769

Para configurar a conexão do Trino no Superset, siga os passos abaixo:

1. No Ambari, pare o serviço do Superset.

2. No terminal da VM onde o Superset está instalado, ative o ambiente virtual do Python:

    ```bash
    source /usr/tdp/current/superset/bin/activate
    ```

3. Instale o pacote necessário para a integração com o Trino, utilizando o pip do ambiente virtual:

    ```bash
    /usr/tdp/current/superset/bin/pip3.9 install trino
    ```

4. Inicie novamente o serviço do Superset.

5. Adicione a conexão com o Trino seguindo a estrutura: trino://trino@localhost:8060/iceberg/default

    Se o Trino estiver configurado com autenticação via usuário e senha, a conexão deve incluir a senha na URL:   

    ```bash
    trino://trino:senha@localhost:8060/iceberg/default
    ```


## Mapbox API Key

A criação e configuração de uma Mapbox API Key é necessária para integrar o Mapbox aos gráficos do Superset. 

1. Crie uma conta no site: [Mapbox](https://account.mapbox.com/?ref=ideas.paasup.io).
2. Gere uma API Key em `Admin → Tokens → Create a Token`.
3. Insira a Key no Ambari em `Superset → Advanced → Advanced Superset → MAPBOX_API_KEY`.

## Uso de JavaScript nos gráficos
Chamado: https://suporte.tecnisys.com.br/glpi/plugins/formcreator/front/issue.form.php?id=11002

1. Acesse o arquivo `/usr/tdp/current/superset/lib/python3.9/site-packages/superset/config.py`.
2. Edite e adicione as seguintes configurações:

    ```python
    ENABLE_JAVASCRIPT_CONTROLS = True

    TALISMAN_CONFIG = {
        ...
        "content_security_policy": {
            ...
            "script-src": [..., "'unsafe-eval'", "'unsafe-inline'"]
        },
    }
    ```

3. Após as alterações, reinicie o serviço do Superset.

## Alterar timeout das queries
Chamado: https://suporte.tecnisys.com.br/glpi/plugins/formcreator/front/issue.form.php?id=10743

1. Ajustar configurações de timeout no ambari
2. Replicar as mesmas configurações de timeout no arquivo: `/usr/tdp/2.3/superset/lib/python3.9/site-packages/superset/config.py`

Configurações mensionadas no chamado:

- **TEST_DATABASE_CONNECTION_TIMEOUT** = Tempo permitido para o Superset estabelecer conexão com o banco de dados nos testes ao adição de novas conexões.
Esta configuração não deve interferir muito no seu caso de consultas pesadas e demoradas.

- **SUPERSET_WEBSERVER_TIMEOUT** = Tempo máximo em segundos que o Superset aguardará pela resposta de uma requisição interna do próprio componente (ex: Carregamento de um gráfico) antes de exibir um retorno ao usuário.
Essa configuração afeta timeouts gerados por respostas e requisições internas que levem mais tempo para serem executadas, como a montagem de gráficos com muito dados ou consultas mais pesadas.

- **SQLLAB_TIMEOUT** = Tempo máximo para consultas síncronas realizadas na geração de gráficos e consultas no Superset.
Essa configuração é importante e afeta diretamente em timeouts gerados por consultas mais pesadas e demoradas na geração e atualização dos gráficos.

- **SQLLAB_VALIDATION_TIMEOUT** = Tempo máximo que o Superset aguardará para validar uma consulta (Sintaxe, geração de planos de execução iniciais etc.) antes de executá-la de fato.
Essa configuração não deve interferir muito no seu caso, a não ser que as consultas sejam muito extensas e demorem muito a passar por esses processos de validação.

