unit ufrPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, ufrmPedido, uController.Principal,
  uTypes, ufrStyle;

type
  TfrPrincipal = class(TForm)
    pnFundo: TPanel;
    pnMenu: TPanel;
    pnCarrinho: TPanel;
    pnProdutos: TPanel;
    sbProdutos: TScrollBox;
    flProdutos: TFlowLayout;
    btCadastros: TCornerButton;
    btLanches: TCornerButton;
    btPorções: TCornerButton;
    btBebidas: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure btCadastrosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btLanchesClick(Sender: TObject);
    procedure btPorçõesClick(Sender: TObject);
    procedure btBebidasClick(Sender: TObject);
  private
    FFrameCarrinho: TfrmPedido;
    FControllerPrincipal: TControllerPrincipal;

    procedure CarregarLanches;
    procedure CarregarAcompanhamentos(const pTipo: TTipo);
  public
    { Public declarations }
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  System.Generics.Collections, Winapi.Windows,
  ufrMenusCadastros, ufrmProduto, uLanche, uAcompanhamento, ufrLogin;

{$R *.fmx}

procedure TfrPrincipal.btCadastrosClick(Sender: TObject);
var
  vMenuCadastros: TfrMenuCadastros;
  vLogin: TfrLogin;
  vClassificacao: TClassificacao;
begin
  vLogin:= TfrLogin.Create(Nil);
  try
    vLogin.ShowModal;
    vClassificacao:= vLogin.Classificacao;
  finally
    vLogin.Free;
  end;

  if vClassificacao = clCliente then
    Exit;

  vMenuCadastros:= TfrMenuCadastros.Create(Nil, vClassificacao);
  try
    vMenuCadastros.ShowModal;
    Self.CarregarLanches;
  finally
    vMenuCadastros.Free;
  end;
end;

procedure TfrPrincipal.btLanchesClick(Sender: TObject);
begin
  Self.CarregarLanches;
end;

procedure TfrPrincipal.btBebidasClick(Sender: TObject);
begin
  Self.CarregarAcompanhamentos(tpBebida);
end;

procedure TfrPrincipal.btPorçõesClick(Sender: TObject);
begin
  Self.CarregarAcompanhamentos(tpAcompanhamento);
end;

procedure TfrPrincipal.CarregarAcompanhamentos(const pTipo: TTipo);
var
  vFrame: TfrmProduto;
  vLista: TObjectList<TAcompanhamento>;
  vAcompanhamento: TAcompanhamento;
  vCont: Integer;
begin
  for vCont := flProdutos.ControlsCount - 1 downto 0 do
    flProdutos.Controls[vCont].Free;

  vLista:= Self.FControllerPrincipal.ConsultarAcompanhamentos(pTipo);

  if vLista.Count = 0 then
    Exit;

  for vAcompanhamento in vLista do
  begin
    vFrame := TfrmProduto.Create(Self);
    vFrame.Name := '';
    vFrame.Parent := flProdutos;
    vFrame.SetAcompanhamento(vAcompanhamento);

    vFrame.OnAdicionarAcompahamento :=
      procedure (Sender: TObject; pAcompanhamento: TAcompanhamento)
      begin
        Self.FFrameCarrinho.AdicionarAcompanhamento(pAcompanhamento);
      end;
  end;
end;

procedure TfrPrincipal.CarregarLanches;
var
  vFrame: TfrmProduto;
  vLista: TObjectList<TLanche>;
  vLanche: TLanche;
  vCont: Integer;
begin
  for vCont := flProdutos.ControlsCount - 1 downto 0 do
    flProdutos.Controls[vCont].Free;

  vLista:= Self.FControllerPrincipal.ConsultarLanches;

  if vLista.Count = 0 then
    Exit;

  for vLanche in vLista do
  begin
    vFrame := TfrmProduto.Create(Self);
    vFrame.Name := '';
    vFrame.Parent := flProdutos;
    vFrame.SetLanche(vLanche);

    vFrame.OnAdicionarLanche :=
      procedure (Sender: TObject; pLanche: TLanche)
      begin
        Self.FFrameCarrinho.AdicionarLanche(pLanche);
      end;
  end;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  Self.FControllerPrincipal:= TControllerPrincipal.Create;

  // cria o carrinho na direita
  Self.FFrameCarrinho := TfrmPedido.Create(Self);
  Self.FFrameCarrinho.Parent := pnCarrinho;
  Self.FFrameCarrinho.Align := TAlignLayout.Client;

  Self.CarregarLanches;
end;

procedure TfrPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Self.FControllerPrincipal);
end;

end.
