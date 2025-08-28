unit ufrManutencaoAcompanhamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.ListBox, uTypes,
  uController.Acompanhamentos, ufrStyle;

type
  TfrManutAcompanhamentos = class(TForm)
    pnFundo: TPanel;
    gbInformacoes: TGroupBox;
    btIncluir: TCornerButton;
    edNome: TEdit;
    btExcluir: TCornerButton;
    btAlterar: TCornerButton;
    lbNome: TLabel;
    lbPreco: TLabel;
    edPreco: TEdit;
    gbPesquisar: TGroupBox;
    edPesquisa: TEdit;
    Image1: TImage;
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edPrecoTyping(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTipo: TTipo;
    FCodigo: Integer;
    FControllerAcompanhamento: TControllerAcompanhamento;
    FListBoxSugestoes: TListBox;

    function ExtrairValorPreco(const pTexto: string): Double;

    procedure ListBoxSugestoesClick(Sender: TObject);
    procedure LimparTela;
  public
    constructor Create(AOwner: TComponent; const pTipo: TTipo); reintroduce;
  end;

var
  frManutAcompanhamentos: TfrManutAcompanhamentos;

implementation

uses
  System.Generics.Collections, System.RegularExpressions, uAcompanhamento;

{$R *.fmx}

procedure TfrManutAcompanhamentos.btAlterarClick(Sender: TObject);
var
  vAcompanhamento: TAcompanhamento;
begin
  vAcompanhamento:= TAcompanhamento.Create;
  try
    vAcompanhamento.ID:= Self.FCodigo;
    vAcompanhamento.Nome := Trim(edNome.Text);
    vAcompanhamento.Preco := Self.ExtrairValorPreco(edPreco.Text);

    try
      Self.FControllerAcompanhamento.Alterar(vAcompanhamento);
      Showmessage('Alterado com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao Alterar: ' + e.Message);
    end;
  finally
    vAcompanhamento.Free;
  end;
end;

procedure TfrManutAcompanhamentos.btExcluirClick(Sender: TObject);
begin
  try
    Self.FControllerAcompanhamento.Excluir(Self.FCodigo);
    Showmessage('Excluído com sucesso');

    Self.LimparTela;
  except
    on e: exception do
      Showmessage('Erro ao Excluir: ' + e.Message);
  end;
end;

procedure TfrManutAcompanhamentos.btIncluirClick(Sender: TObject);
var
  vAcompanhamento: TAcompanhamento;
begin
  if Self.FControllerAcompanhamento.Buscar(Trim(edNome.Text)) <> nil then
    raise Exception.Create('Acompanhamento já incluído com esse nome.');

  vAcompanhamento:= TAcompanhamento.Create;
  try
    vAcompanhamento.Nome := Trim(edNome.Text);
    vAcompanhamento.Preco := Self.ExtrairValorPreco(edPreco.Text);
    vAcompanhamento.Tipo := Self.FTipo;

    try
      Self.FControllerAcompanhamento.Inserir(vAcompanhamento);
      Showmessage('Incluído com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao incluir: ' + e.Message);
    end;
  finally
    vAcompanhamento.Free;
  end;
end;

constructor TfrManutAcompanhamentos.Create(AOwner: TComponent; const pTipo: TTipo);
begin
  inherited Create(AOwner);
  Self.FTipo:= pTipo;

  case Self.FTipo of
    tpAcompanhamento: Self.Caption:= 'Manutenção de Acompanhamentos';
    tpBebida: Self.Caption:= 'Manutenção de Bebidas';
  else
    Self.Caption:= '';
  end;
end;

procedure TfrManutAcompanhamentos.edPesquisaKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  vLista: TObjectList<TAcompanhamento>;
  vIngrediente: TAcompanhamento;
begin
  if edPesquisa.Text = '' then
  begin
    Self.FListBoxSugestoes.Visible := False;
    Exit;
  end;

  vLista := Self.FControllerAcompanhamento.Consultar(Trim(edPesquisa.Text), Self.FTipo);
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

procedure TfrManutAcompanhamentos.edPrecoTyping(Sender: TObject);
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

function TfrManutAcompanhamentos.ExtrairValorPreco(const pTexto: string): Double;
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

procedure TfrManutAcompanhamentos.FormCreate(Sender: TObject);
begin
  Self.FCodigo:= 0;
  Self.FControllerAcompanhamento:= TControllerAcompanhamento.Create;

  Self.FListBoxSugestoes := TListBox.Create(Self);
  Self.FListBoxSugestoes.Parent := gbPesquisar;
  Self.FListBoxSugestoes.Visible := False;
  Self.FListBoxSugestoes.OnClick := ListBoxSugestoesClick;
  Self.FListBoxSugestoes.Width := edpesquisa.Width;
  Self.FListBoxSugestoes.Height := 65;
end;

procedure TfrManutAcompanhamentos.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Self.FControllerAcompanhamento);
end;

procedure TfrManutAcompanhamentos.FormShow(Sender: TObject);
begin
  edPesquisa.SetFocus;
end;

procedure TfrManutAcompanhamentos.LimparTela;
begin
  Self.FCodigo:= 0;
  edPesquisa.Text:= '';
  edNome.Text:= '';
  edPreco.Text:= '';
end;

procedure TfrManutAcompanhamentos.ListBoxSugestoesClick(Sender: TObject);
var
  vAcompanhamento: TAcompanhamento;
begin
  if Self.FListBoxSugestoes.ItemIndex >= 0 then
  begin
    edPesquisa.Text := Self.FListBoxSugestoes.Items[Self.FListBoxSugestoes.ItemIndex];
    Self.FListBoxSugestoes.Visible := False;

    vAcompanhamento:= Self.FControllerAcompanhamento.Buscar(Trim(edPesquisa.Text));
    if vAcompanhamento <> nil then
    begin
      Self.FCodigo:= vAcompanhamento.ID;
      edNome.Text:= vAcompanhamento.Nome;
      edPreco.Text:= FormatFloat('R$ #,##0.00', vAcompanhamento.Preco);
    end;
  end;
end;

end.
