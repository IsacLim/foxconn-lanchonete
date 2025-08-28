unit ufrManutencaoLanches;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.ListBox, system.Generics.Collections,
  uIngrediente, uController.Lanche, uController.Ingrediente, FMX.Objects, ufrStyle;

type
  TfrManutLanches = class(TForm)
    pnFundo: TPanel;
    gbPesquisar: TGroupBox;
    edPesquisa: TEdit;
    gbInformacoes: TGroupBox;
    btIncluir: TCornerButton;
    edNome: TEdit;
    btExcluir: TCornerButton;
    btAlterar: TCornerButton;
    lbNome: TLabel;
    gbIngredientes: TGroupBox;
    gdIngredientes: TStringGrid;
    edPreco: TEdit;
    lbPreco: TLabel;
    edPesquisaIngr: TEdit;
    StringColumn1: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    IntegerColumn1: TIntegerColumn;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gdIngredientesDrawColumnCell(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
      const Row: Integer; const Value: TValue; const State: TGridDrawStates);
    procedure gdIngredientesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edPesquisaIngrKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCodigo: Integer;
    FControllerLanche: TControllerLanche;
    FControllerIngrediente: TControllerIngrediente;
    FListBoxSugestoes, FListBoxSugestoesIngr: TListBox;

    procedure ListBoxSugestoesClick(Sender: TObject);
    procedure ListBoxSugestoesIngrClick(Sender: TObject);
    procedure LimparTela;
    procedure AtualizarPreco;

    procedure PreencherListaIngredientes(out pListaIngredientes: TObjectList<TIngrediente>);
  public
    { Public declarations }
  end;

var
  frManutLanches: TfrManutLanches;

implementation

uses
  System.Math, System.RegularExpressions,
  uLanche;

{$R *.fmx}

const
  COR_TEXTO_CELULA    = TAlphaColorRec.Black;
  COR_BOTAO           = TAlphaColorRec.Silver;

procedure TfrManutLanches.btAlterarClick(Sender: TObject);
var
  vLanche: TLanche;
  vListaIngrediente: TobjectList<TIngrediente>;
begin
  vLanche:= TLanche.Create;
  vListaIngrediente := TObjectList<TIngrediente>.Create;

  try
    vLanche.ID:= Self.FCodigo;
    vLanche.Nome := Trim(edNome.Text);

    Self.PreencherListaIngredientes(vListaIngrediente);
    vLanche.ListaIngredientes:= vListaIngrediente;

    try
      Self.FControllerLanche.Alterar(vLanche);
      Showmessage('Lanche Alterado com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao Alterar: ' + e.Message);
    end;
  finally
    vLanche.Free;
  end;
end;

procedure TfrManutLanches.btExcluirClick(Sender: TObject);
begin
   try
    Self.FControllerLanche.Excluir(Self.FCodigo);
    Showmessage('Lanche Excluído com sucesso');

    Self.LimparTela;
  except
    on e: exception do
      Showmessage('Erro ao Excluir: ' + e.Message);
  end;
end;

procedure TfrManutLanches.btIncluirClick(Sender: TObject);
var
  vLanche: TLanche;
  vListaIngrediente: TObjectList<TIngrediente>;
begin
  if Self.FControllerLanche.Buscar(Trim(edNome.Text)).ID > 0 then
    raise Exception.Create('Lanche já incluído com esse nome.');

  vLanche:= TLanche.Create;
  try
    vListaIngrediente := TObjectList<TIngrediente>.Create;

    vLanche.Nome := Trim(edNome.Text);

    Self.PreencherListaIngredientes(vListaIngrediente);
    vLanche.ListaIngredientes:= vListaIngrediente;

    try
      Self.FControllerLanche.Inserir(vLanche);
      Showmessage('Lanche Incluído com sucesso');

      Self.LimparTela;
    except
      on e: exception do
        Showmessage('Erro ao incluir: ' + e.Message);
    end;
  finally
    vLanche.Free;
  end;
end;

procedure TfrManutLanches.edPesquisaIngrKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  vLista: TObjectList<TIngrediente>;
  vIngrediente: TIngrediente;
begin
  if edPesquisaIngr.Text = '' then
  begin
    Self.FListBoxSugestoesIngr.Visible := False;
    Exit;
  end;

  vLista := Self.FControllerIngrediente.Consultar(Trim(edPesquisaIngr.Text));

  if vLista.count = 0 then
    Exit;

  try
    Self.FListBoxSugestoesIngr.Clear;
    for vIngrediente in vLista do
      Self.FListBoxSugestoesIngr.Items.Add(vIngrediente.Nome);

    if Self.FListBoxSugestoesIngr.Items.Count > 0 then
    begin
      // Posiciona logo abaixo do SearchBox
      Self.FListBoxSugestoesIngr.position.X := edPesquisaIngr.position.X;
      Self.FListBoxSugestoesIngr.position.Y := edPesquisaIngr.position.Y + edPesquisaIngr.Height;
      Self.FListBoxSugestoesIngr.BringToFront;
      Self.FListBoxSugestoesIngr.Visible := True;
    end
    else
      Self.FListBoxSugestoesIngr.Visible := False;
  finally
    vLista.Free;
  end;
