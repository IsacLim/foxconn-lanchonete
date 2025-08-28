unit uController.Acompanhamentos;

interface

uses
  System.Generics.Collections,
  uAcompanhamento, uDao.Acompanhamentos, uTypes;

type
  TControllerAcompanhamento = class
  private
    FDao: TDaoAcompanhamentos;
  public
    procedure Inserir(const pAcompanhamento: TAcompanhamento);
    procedure Alterar(const pAcompanhamento: TAcompanhamento);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TAcompanhamento;
    function Consultar(const pNome: String; const pTipo: TTipo): TObjectList<TAcompanhamento>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerAcompanhamento }

procedure TControllerAcompanhamento.Alterar(const pAcompanhamento: TAcompanhamento);
begin
  if pAcompanhamento.Id = 0 then
    raise Exception.Create('Selecione um Acompanhamento antes de alterar!');

  Self.FDao.Alterar(pAcompanhamento);
end;

function TControllerAcompanhamento.Buscar(const pNome: String): TAcompanhamento;
begin
  Result:= Self.FDao.Buscar(pNome);
end;

procedure TControllerAcompanhamento.Excluir(const pID: Integer);
begin
  if pID = 0 then
    raise Exception.Create('Selecione um Acompanhamento antes de excluir!');

  Self.FDao.Excluir(pID);
end;

procedure TControllerAcompanhamento.Inserir(const pAcompanhamento: TAcompanhamento);
begin
  if pAcompanhamento.Nome = '' then
    raise Exception.Create('O nome do Acompanhamento não deve ser vazio!');

  if ((pAcompanhamento.Tipo <> tpBebida) and (pAcompanhamento.Preco = 0)) then
    raise Exception.Create('O preço do Acompanhamento deve ser maior que zero!');

  Self.FDao.Inserir(pAcompanhamento);
end;

function TControllerAcompanhamento.Consultar(const pNome: String; const pTipo: TTipo): TObjectList<TAcompanhamento>;
begin
  Result:= Self.FDao.Consultar(pNome, pTipo);
end;

constructor TControllerAcompanhamento.Create;
begin
  Self.FDao := TDaoAcompanhamentos.Create;
end;

destructor TControllerAcompanhamento.Destroy;
begin
  FreeAndNil(Self.FDao);
  inherited;
end;

end.
