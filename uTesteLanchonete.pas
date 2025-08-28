unit uTesteLanchonete;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTesteLanchonete = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('TestClienteCerto', '01/01/2025')]
    [TestCase('TestClienteErro', '01/08/2025')]
    procedure CriarCliente(const pValue: String);

    [Test]
    [TestCase('CriarIngredienteCerto', '2,6,12')]
    [TestCase('CriarIngredienteErro', '3,4,15')]
    procedure CriarIngrediente(const pQtd: Integer; const pPreco, pPrecoFinal: Double);

    [Test]
    [TestCase('CriarLancheCerto', '2,6,14')]
    [TestCase('CriarLancheErro', '3,4,15')]
    procedure CriarLanche(const pPreco1, pPreco2, pPrecoFinal: Double);
  end;

implementation

uses
  System.SysUtils, system.Generics.Collections,
  uCliente, uLanche, uIngrediente;

procedure TTesteLanchonete.CriarCliente(const pValue: String);
var
  vCliente: TCliente;
begin
  vCliente:= TCliente.Create;
  try
    vCliente.ID:= 1;
    vCliente.Nome:= 'Teste';
    vCliente.DataCadastro:= StrToDate(pValue);

    Assert.IsTrue(vCliente.MesesCadastro > 6, 'Não é elegível ao Desconto de 5%');
  finally
    FreeAndNil(vCliente)
  end;
end;

procedure TTesteLanchonete.CriarIngrediente(const pQtd: Integer; const pPreco, pPrecoFinal: Double);
var
  vIngredientes: TIngrediente;
  vPrecoFinal: Double;
begin
  try
    vIngredientes:= TIngrediente.Create;
    vIngredientes.ID:= 1;
    vIngredientes.Nome:= 'Teste';
    vIngredientes.Quantidade:= pQtd;
    vIngredientes.Preco:= pPreco;

    vPrecoFinal:= vIngredientes.Preco * vIngredientes.Quantidade;
  finally
    Assert.IsTrue(vPrecoFinal = pPrecoFinal, Format('Falha: %.2f <> %.2f', [pPrecoFinal, vPrecoFinal]));
  end;
end;

procedure TTesteLanchonete.CriarLanche(const pPreco1, pPreco2, pPrecoFinal: Double);
var
  vLanche: TLanche;
  vListaIngredientes: TObjectList<TIngrediente>;
  vIngredientes: TIngrediente;
begin
  vLanche:= TLanche.Create;
  vListaIngredientes:= TObjectList<TIngrediente>.Create;
  try
    vLanche.ID:= 1;
    vLanche.Nome:= 'Teste Lanche';

    vIngredientes:= TIngrediente.Create;
    vIngredientes.ID:= 1;
    vIngredientes.Nome:= 'Salada';
    vIngredientes.Quantidade:= 1;
    vIngredientes.Preco:= pPreco1;
    vListaIngredientes.Add(vIngredientes);

    vIngredientes:= TIngrediente.Create;
    vIngredientes.ID:= 2;
    vIngredientes.Nome:= 'Tomate';
    vIngredientes.Quantidade:= 2;
    vIngredientes.Preco:= pPreco2;
    vListaIngredientes.Add(vIngredientes);

    vLanche.ListaIngredientes:= vListaIngredientes;

    Assert.IsTrue(vLanche.Preco = pPrecoFinal, Format('Falha: %.2f <> %.2f', [pPrecoFinal, vLanche.Preco]));
  finally
    FreeAndNil(vLanche);
    FreeAndNil(vListaIngredientes);
  end;
end;

procedure TTesteLanchonete.Setup;
begin
  //
end;

procedure TTesteLanchonete.TearDown;
begin
  //
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteLanchonete);

end.
