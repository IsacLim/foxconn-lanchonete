program Lanchonete;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrPrincipal in 'ufrPrincipal.pas' {frPrincipal},
  ufrmProduto in 'ufrmProduto.pas' {frmProduto: TFrame},
  uIngrediente in 'uIngrediente.pas',
  uLanche in 'uLanche.pas',
  ufrMenusCadastros in 'ufrMenusCadastros.pas' {frMenuCadastros},
  uTypes in 'uTypes.pas',
  ufrManutencaoIngredientes in 'ufrManutencaoIngredientes.pas' {frManutIngredientes},
  uDao.Ingrediente in 'uDao.Ingrediente.pas',
  uDados in 'uDados.pas' {Dados: TDataModule},
  uController.Ingrediente in 'uController.Ingrediente.pas',
  ufrManutencaoLanches in 'ufrManutencaoLanches.pas' {frManutLanches},
  uController.Lanche in 'uController.Lanche.pas',
  uDao.Lanche in 'uDao.Lanche.pas',
  ufrmPedido in 'ufrmPedido.pas' {frmPedido: TFrame},
  uController.Principal in 'uController.Principal.pas',
  uController.Pedido in 'uController.Pedido.pas',
  uDao.Pedido in 'uDao.Pedido.pas',
  uPedido in 'uPedido.pas',
  ufrLogin in 'ufrLogin.pas' {frLogin},
  ufrClientes in 'ufrClientes.pas' {frClientes},
  uController.Clientes in 'uController.Clientes.pas',
  uCliente in 'uCliente.pas',
  uDao.Cliente in 'uDao.Cliente.pas',
  ufrManutencaoAcompanhamentos in 'ufrManutencaoAcompanhamentos.pas' {frManutAcompanhamentos},
  uController.Acompanhamentos in 'uController.Acompanhamentos.pas',
  uAcompanhamento in 'uAcompanhamento.pas',
  uDao.Acompanhamentos in 'uDao.Acompanhamentos.pas',
  uMoeda in 'uMoeda.pas',
  ufrPesquisarCliente in 'ufrPesquisarCliente.pas' {frPesquisarCliente},
  ufrStyle in 'ufrStyle.pas' {frStyle};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDados, Dados);
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.CreateForm(TfrStyle, frStyle);
  Application.Run;
end.
