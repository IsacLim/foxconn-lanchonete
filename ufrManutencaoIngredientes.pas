unit ufrManutencaoIngredientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, uController.Ingrediente, FMX.Layouts,
  FMX.ListBox, FMX.EditBox, FMX.NumberBox, uTypes, ufrStyle;

type
  TfrManutIngredientes = class(TForm)
    pnFundo: TPanel;
    gbPesquisar: TGroupBox;
    edPesquisa: TEdit;
    gbInformacoes: TGroupBox;
    btIncluir: TCornerButton;
    edNome: TEdit;
    btExcluir: TCornerButton;
    btAlterar: TCornerButton;
    lbNome: TLabel;
    lbPreco: TLabel;
    edPreco: TEdit;
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edPrecoTyping(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTipo: TTipo;
    FCodigo: Integer;
    FControllerIngrediente: TControllerIngrediente;
    FListBoxSugestoes: TListBox;

    function ExtrairValorPreco(const pTexto: string): Double;

    procedure ListBoxSugestoesClick(Sender: TObject);
    procedure LimparTela;
  end;

var
  frManutIngredientes: TfrManutIngredientes;

implementation

uses
  system.Generics.Collections, System.RegularExpressions,
  uIngrediente;

{$R *.fmx}

procedure TfrManutIngredientes.btAlterarClick(Sender: TObject);
var
  vIngrediente: TIngrediente;
begin
  vIngrediente:= TIngrediente.Create;
  try
    vIngrediente.ID:= Self.FCodigo;
    vIngrediente.Nome := Trim(edNome.Text);
    vIngrediente.Preco := Self.ExtrairValorPreco(edPreco.Text);

    try
      Self.FControllerIngrediente.Alterar(vIngrediente);
      Showmessage('Ingrediente Alterado com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao Alterar: ' + e.Message);
    end;
  finally
    vIngrediente.Free;
  end;
end;

procedure TfrManutIngredientes.btExcluirClick(Sender: TObject);
begin
  try
    Self.FControllerIngrediente.Excluir(Self.FCodigo);
    Showmessage('Ingrediente Excluído com sucesso');

    Self.LimparTela;
  except
    on e: exception do
      Showmessage('Erro ao Excluir: ' + e.Message);
  end;
end;

procedure TfrManutIngredientes.btIncluirClick(Sender: TObject);
var
  vIngrediente: TIngrediente;
begin
  if Self.FControllerIngrediente.Buscar(Trim(edNome.Text)) <> nil then
    raise Exception.Create('Ingrediente já incluído com esse nome.');

  vIngrediente:= TIngrediente.Create;
  try
    vIngrediente.Nome := Trim(edNome.Text);
    vIngrediente.Preco := Self.ExtrairValorPreco(edPreco.Text);
    vIngrediente.Tipo := Self.FTipo;

    try
      Self.FControllerIngrediente.Inserir(vIngrediente);
      Showmessage('Ingrediente Incluído com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao incluir: ' + e.Message);
    end;
  finally
    vIngrediente.Free;
  end;
end;

procedure TfrManutIngredientes.edPesquisaKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  vLista: TObjectList<TIngrediente>;
  vIngrediente: TIngrediente;
begin
  if edPesquisa.Text = '' then
  begin
    Self.FListBoxSugestoes.Visible := False;
    Exit;
  end;

  vLista := Self.FControllerIngrediente.Consultar(Trim(edPesquisa.Text));
  try
    Self.FListBoxSugestoes.Clear;
    for vIngrediente in vLista do
      Self.FListBoxSugestoes.Items.Add(vIngrediente.Nome);

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

procedure TfrManutIngredientes.edPrecoTyping(Sender: TObject);
var
  vTexto: string;
  vValor: Double;
begin
  // Remove tudo que não for número
  vTexto := edPreco.Text;
  vTexto := StringReplace(vTexto, ',', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, '.', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, 'R$', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, ' ', '', [rfReplaceAll]);

  // Garante que só tem números
  vTexto := TRegEx.Replace(vTexto, '\D', '');

  if vTexto = '' then
    vTexto := '0';

  // Converte e aplica a formatação monetária
  vValor := StrToFloat(vTexto) / 100;
  edPreco.Text := FormatFloat('R$ #,##0.00', vValor);
  edPreco.SelStart := Length(edPreco.Text);
end;

function TfrManutIngredientes.ExtrairValorPreco(const pTexto: string): Double;
var
  vTexto: string;
  vFS: TFormatSettings;
begin
  vFS := TFormatSettings.Create;
  vFS.DecimalSeparator := '.';

  vTexto := StringReplace(pTexto, 'R$', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, '.', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, ',', '.', [rfReplaceAll]);
  Result := StrToFloatDef(Trim(vTexto), 0, vFS);
end;

procedure TfrManutIngredientes.FormCreate(Sender: TObject);
begin
  Self.FCodigo:= 0;
  Self.FControllerIngrediente:= TControllerIngrediente.Create;

  Self.FListBoxSugestoes := TListBox.Create(Self);
  Self.FListBoxSugestoes.Parent := gbPesquisar;
  Self.FListBoxSugestoes.Visible := False;
  Self.FListBoxSugestoes.OnClick := ListBoxSugestoesClick;
  Self.FListBoxSugestoes.Width := edpesquisa.Width;
  Self.FListBoxSugestoes.Height := 65;
end;

procedure TfrManutIngredientes.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Self.FControllerIngrediente);
end;

procedure TfrManutIngredientes.FormShow(Sender: TObject);
begin
  edPesquisa.SetFocus;
end;

procedure TfrManutIngredientes.LimparTela;
begin
  Self.FCodigo:= 0;
  edPesquisa.Text:= '';
  edNome.Text:= '';
  edPreco.Text:= '';
end;

procedure TfrManutIngredientes.ListBoxSugestoesClick(Sender: TObject);
var
  vIngrediente: TIngrediente;
begin
  if Self.FListBoxSugestoes.ItemIndex >= 0 then
  begin
    edPesquisa.Text := Self.FListBoxSugestoes.Items[Self.FListBoxSugestoes.ItemIndex];
    Self.FListBoxSugestoes.Visible := False;

    vIngrediente:= Self.FControllerIngrediente.Buscar(Trim(edPesquisa.Text));
    if vIngrediente <> nil then
    begin
      Self.FCodigo:= vIngrediente.ID;
      edNome.Text:= vIngrediente.Nome;
      edPreco.Text:= FormatFloat('R$ #,##0.00', vIngrediente.Preco);
    end;
  end;
end;

end.
