unit uController.Lanche;

interface

uses
  System.Generics.Collections,
  uLanche, uDao.Lanche;

type
  TControllerLanche = class
  private
    FDao: TDaoLanche;
  public
    procedure Inserir(const pLanche: TLanche);
    procedure Alterar(const pLanche: TLanche);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TLanche;
    function Consultar(const pNome: String): TObjectList<TLanche>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerLanche }

procedure TControllerLanche.Alterar(const pLanche: TLanche);
begin
  Self.FDao.Alterar(pLanche);
end;

function TControllerLanche.Buscar(const pNome: String): TLanche;
begin
  Result:= Self.FDao.Buscar(pNome);
end;

function TControllerLanche.Consultar(const pNome: String): TObjectList<TLanche>;
begin
  Result:= Self.FDao.Consultar(pNome);
end;

constructor TControllerLanche.Create;
begin
  Self.FDao := TDaoLanche.Create;
end;

destructor TControllerLanche.Destroy;
begin
  FreeAndNil(Self.FDao);
  inherited;
end;

procedure TControllerLanche.Excluir(const pID: Integer);
begin
  Self.FDao.Excluir(pID);
end;

procedure TControllerLanche.Inserir(const pLanche: TLanche);
begin
  if pLanche.Nome = '' then
    raise Exception.Create('O nome do Lanche não deve ser vazio!');

  if pLanche.Preco = 0 then
    raise Exception.Create('O preço do Lanche deve ser maior que zero!');

  Self.FDao.Inserir(pLanche);
end;

end.
