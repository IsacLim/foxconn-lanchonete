unit ufrClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, ufrStyle,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox, uController.Clientes;

type
  TfrClientes = class(TForm)
    pnFundo: TPanel;
    gbPesquisar: TGroupBox;
    edPesquisa: TEdit;
    gbInformacoes: TGroupBox;
    btIncluir: TCornerButton;
    edNome: TEdit;
    btExcluir: TCornerButton;
    btAlterar: TCornerButton;
    lbNome: TLabel;
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCodigo: Integer;
    FControllerCliente: TControllerCliente;
    FListBoxSugestoes: TListBox;

    procedure ListBoxSugestoesClick(Sender: TObject);
    procedure LimparTela;
  end;

var
  frClientes: TfrClientes;

implementation

uses
  system.Generics.Collections, uCliente;

{$R *.fmx}

procedure TfrClientes.btAlterarClick(Sender: TObject);
var
  vIngrediente: TCliente;
begin
  vIngrediente:= TCliente.Create;
  try
    vIngrediente.ID:= Self.FCodigo;
    vIngrediente.Nome := Trim(edNome.Text);

    try
      Self.FControllerCliente.Alterar(vIngrediente);
      Showmessage('Cliente Alterado com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao Alterar: ' + e.Message);
    end;
  finally
    vIngrediente.Free;
  end;
end;

procedure TfrClientes.btExcluirClick(Sender: TObject);
begin
  try
    Self.FControllerCliente.Excluir(Self.FCodigo);
    Showmessage('Cliente Excluído com sucesso');

    Self.LimparTela;
  except
    on e: exception do
      Showmessage('Erro ao Excluir: ' + e.Message);
  end;
end;

procedure TfrClientes.btIncluirClick(Sender: TObject);
var
  vCliente: TCliente;
begin
   if Self.FControllerCliente.Buscar(Trim(edNome.Text)) <> nil then
    raise Exception.Create('Cliente já incluído com esse nome.');

  vCliente:= TCliente.Create;
  try
    vCliente.Nome := Trim(edNome.Text);

    try
      Self.FControllerCliente.Inserir(vCliente);
      Showmessage('Cliente Incluído com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao incluir: ' + e.Message);
    end;
  finally
    vCliente.Free;
  end;
end;

procedure TfrClientes.edPesquisaKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  vLista: TObjectList<TCliente>;
  vCliente: TCliente;
begin
  if edPesquisa.Text = '' then
  begin
    Self.FListBoxSugestoes.Visible := False;
    Exit;
  end;

  vLista := Self.FControllerCliente.Consultar(Trim(edPesquisa.Text));
  try
    Self.FListBoxSugestoes.Clear;
    for vCliente in vLista do
      Self.FListBoxSugestoes.Items.Add(vCliente.Nome);

    if Self.FListBoxSugestoes.Items.Count > 0 then
    begin
      // Posiciona logo abaixo do SearchBox
      Self.FListBoxSugestoes.Position.X := edPesquisa.Position.X;
      Self.FListBoxSugestoes.Position.Y := edPesquisa.Position.Y + edPesquisa.Height;
      Self.FListBoxSugestoes.BringToFront;
      Self.FListBoxSugestoes.Visible := True;
    end
    else
      Self.FListBoxSugestoes.Visible := False;
  finally
    vLista.Free;
  end;
end;

procedure TfrClientes.FormCreate(Sender: TObject);
Begin
  Self.FCodigo:= 0;
  Self.FControllerCliente:= TControllerCliente.Create;

  Self.FListBoxSugestoes := TListBox.Create(Self);
  Self.FListBoxSugestoes.Parent := gbPesquisar;
  Self.FListBoxSugestoes.Visible := False;
  Self.FListBoxSugestoes.OnClick := ListBoxSugestoesClick;
  Self.FListBoxSugestoes.Width := edpesquisa.Width;
  Self.FListBoxSugestoes.Height := 65;
end;

procedure TfrClientes.FormShow(Sender: TObject);
begin
  edPesquisa.SetFocus;
end;

procedure TfrClientes.LimparTela;
begin
  Self.FCodigo:= 0;
  edPesquisa.Text:= '';
  edNome.Text:= '';
end;

procedure TfrClientes.ListBoxSugestoesClick(Sender: TObject);
var
  vCliente: TCliente;
begin
  if Self.FListBoxSugestoes.ItemIndex >= 0 then
  begin
    edPesquisa.Text := Self.FListBoxSugestoes.Items[Self.FListBoxSugestoes.ItemIndex];
    Self.FListBoxSugestoes.Visible := False;

    vCliente:= Self.FControllerCliente.Buscar(Trim(edPesquisa.Text));
    if vCliente <> nil then
    begin
      Self.FCodigo:= vCliente.ID;
      edNome.Text:= vCliente.Nome;
    end;
  end;
end;

end.
