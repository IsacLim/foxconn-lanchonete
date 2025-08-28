unit uDao.Cliente;

interface

uses
  System.Generics.Collections,
  uDados, uCliente;

type
  TDaoClientes = class
  public
    procedure Inserir(const pCliente: TCliente);
    procedure Alterar(const pCliente: TCliente);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TCliente; overload;
    function Buscar(const pCodigo: Integer): TCliente; overload;
    function Consultar(const pNome: String): TObjectList<TCliente>;
  end;

implementation

uses
  FireDAC.Comp.Client, system.SysUtils;

{ TDaoClientes }

procedure TDaoClientes.Alterar(const pCliente: TCliente);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('update clientes set nome = ? where id = ?', [pCliente.Nome, pCliente.id]);
  finally
    vQy.Free;
  end;
end;

function TDaoClientes.Buscar(const pNome: String): TCliente;
var
  vQy: TFDQuery;
begin
  Result:= nil;

  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.SQL.Text:= 'SELECT id, nome, datacadastro FROM clientes WHERE nome = :nome';
    vQy.ParamByName('nome').AsString := pNome;

    vQy.Open;
    if not(vQy.Eof) then
    begin
      Result := TCliente.Create;
      Result.Id := vQy.FieldByName('id').AsInteger;
      Result.Nome := vQy.FieldByName('nome').AsString;
      Result.DataCadastro := vQy.FieldByName('datacadastro').AsDateTime;
    end;
  finally
    vQy.Free;
  end;
end;

function TDaoClientes.Buscar(const pCodigo: Integer): TCliente;
var
  vQy: TFDQuery;
begin
  Result:= nil;

  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.SQL.Text:= 'SELECT id, nome, datacadastro FROM clientes WHERE id = :id';
    vQy.ParamByName('id').AsInteger := pCodigo;

    vQy.Open;
    if not(vQy.Eof) then
    begin
      Result := TCliente.Create;
      Result.Id := vQy.FieldByName('id').AsInteger;
      Result.Nome := vQy.FieldByName('nome').AsString;
      Result.DataCadastro := vQy.FieldByName('datacadastro').AsDateTime;
    end;
  finally
    vQy.Free;
  end;
end;

function TDaoClientes.Consultar(const pNome: String): TObjectList<TCliente>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TCliente>;
  vCliente: TCliente;
begin
  vLista := TObjectList<TCliente>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.SQL.Text := 'SELECT id, nome, datacadastro FROM clientes WHERE nome LIKE :nome';
    vQy.ParamByName('nome').AsString := '%' + pNome + '%';
    vQy.Open;

    while not(vQy.Eof) do
    begin
      vCliente := TCliente.Create;
      vCliente.Id := vQy.FieldByName('id').AsInteger;
      vCliente.Nome := vQy.FieldByName('nome').AsString;
      vCliente.DataCadastro := vQy.FieldByName('datacadastro').AsDateTime;
      vLista.Add(vCliente);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

procedure TDaoClientes.Excluir(const pID: Integer);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('delete from clientes where id = ?', [pID]);
  finally
    vQy.Free;
  end;
end;

procedure TDaoClientes.Inserir(const pCliente: TCliente);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('insert into clientes (nome, datacadastro) values (?, ?)', [pCliente.Nome, DateToStr(Now)]);
  finally
    vQy.Free;
  end;
end;

end.
