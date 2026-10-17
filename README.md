<p align="center"><img src="docs/banner.svg" alt="BOT IQ — Agente Visual de Trading com IA" width="100%"></p>

# BOT IQ — Agente Visual de Trading com IA

**Painel local de análise e automação de operações para IQ Option**, desenvolvido em Python e HTML, com integração opcional ao Ollama e alertas pelo Telegram.

> **Aviso:** software experimental para estudo e testes. Trading envolve risco de perda financeira. Não há garantia de lucro nem recomendação de investimento. Teste primeiro na conta **PRACTICE**.

## Funcionalidades

- Painel visual em HTML, servido localmente pelo Flask.
- Login na IQ Option, seleção de conta **PRACTICE / REAL** e monitoramento do estado da conexão.
- Scanner de ativos, indicadores e regras de análise técnica.
- Integração local com modelos de IA pelo **Ollama (Lumi Trader)**.
- Alertas e comandos opcionais via **Telegram**.
- Configurações de risco, estratégias e relatórios operacionais.

## Tecnologias

`Python 3.13` · `Flask` · `Flask-CORS` · `Requests` · `iqoptionapi` · `HTML/CSS/JS` · `Ollama`

A biblioteca `iqoptionapi` é de terceiros e não é uma API oficial da corretora. Mudanças externas podem afetar o funcionamento e o uso pode estar sujeito aos termos da plataforma.

## Instalação (Windows)

1. Instale Python 3.13 e [Ollama](https://ollama.com/) se desejar usar a IA local.
2. Clone o projeto:

   ```powershell
   git clone https://github.com/thayro/bot-iq.git
   cd bot-iq
   ```
3. Crie um ambiente virtual e instale as dependências:

   ```powershell
   py -3.13 -m venv .venv
   .\.venv\Scripts\python.exe -m pip install -r requirements.txt
   ```
4. Para instalar o modelo Lumi, revise e execute `instalar_lumi_trader_fast.ps1`, ou configure manualmente o Ollama.
5. Inicie o servidor:

   ```powershell
   .\.venv\Scripts\python.exe iqbot_server.py
   ```
6. Acesse **http://127.0.0.1:5001/** e configure as integrações.

O arquivo `INICIAR_BOT.bat` também pode ser usado no Windows para inicializar o projeto, após conferir os pré-requisitos.

## Organização

| Arquivo | Função |
|---|---|
| `iqbot_server.py` | API Flask, scanner, integração e execução |
| `iqbot_ui.html` | Interface visual de operação |
| `Modelfile.lumi-trader-fast` | Parâmetros do modelo local |
| `instalar_lumi_trader_fast.ps1` | Preparação do modelo Lumi |
| `INICIAR_BOT.bat` | Inicializador Windows |
| `requirements.txt` | Dependências Python |

## Segurança e privacidade

- **Nunca publique `config.json`**: a aplicação pode gravar e-mail, senha da corretora e token do bot Telegram.
- O `.gitignore` exclui configurações, sessões, relatórios, logs, caches e ambientes locais.
- Não exponha o portal à internet; o servidor foi pensado para `127.0.0.1`.
- Proteja as credenciais localmente; revogue qualquer segredo publicado por engano.

## Limitações

Projeto experimental. A execução depende de serviços externos e de uma biblioteca não oficial da IQ Option. Não houve teste funcional completo do pacote, e nenhum resultado financeiro é garantido.

## Licença

Uma licença ainda não foi definida. Até existir um arquivo `LICENSE`, não presuma autorização irrestrita de redistribuição ou uso comercial.
