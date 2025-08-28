unit ufrmProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, uLanche, uAcompanhamento;

type
  TOnAdicionarLanche = reference to procedure(Sender: TObject; pLanche: TLanche);
  TOnAdicionarAcompanhamento = reference to procedure(Sender: TObject; pAcompanhamento: TAcompanhamento);

  TfrmProduto = class(TFrame)
    pnFundo: TPanel;
    Image1: TImage;
    lbNome: TLabel;
    lbListaIngredientes: TLabel;
    lbPreco: TLabel;
    btAdicionar: TCornerButton;
    btModificar: TCornerButton;
    procedure btAdicionarClick(Sender: TObject);
  private
    FLanche: TLanche;
    FAcompanhamento: TAcompanhamento;
    FOnAddLanche: TOnAdicionarLanche;
    FOnAddAcompanhamento: TOnAdicionarAcompanhamento;

    procedure AtualizarLabelListaIngredientes;
  public
    property OnAdicionarLanche: TOnAdicionarLanche read FOnAddLanche write FOnAddLanche;
    property OnAdicionarAcompahamento: TOnAdicionarAcompanhamento read FOnAddAcompanhamento write FOnAddAcompanhamento;

    procedure SetLanche(const pLanche: TLanche);
    procedure SetAcompanhamento(const pAcompanhamento: TAcompanhamento);
  end;

implementation

uses
  uIngrediente;

{$R *.fmx}

procedure TfrmProduto.AtualizarLabelListaIngredientes;
var
  vIngrediente: TIngrediente;
begin
  lbListaIngredientes.Text:= '';

  for vIngrediente in Self.FLanche.ListaIngredientes do
    lbListaIngredientes.Text:= lbListaIngredientes.Text + format('%s - %d | ', [vIngrediente.Nome, vIngrediente.Quantidade]);
end;

procedure TfrmProduto.btAdicionarClick(Sender: TObject);
begin
  if Assigned(FOnAddLanche) then
    Self.FOnAddLanche(Self, Self.FLanche);

  if Assigned(FOnAddAcompanhamento) then
    Self.FOnAddAcompanhamento(Self, Self.FAcompanhamento);
end;

procedure TfrmProduto.SetAcompanhamento(const pAcompanhamento: TAcompanhamento);
begin
  Self.FAcompanhamento := pAcompanhamento;
  lbNome.Text := Self.FAcompanhamento.Nome;
  lbListaIngredientes.Text:= '';

  lbPreco.Text := 'Preço: R$ ' + FormatFloat('0.00', Self.FAcompanhamento.Preco);
end;

procedure TfrmProduto.SetLanche(const pLanche: TLanche);
begin
  Self.FLanche := pLanche;
  lbNome.Text := Self.FLanche.Nome;

  Self.AtualizarLabelListaIngredientes;
  lbPreco.Text := 'Preço: R$ ' + FormatFloat('0.00', Self.FLanche.Preco);
end;

end.
