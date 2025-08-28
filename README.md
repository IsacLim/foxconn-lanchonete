# 📋 Projeto Lanchonete

## 👤 Usuários Cadastrados

| Nome  | Senha | Nível de Acesso |
|-------|-------|-----------------|
| Isac  | 123   | Gerente         |
| Lucas | 123   | Funcionário     |

## 👥 Clientes

- **Monike**: Cliente cadastrada há mais de 6 meses (recebe desconto especial)

---

## ▶️ Como Executar o Projeto

1. Acesse a pasta `Win32/Release`.
2. Clique duas vezes no arquivo **`Lanchonete.exe`**.
3. Será exibida a tela do **Menu Principal**.
   - Na lateral esquerda, você encontrará as opções:
     - **Lanches**
     - **Porções**
     - **Bebidas**
     - **Cadastros**
4. Login e permissões:
   - Ao acessar a área de **Cadastro**, será solicitado **usuário e senha**.
   - **Funcionário** pode cadastrar **lanches** e **clientes**.
   - **Gerente** tem acesso total a todos os cadastros.

---

## 🧪 Testes Automatizados

- O projeto inclui a aplicação `TesteLanchonete.exe`.
- Basta executá-la para abrir o módulo de testes.
- Serão rodados **6 testes automáticos**:
  - **3 testes positivos** (esperados para passar)
  - **3 testes negativos** (esperados para falhar)
- Objetivo: testar **criação de classes base** e **validação de retorno de valores**.

---

## ⚙️ Escolhas Técnicas

- **Arquitetura:** Padrão **MVC** (Model-View-Controller)
  - Motivação: Melhor organização, escalabilidade e testabilidade do código.
- **Design:** Inspirado em interfaces do sistema **GerencieAqui**.
- **Estilo visual:** Tema escuro (_Dark Style_), aplicado com `TStyleBook`.

---

## 🧩 Desafios Enfrentados

- ❌ **Mistura de VCL com FMX**
  - O projeto começou em VCL, mas migrei para FMX por precisar de recursos exclusivos dele.
  - A tentativa de integração entre VCL e FMX resultou em conflitos e incompatibilidades.
- ❌ **Relatórios**
  - A versão **Community** do Delphi 12 não possui suporte ao **FastReport** gratuito.
  - **Fortes Report** só tem suporte para **VCL**, e não para **FMX**.
  - Tentei utilizar uma **DLL VCL** com relatórios, mas o comportamento visual ficou inadequado (formulário fantasma ao fechar).
- 📷 **Imagens dos produtos**
  - Existe suporte a imagens em lanches, porções e bebidas.
  - Contudo, como não era um requisito obrigatório e já tinha gasto muito tempo com a parte visual, deixei como **possível melhoria futura**.
- ✏️ **Edição de Lanches**
  - Faltou implementar a funcionalidade de **editar um lanche e seus ingredientes**.
  - Para isso, seria necessário:
    - Criar uma nova tela de edição
    - Criar uma tabela auxiliar no banco de dados
    - Permitir alterar sem perder os ingredientes do lanche original