end;

procedure TfrManutLanches.edPesquisaKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  vLista: TObjectList<TLanche>;
  vLanche: TLanche;
begin
  if edPesquisa.Text = '' then
  begin
    Self.FListBoxSugestoes.Visible := False;
    Exit;
  end;

  vLista := Self.FControllerLanche.Consultar(Trim(edPesquisa.Text));

  if vLista.Count = 0 then
    Exit;

  try
    Self.FListBoxSugestoes.Clear;
    for vLanche in vLista do
      Self.FListBoxSugestoes.Items.Add(vLanche.Nome);

    if Self.FListBoxSugestoes.Items.Count > 0 then
    begin
      // Posiciona logo abaixo do SearchBox
      Self.FListBoxSugestoes.position.X := edPesquisa.Position.X;
      Self.FListBoxSugestoes.position.Y := edPesquisa.Position.Y + edPesquisa.Height;
      Self.FListBoxSugestoes.BringToFront;
      Self.FListBoxSugestoes.Visible := True;
    end
    else
      Self.FListBoxSugestoes.Visible := False;
  finally
    vLista.Free;
  end;
end;

procedure TfrManutLanches.FormCreate(Sender: TObject);
begin
  Self.FCodigo:= 0;
  Self.FControllerLanche:= TControllerLanche.Create;
  Self.FControllerIngrediente:= TControllerIngrediente.Create;

  Self.FListBoxSugestoes := TListBox.Create(Self);
  Self.FListBoxSugestoes.Parent := gbPesquisar;
  Self.FListBoxSugestoes.Visible := False;
  Self.FListBoxSugestoes.OnClick := ListBoxSugestoesClick;
  Self.FListBoxSugestoes.Width := edpesquisa.Width;
  Self.FListBoxSugestoes.Height := 65;

  Self.FListBoxSugestoesIngr := TListBox.Create(Self);
  Self.FListBoxSugestoesIngr.Parent := gbIngredientes;
  Self.FListBoxSugestoesIngr.Visible := False;
  Self.FListBoxSugestoesIngr.OnClick := ListBoxSugestoesIngrClick;
  Self.FListBoxSugestoesIngr.Width := edPesquisaIngr.Width;
  Self.FListBoxSugestoesIngr.Height := 65;

  gdIngredientes.OnMouseDown:= gdIngredientesMouseDown;
  gdIngredientes.Columns[1].EditingCancelled;
end;

procedure TfrManutLanches.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Self.FControllerLanche);
  FreeAndNil(Self.FControllerIngrediente);
end;

procedure TfrManutLanches.FormShow(Sender: TObject);
begin
  edPesquisa.SetFocus;
end;

procedure TfrManutLanches.gdIngredientesDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  IsHeader: Boolean;
  IsEven: Boolean;
  R: TRectF;
  Text: string;
begin
  if Value.IsEmpty then
    Text := ''
  else
    Text := Value.ToString;

  if Column.Index = 1 then
  begin
    // Botão "-"
    R := Bounds;
    R.Right := R.Left + 20;
    Canvas.Fill.Color := COR_BOTAO;
    Canvas.FillRect(R, 0, 0, [], 1);
    Canvas.Fill.Color := COR_TEXTO_CELULA;
    Canvas.FillText(R, '-', False, 1, [], TTextAlign.Center, TTextAlign.Center);

    // Quantidade
    R.Left := R.Right + 4;
    R.Right := Bounds.Right - 24;
    Canvas.FillText(R, Text, False, 1, [], TTextAlign.Center, TTextAlign.Center);

    // Botão "+"
    R.Left := Bounds.Right - 20;
    R.Right := Bounds.Right;
    Canvas.Fill.Color := COR_BOTAO;
    Canvas.FillRect(R, 0, 0, [], 1);
    Canvas.Fill.Color := COR_TEXTO_CELULA;
    Canvas.FillText(R, '+', False, 1, [], TTextAlign.Center, TTextAlign.Center);
  end
  else
  begin
    // Nome do ingrediente (coluna 0)
    Canvas.FillText(Bounds, Text, False, 1, [], TTextAlign.Leading, TTextAlign.Center);
  end;
end;

procedure TfrManutLanches.gdIngredientesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Col, Row: Integer;
  CellRect: TRectF;
  Grid: TStringGrid;
  Qtd: Integer;
