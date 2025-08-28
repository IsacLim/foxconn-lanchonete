unit ufrmPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, uLanche, uAcompanhamento, uPedido;

type
  TfrmPedido = class(TFrame)
    pnFundo: TPanel;
    lbCarrinho: TLabel;
    btFinalizar: TCornerButton;
    lbTotal: TLabel;
    lbListaItens: TListBox;
    lbTotalUsd: TLabel;
    procedure btFinalizarClick(Sender: TObject);
  private
    FPedido: TPedido;
    FTotal: Currency;
    FJaAddRefriGratis: Boolean;

    procedure AtualizarTotal;
    procedure RemoverItem(Sender: TObject);
    procedure AdicionarItem(const pNome: string; const pPreco: Double);
    procedure RemoverItemPedido(const pNome: string);
    procedure TemDireitoRefrigeranteGratis;
  public
    procedure AdicionarLanche(const pLanche: TLanche);
    procedure AdicionarAcompanhamento(const pAcompanhamento: TAcompanhamento);
    procedure Limpar;
  end;

implementation

uses
  uController.Pedido, ufrPesquisarCliente, uMoeda, uTypes;

{$R *.fmx}

{ TfrmPedido }

procedure TfrmPedido.AdicionarAcompanhamento(const pAcompanhamento: TAcompanhamento);
begin
  Self.AdicionarItem(pAcompanhamento.Nome, pAcompanhamento.Preco);
  Self.FPedido.AdicionarAcompanhamento(pAcompanhamento);
  Self.AtualizarTotal;

  Self.TemDireitoRefrigeranteGratis;
end;

procedure TfrmPedido.AdicionarLanche(const pLanche: TLanche);
begin
  Self.AdicionarItem(pLanche.Nome, pLanche.Preco);
  Self.FPedido.AdicionarLanche(pLanche);
  Self.AtualizarTotal;

  Self.TemDireitoRefrigeranteGratis;
end;

procedure TfrmPedido.TemDireitoRefrigeranteGratis;
var
  vAcompanhamento: TAcompanhamento;
begin
  if not(Self.FPedido.TemDireitoRefrigeranteGratis) or Self.FJaAddRefriGratis then
    Exit;

  vAcompanhamento:= TAcompanhamento.Create;

  vAcompanhamento.ID:= -1;
  vAcompanhamento.Nome:= 'Coca-Cola 1L - Grátis';
  vAcompanhamento.Quantidade:= 1;
  vAcompanhamento.Preco:= 0;
  vAcompanhamento.Tipo:= tpBebida;

  Self.FJaAddRefriGratis:= True;
  AdicionarAcompanhamento(vAcompanhamento);
end;

procedure TfrmPedido.AdicionarItem(const pNome: string; const pPreco: Double);
var
  vItem: TListBoxItem;
  vLayout: TLayout;
  vLbl: TLabel;
  vBtn: TButton;
begin
  if Self.FPedido = nil then
    Self.FPedido:= TPedido.Create;

  vItem := TListBoxItem.Create(lbListaItens);
  vItem.Parent := lbListaItens;
  vItem.Height := 20;

  vLayout := TLayout.Create(vItem);
  vLayout.Parent := vItem;
  vLayout.Align := TAlignLayout.Client;

  // label com nome e preço
  vLbl := TLabel.Create(vLayout);
  vLbl.Parent := vLayout;
  vLbl.Align := TAlignLayout.Left;
  vLbl.Width := 200;
  vLbl.Text := pNome + ' - R$ ' + FormatFloat('0.00', pPreco);

  // botão de remover
  vBtn := TButton.Create(vLayout);
  vBtn.Parent := vLayout;
  vBtn.Align := TAlignLayout.Right;
  vBtn.TagString := pNome;
  vBtn.Text := 'X';
  vBtn.Width := 20;
  vBtn.OnClick := RemoverItem;
end;

procedure TfrmPedido.AtualizarTotal;
begin
  lbTotal.Text := 'Total: R$ ' + FormatFloat('0.00', Self.FPedido.Preco);
  lbTotalUsd.Text := 'Total: $ ' + FormatFloat('0.00', TMoeda.ConverterBrlToUsd(Self.FPedido.Preco));
end;

procedure TfrmPedido.btFinalizarClick(Sender: TObject);
var
  vControllerPedido: TControllerPedido;
  vCliente: TfrPesquisarCliente;
begin
  vControllerPedido:= TControllerPedido.Create;
  vCliente:= TfrPesquisarCliente.Create(nil);
  try
    vCliente.ShowModal;
    Self.FPedido.Cliente:= vCliente.Cliente;

    vControllerPedido.Salvar(Self.FPedido);
    Self.AtualizarTotal;

    ShowMessage('Pedido gerado com sucesso.');

    Self.Limpar;
  finally
    FreeAndNil(vCliente);
    FreeAndNil(vControllerPedido);
  end;
end;

procedure TfrmPedido.Limpar;
begin
  lbListaItens.Clear;
  Self.FTotal := 0;
  lbTotal.Text := 'Total: R$ 0,00';
  lbTotalUsd.Text := 'Total: $ 0,00';
end;

procedure TfrmPedido.RemoverItem(Sender: TObject);
var
  vBtn: TButton;
begin
  if Sender is TButton then
  begin
    vBtn := TButton(Sender);

    // desconta o valor do item
    Self.RemoverItemPedido(vBtn.TagString);

    // remove o ListBoxItem inteiro
    vBtn.Parent.Parent.Free;

    Self.AtualizarTotal;
  end;
end;

procedure TfrmPedido.RemoverItemPedido(const pNome: string);
var
  vCont: Integer;
begin
  for vCont := Self.FPedido.ListaLanche.Count - 1 downto 0 do
  begin
    if Self.FPedido.ListaLanche[vCont].Nome = pNome then
    begin
      Self.FPedido.ListaLanche.Delete(vCont);
      Break;
      Exit;
    end;
  end;

  for vCont := Self.FPedido.ListaAcompanhamento.Count - 1 downto 0 do
  begin
    if Self.FPedido.ListaAcompanhamento[vCont].Nome = pNome then
    begin
      Self.FPedido.ListaAcompanhamento.Delete(vCont);
    end;
  end;
end;

end.
