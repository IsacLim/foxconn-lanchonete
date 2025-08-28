unit ufrPesquisarCliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, ufrStyle,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox, uController.Clientes, uCliente;

type
  TfrPesquisarCliente = class(TForm)
    pnFundo: TPanel;
    gbPesquisar: TGroupBox;
    edPesquisa: TEdit;
    btSelecionar: TCornerButton;
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCliente: TCliente;
    FControllerCliente: TControllerCliente;
    FListBoxSugestoes: TListBox;

    procedure ListBoxSugestoesClick(Sender: TObject);
  public
    property Cliente: TCliente read FCliente;
  end;

var
  frPesquisarCliente: TfrPesquisarCliente;

implementation

uses
  system.Generics.Collections;

{$R *.fmx}

procedure TfrPesquisarCliente.edPesquisaKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
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

procedure TfrPesquisarCliente.FormCreate(Sender: TObject);
begin
  Self.FCliente:= TCliente.Create;
  Self.FControllerCliente:= TControllerCliente.Create;

  Self.FListBoxSugestoes := TListBox.Create(Self);
  Self.FListBoxSugestoes.Parent := gbPesquisar;
  Self.FListBoxSugestoes.Visible := False;
  Self.FListBoxSugestoes.OnClick := ListBoxSugestoesClick;
  Self.FListBoxSugestoes.Width := edpesquisa.Width;
  Self.FListBoxSugestoes.Height := 65;
end;

procedure TfrPesquisarCliente.FormShow(Sender: TObject);
begin
  edPesquisa.SetFocus;
end;

procedure TfrPesquisarCliente.ListBoxSugestoesClick(Sender: TObject);
begin
  if Self.FListBoxSugestoes.ItemIndex >= 0 then
  begin
    edPesquisa.Text := Self.FListBoxSugestoes.Items[Self.FListBoxSugestoes.ItemIndex];
    Self.FListBoxSugestoes.Visible := False;

    Self.FCliente:= Self.FControllerCliente.Buscar(Trim(edPesquisa.Text));
  end;
end;

end.
