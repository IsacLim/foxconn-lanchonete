unit uDao.Acompanhamentos;

interface

uses
  System.Generics.Collections,
  uDados, uAcompanhamento, uTypes;

type
  TDaoAcompanhamentos = class
  public
    procedure Inserir(const pAcompanhamento: TAcompanhamento);
    procedure Alterar(const pAcompanhamento: TAcompanhamento);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TAcompanhamento;
    function Consultar(const pNome: String; const pTipo: TTipo): TObjectList<TAcompanhamento>; overload;
    function Consultar(const pTipo: TTipo): TObjectList<TAcompanhamento>; overload;
  end;

implementation

uses
  FireDAC.Comp.Client;

{ TDaoAcompanhamentos }

procedure TDaoAcompanhamentos.Alterar(const pAcompanhamento: TAcompanhamento);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('update Acompanhamento set nome = ?, preco = ? where codigo = ?', [pAcompanhamento.Nome, pAcompanhamento.Preco, pAcompanhamento.id]);
  finally
    vQy.Free;
  end;
end;

procedure TDaoAcompanhamentos.Inserir(const pAcompanhamento: TAcompanhamento);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('insert into Acompanhamento (nome, preco, tipo) values (?, ?, ?)', [pAcompanhamento.Nome, pAcompanhamento.Preco, pAcompanhamento.Tipo]);
  finally
    vQy.Free;
  end;
end;

function TDaoAcompanhamentos.Buscar(const pNome: String): TAcompanhamento;
var
  vQy: TFDQuery;
begin
  Result:= nil;

  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.SQL.Text:= 'SELECT codigo, nome, preco FROM Acompanhamento WHERE nome = :nome';
    vQy.ParamByName('nome').AsString := pNome;

    vQy.Open;
    if not(vQy.Eof) then
    begin
      Result := TAcompanhamento.Create;
      Result.Id := vQy.FieldByName('codigo').AsInteger;
      Result.Nome := vQy.FieldByName('nome').AsString;
      Result.Preco := vQy.FieldByName('preco').AsFloat;
    end;
  finally
    vQy.Free;
  end;
end;

function TDaoAcompanhamentos.Consultar(const pTipo: TTipo): TObjectList<TAcompanhamento>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TAcompanhamento>;
  vAcompanhamento: TAcompanhamento;
begin
  vLista := TObjectList<TAcompanhamento>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.SQL.Text := 'select codigo, nome, preco FROM Acompanhamento WHERE tipo = :tipo';
    vQy.ParamByName('tipo').AsInteger := Integer(pTipo);
    vQy.Open;

    while not(vQy.Eof) do
    begin
      vAcompanhamento := TAcompanhamento.Create;
      vAcompanhamento.Id := vQy.FieldByName('codigo').AsInteger;
      vAcompanhamento.Nome := vQy.FieldByName('nome').AsString;
      vAcompanhamento.Preco := vQy.FieldByName('preco').AsCurrency;
      vLista.Add(vAcompanhamento);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

function TDaoAcompanhamentos.Consultar(const pNome: String; const pTipo: TTipo): TObjectList<TAcompanhamento>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TAcompanhamento>;
  vAcompanhamento: TAcompanhamento;
begin
  vLista := TObjectList<TAcompanhamento>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.SQL.Text := 'SELECT codigo, nome, preco FROM Acompanhamento WHERE tipo = :tipo and nome LIKE :nome';
    vQy.ParamByName('tipo').AsInteger := Integer(pTipo);
    vQy.ParamByName('nome').AsString := '%' + pNome + '%';
    vQy.Open;

    while not(vQy.Eof) do
    begin
      vAcompanhamento := TAcompanhamento.Create;
      vAcompanhamento.Id := vQy.FieldByName('codigo').AsInteger;
      vAcompanhamento.Nome := vQy.FieldByName('nome').AsString;
      vAcompanhamento.Preco := vQy.FieldByName('preco').AsCurrency;
      vLista.Add(vAcompanhamento);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

procedure TDaoAcompanhamentos.Excluir(const pID: Integer);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('delete from Acompanhamento where codigo = ?', [pID]);
  finally
    vQy.Free;
  end;
end;

end.
