unit uController.Ingrediente;

interface

uses
  System.Generics.Collections,
  uIngrediente, uDao.Ingrediente, uTypes;

type
  TControllerIngrediente = class
  private
    FDao: TDaoIngredientes;
  public
    procedure Inserir(const pIngrediente: TIngrediente);
    procedure Alterar(const pIngrediente: TIngrediente);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TIngrediente;
    function Consultar(const pNome: String): TObjectList<TIngrediente>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerIngrediente }

procedure TControllerIngrediente.Alterar(const pIngrediente: TIngrediente);
begin
  if pIngrediente.Id = 0 then
    raise Exception.Create('Selecione um Ingrediente antes de alterar!');

  Self.FDao.Alterar(pIngrediente);
end;

function TControllerIngrediente.Buscar(const pNome: String): TIngrediente;
begin
  Result:= Self.FDao.Buscar(pNome);
end;

procedure TControllerIngrediente.Excluir(const pID: Integer);
begin
  if pID = 0 then
    raise Exception.Create('Selecione um Ingrediente antes de excluir!');

  Self.FDao.Excluir(pID);
end;

procedure TControllerIngrediente.Inserir(const pIngrediente: TIngrediente);
begin
  if pIngrediente.Nome = '' then
    raise Exception.Create('O nome do Ingrediente não deve ser vazio!');

  if pIngrediente.Preco = 0 then
    raise Exception.Create('O preço do Ingrediente deve ser maior que zero!');

  Self.FDao.Inserir(pIngrediente);
end;

function TControllerIngrediente.Consultar(const pNome: String): TObjectList<TIngrediente>;
begin
  Result:= Self.FDao.Consultar(pNome);
end;

constructor TControllerIngrediente.Create;
begin
  Self.FDao := TDaoIngredientes.Create;
end;

destructor TControllerIngrediente.Destroy;
begin
  FreeAndNil(Self.FDao);
  inherited;
end;

end.