begin
  Grid := Sender as TStringGrid;

  if Grid.CellByPoint(X, Y, Col, Row) then
  begin
    if Col = 1 then
    begin
      CellRect := Grid.CellRect(Col, Row);

      // "-" botão
      if X < (CellRect.Left + 20) then
      begin
        Qtd := StrToIntDef(Grid.Cells[1, Row], 0);
        if Qtd > 0 then
          Grid.Cells[1, Row] := (Qtd - 1).ToString;
      end;

      // "+" botão
      if X > (CellRect.Right - 20) then
      begin
        Qtd := StrToIntDef(Grid.Cells[1, Row], 0);
        Grid.Cells[1, Row] := (Qtd + 1).ToString;
      end;

      Self.AtualizarPreco;
    end;
  end;
end;

procedure TfrManutLanches.LimparTela;
begin
  Self.FCodigo:= 0;
  edNome.Text:= '';
  edPreco.Text:= '';
  gdIngredientes.RowCount:= 0;
  edPesquisa.Text:= '';
  edPesquisaIngr.Text:= '';
end;

procedure TfrManutLanches.ListBoxSugestoesClick(Sender: TObject);
var
  vLanche: TLanche;
  vIngrediente: TIngrediente;
  vLinha: integer;
begin
  if Self.FListBoxSugestoes.ItemIndex >= 0 then
  begin
    edPesquisa.Text := Self.FListBoxSugestoes.Items[Self.FListBoxSugestoes.ItemIndex];
    Self.FListBoxSugestoes.Visible := False;

    vLanche:= Self.FControllerLanche.Buscar(Trim(edPesquisa.Text));
    if vLanche <> nil then
    begin
      Self.LimparTela;
      Self.FCodigo:= vLanche.ID;
      edNome.Text:= vLanche.Nome;
      edPreco.Text:= FormatFloat('R$ #,##0.00', vLanche.Preco);

      for vIngrediente in vLanche.ListaIngredientes do
      begin
        gdIngredientes.RowCount:= gdIngredientes.RowCount +1;
        vLinha:= gdIngredientes.RowCount -1;
        gdIngredientes.Cells[0, vLinha] := vIngrediente.Nome;
        gdIngredientes.Cells[1, vLinha] := IntToStr(vIngrediente.Quantidade);
        gdIngredientes.Cells[2, vLinha] := FloatToStr(vIngrediente.Preco);
        gdIngredientes.Cells[3, vLinha] := IntToStr(vIngrediente.Id);
      end;
    end;
  end;
end;

procedure TfrManutLanches.ListBoxSugestoesIngrClick(Sender: TObject);
var
  vIngrediente: TIngrediente;
  vLinha: integer;
  vPreco: double;
begin
  if Self.FListBoxSugestoesIngr.ItemIndex >= 0 then
  begin
    edPesquisaIngr.Text := Self.FListBoxSugestoesIngr.Items[Self.FListBoxSugestoesIngr.ItemIndex];
    Self.FListBoxSugestoesIngr.Visible := False;

    vIngrediente:= Self.FControllerIngrediente.Buscar(Trim(edPesquisaIngr.Text));
    if vIngrediente <> nil then
    begin
      gdIngredientes.RowCount:= gdIngredientes.RowCount +1;
      vLinha:= gdIngredientes.RowCount -1;
      gdIngredientes.Cells[0, vLinha] := vIngrediente.Nome;
      gdIngredientes.Cells[1, vLinha] := '1';
      gdIngredientes.Cells[2, vLinha] := FloatToStr(vIngrediente.Preco);
      gdIngredientes.Cells[3, vLinha] := IntToStr(vIngrediente.Id);

      Self.AtualizarPreco;
    end;
  end;
end;

procedure TfrManutLanches.PreencherListaIngredientes(out pListaIngredientes: TObjectList<TIngrediente>);
var
  vLinha, vTotalLinhas: integer;
  vIngrediente: TIngrediente;
begin
  vTotalLinhas:= gdIngredientes.RowCount;
  for vLinha := 0 to vTotalLinhas -1 do
  begin
    vIngrediente:= TIngrediente.Create;
    vIngrediente.Nome:= gdIngredientes.Cells[0, vLinha];
    vIngrediente.Quantidade:= StrToIntDef((gdIngredientes.Cells[1, vLinha]), 1);
    vIngrediente.Preco:= StrToFloatDef((gdIngredientes.Cells[2, vLinha]), 0);
    vIngrediente.ID:= StrToIntDef((gdIngredientes.Cells[3, vLinha]), 0);

    pListaIngredientes.Add(vIngrediente);
  end;
end;

procedure TfrManutLanches.AtualizarPreco;
var
  vIngrediente: TIngrediente;
  vListaIngrediente: TobjectList<TIngrediente>;
  vPreco: Double;
begin
  vPreco:= 0;

  vListaIngrediente := TObjectList<TIngrediente>.Create;
  try
    Self.PreencherListaIngredientes(vListaIngrediente);

    for vIngrediente in vListaIngrediente do
      vPreco:= vPreco + (vIngrediente.Quantidade * vIngrediente.Preco);

    edPreco.Text:= FormatFloat('R$ #,##0.00', vPreco);
  finally
    vListaIngrediente.Free;
  end;
end;

end.
