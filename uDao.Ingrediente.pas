unit uDao.Ingrediente;

interface

uses
  System.Generics.Collections,
  uDados, uIngrediente, uTypes;

type
  TDaoIngredientes = class
  public
    procedure Inserir(const pIngrediente: TIngrediente);
    procedure Alterar(const pIngrediente: TIngrediente);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TIngrediente;
    function Consultar(const pNome: String): TObjectList<TIngrediente>;
  end;

implementation

uses
  FireDAC.Comp.Client;

{ TDaoIngredientes }

procedure TDaoIngredientes.Alterar(const pIngrediente: TIngrediente);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('update ingredientes set nome = ?, preco = ? where codigo = ?', [pIngrediente.Nome, pIngrediente.Preco, pIngrediente.id]);
  finally
    vQy.Free;
  end;
end;

procedure TDaoIngredientes.Inserir(const pIngrediente: TIngrediente);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('insert into ingredientes (nome, preco) values (?, ?)', [pIngrediente.Nome, pIngrediente.Preco]);
  finally
    vQy.Free;
  end;
end;

function TDaoIngredientes.Buscar(const pNome: String): TIngrediente;
var
  vQy: TFDQuery;
begin
  Result:= nil;

  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.SQL.Text:= 'SELECT codigo, nome, preco FROM ingredientes WHERE nome = :nome';
    vQy.ParamByName('nome').AsString := pNome;

    vQy.Open;
    if not(vQy.Eof) then
    begin
      Result := TIngrediente.Create;
      Result.Id := vQy.FieldByName('codigo').AsInteger;
      Result.Nome := vQy.FieldByName('nome').AsString;
      Result.Preco := vQy.FieldByName('preco').AsFloat;
    end;
  finally
    vQy.Free;
  end;
end;

function TDaoIngredientes.Consultar(const pNome: String): TObjectList<TIngrediente>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TIngrediente>;
  vIngrediente: TIngrediente;
begin
  vLista := TObjectList<TIngrediente>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.SQL.Text := 'SELECT codigo, nome, preco FROM ingredientes WHERE nome LIKE :nome';
    vQy.ParamByName('nome').AsString := '%' + pNome + '%';
    vQy.Open;

    while not(vQy.Eof) do
    begin
      vIngrediente := TIngrediente.Create;
      vIngrediente.Id := vQy.FieldByName('codigo').AsInteger;
      vIngrediente.Nome := vQy.FieldByName('nome').AsString;
      vIngrediente.Preco := vQy.FieldByName('preco').AsCurrency;
      vLista.Add(vIngrediente);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

procedure TDaoIngredientes.Excluir(const pID: Integer);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('delete from ingredientes where codigo = ?', [pID]);
  finally
    vQy.Free;
  end;
end;

end.
