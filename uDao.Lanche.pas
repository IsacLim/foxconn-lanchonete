unit uDao.Lanche;

interface

uses
  system.Generics.Collections,
  uDados, uLanche;

type
  TDaoLanche = class
  public
    procedure Inserir(const pLanche: TLanche);
    procedure Alterar(const pLanche: TLanche);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TLanche;
    function Consultar(const pNome: String): TObjectList<TLanche>; overload;
    function Consultar: TObjectList<TLanche>; overload;
  end;

implementation

uses
  FireDAC.DApt, FireDAC.Comp.Client, System.SysUtils, uIngrediente;

{ TDaoLanche }

procedure TDaoLanche.Inserir(const pLanche: TLanche);
var
  vQy, vQyItens: TFDQuery;
  vCont: Integer;
  vLanche: TLanche;
  vIngrediente: TIngrediente;
begin
  vQy:= TFDQuery.Create(nil);
  vQyItens:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('insert into lanches (nome, preco) values (?, ?)', [pLanche.Nome, pLanche.Preco]);

    vLanche:= Self.Buscar(pLanche.Nome);
    if vLanche = nil then
      raise Exception.Create('Erro ao buscar código do Lanche');

    vQyItens.Connection:= dados.Conn;
    for vIngrediente in pLanche.ListaIngredientes do
    begin
      vQyItens.ExecSQL('insert into ItensLanche (CodigoLanche, CodigoIngrediente, QtdItem) values (?, ?, ?)',
                  [vLanche.id, vIngrediente.ID, vIngrediente.Quantidade]);
    end;
  finally
    vQy.Free;
    vQyItens.Free;
    vLanche.Free;
  end;
end;

procedure TDaoLanche.Alterar(const pLanche: TLanche);
var
  vQy, vQyItens, vQyItensDel: TFDQuery;
  vCont: Integer;
  vIngrediente: TIngrediente;
begin
  vQy:= TFDQuery.Create(nil);
  vQyItens:= TFDQuery.Create(nil);
  vQyItensDel:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('update lanches set nome = ?, preco = ? where codigo = ?', [pLanche.Nome, pLanche.Preco, pLanche.id]);

    vQyItens.Connection:= dados.Conn;
    vQyItensDel.Connection:= dados.Conn;
    for vIngrediente in pLanche.ListaIngredientes do
    begin
      if vIngrediente.Quantidade = 0 then
      begin
        vQyItensDel.ExecSQL('delete from ItensLanche where CodigoLanche = ? and CodigoIngrediente = ?',
                        [pLanche.id, vIngrediente.ID]);
      end
      else
      begin
        vQyItens.ExecSQL('insert or replace into ItensLanche (CodigoLanche, CodigoIngrediente, QtdItem) values (?, ?, ?)',
                        [pLanche.id, vIngrediente.ID, vIngrediente.Quantidade]);
      end;
    end;
  finally
    vQy.Free;
    vQyItens.Free;
    vQyItensDel.Free;
  end;
end;

function TDaoLanche.Buscar(const pNome: String): TLanche;
var
  vQy, vQyItens: TFDQuery;
  vListaIngrediente: TObjectList<TIngrediente>;
  vIngrediente: TIngrediente;
  vLanche: TLanche;
begin
  vQy:= TFDQuery.Create(nil);
  vQyItens:= TFDQuery.Create(nil);
  vLanche:= TLanche.Create;
  vListaIngrediente:= TObjectList<TIngrediente>.Create;
  try
    vQy.Connection:= dados.Conn;
    vQy.Open('SELECT codigo, nome FROM lanches WHERE nome = ?', [pNome]);
    if not(vQy.Eof) then
    begin
      vLanche.id := vQy.FieldByName('codigo').AsInteger;
      vLanche.Nome := vQy.FieldByName('nome').AsString;
    end;

    vQyItens.Connection:= dados.Conn;
    vQyItens.Open('SELECT CodigoIngrediente, Nome, QtdItem, Preco FROM ItensLanche inner join Ingredientes on codigo = CodigoIngrediente WHERE CodigoLanche = ?', [vLanche.id]);
    while not(vQyItens.Eof) do
    begin
      vIngrediente:= TIngrediente.Create;
      vIngrediente.ID:= vQyItens.FieldByName('CodigoIngrediente').AsInteger;
      vIngrediente.Nome:= vQyItens.FieldByName('Nome').AsString;
      vIngrediente.Preco:= vQyItens.FieldByName('Preco').AsFloat;
      vIngrediente.Quantidade:= vQyItens.FieldByName('QtdItem').AsInteger;

      vListaIngrediente.Add(vIngrediente);
      vQyItens.Next;
    end;

    vLanche.ListaIngredientes:= vListaIngrediente;
    Result:= vLanche;
  finally
    vQy.Free;
    vQyItens.Free;
  end;
end;

function TDaoLanche.Consultar(const pNome: String): TObjectList<TLanche>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TLanche>;
  vLanche: TLanche;
begin
  vLista := TObjectList<TLanche>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.SQL.Text := 'SELECT codigo, nome FROM lanches WHERE nome LIKE :nome';
    vQy.ParamByName('nome').AsString := '%' + pNome + '%';
    vQy.Open;

    while not(vQy.Eof) do
    begin
      vLanche := TLanche.Create;
      vLanche.Id := vQy.FieldByName('codigo').AsInteger;
      vLanche.Nome := vQy.FieldByName('nome').AsString;
      vLista.Add(vLanche);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

function TDaoLanche.Consultar: TObjectList<TLanche>;
var
  vQy: TFDQuery;
  vLista: TObjectList<TLanche>;
  vLanche: TLanche;
begin
  vLista := TObjectList<TLanche>.Create;
  vQy := TFDQuery.Create(nil);
  try
    vQy.Connection := dados.Conn;
    vQy.Open('SELECT codigo, nome FROM lanches');

    while not(vQy.Eof) do
    begin
      vLanche := Self.Buscar(vQy.FieldByName('nome').AsString);
      vLista.Add(vLanche);
      vQy.Next;
    end;
  finally
    vQy.Free;
  end;
  Result := vLista;
end;

procedure TDaoLanche.Excluir(const pID: Integer);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.ExecSQL('delete from lanches where codigo = ?', [pID]);
  finally
    vQy.Free;
  end;
end;

end.
