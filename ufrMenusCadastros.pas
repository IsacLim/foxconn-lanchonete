unit ufrMenusCadastros;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uTypes, ufrStyle;

type
  TfrMenuCadastros = class(TForm)
    pnFundo: TPanel;
    btLanches: TCornerButton;
    btIngredientes: TCornerButton;
    btClientes: TCornerButton;
    btBebidas: TCornerButton;
    btAcompanhamentos: TCornerButton;
    procedure btLanchesClick(Sender: TObject);
    procedure btIngredientesClick(Sender: TObject);
    procedure btBebidasClick(Sender: TObject);
    procedure btClientesClick(Sender: TObject);
    procedure btAcompanhamentosClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; const pClassificacao: TClassificacao); reintroduce;
  end;

var
  frMenuCadastros: TfrMenuCadastros;

implementation

uses
  ufrManutencaoIngredientes, ufrManutencaoAcompanhamentos, ufrManutencaoLanches, ufrClientes;

{$R *.fmx}

procedure TfrMenuCadastros.btLanchesClick(Sender: TObject);
var
  vLanches: TfrManutLanches;
begin
  vLanches:= TfrManutLanches.Create(nil);
  try
    vLanches.ShowModal;
  finally
    vLanches.Free;
  end;
end;

procedure TfrMenuCadastros.btIngredientesClick(Sender: TObject);
var
  vIngredientes: TfrManutIngredientes;
begin
  vIngredientes:= TfrManutIngredientes.Create(nil);
  try
    vIngredientes.ShowModal;
  finally
    vIngredientes.Free;
  end;
end;

procedure TfrMenuCadastros.btAcompanhamentosClick(Sender: TObject);
var
  vIngredientes: TfrManutAcompanhamentos;
begin
  vIngredientes:= TfrManutAcompanhamentos.Create(nil, tpAcompanhamento);
  try
    vIngredientes.ShowModal;
  finally
    vIngredientes.Free;
  end;
end;

procedure TfrMenuCadastros.btBebidasClick(Sender: TObject);
var
  vIngredientes: TfrManutAcompanhamentos;
begin
  vIngredientes:= TfrManutAcompanhamentos.Create(nil, tpBebida);
  try
    vIngredientes.ShowModal;
  finally
    vIngredientes.Free;
  end;
end;

procedure TfrMenuCadastros.btClientesClick(Sender: TObject);
var
  vClientes: TfrClientes;
begin
  vClientes:= TfrClientes.Create(nil);
  try
    vClientes.ShowModal;
  finally
    vClientes.Free;
  end;
end;

constructor TfrMenuCadastros.Create(AOwner: TComponent; const pClassificacao: TClassificacao);
begin
  if not (pClassificacao in [clFuncionario, clGerente]) then
    raise Exception.Create('Usuário logado não possuí permissão para este formulário.');

  inherited Create(AOwner);

  if pClassificacao = clFuncionario then
  begin
    btIngredientes.Visible := False;
    btBebidas.Visible := False;
    btAcompanhamentos.Visible := False;
  end;
end;

end.
