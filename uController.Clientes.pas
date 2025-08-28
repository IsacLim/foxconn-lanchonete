unit uController.Clientes;

interface

uses
  System.Generics.Collections,
  uCliente, uDao.Cliente;

type
  TControllerCliente = class
  private
    FDao: TDaoClientes;
  public
    procedure Inserir(const pCliente: TCliente);
    procedure Alterar(const pCliente: TCliente);
    procedure Excluir(const pID: Integer);

    function Buscar(const pNome: String): TCliente; overload;
    function Buscar(const pCodigo: Integer): TCliente; overload;
    function Consultar(const pNome: String): TObjectList<TCliente>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerCliente }

procedure TControllerCliente.Alterar(const pCliente: TCliente);
begin
  if pCliente.Id = 0 then
    raise Exception.Create('Selecione um Cliente antes de alterar!');

  Self.FDao.Alterar(pCliente);
end;

function TControllerCliente.Buscar(const pNome: String): TCliente;
begin
  Result:= Self.FDao.Buscar(pNome);
end;

function TControllerCliente.Buscar(const pCodigo: Integer): TCliente;
begin
  Result:= Self.FDao.Buscar(pCodigo);
end;

function TControllerCliente.Consultar(const pNome: String): TObjectList<TCliente>;
begin
  Result:= Self.FDao.Consultar(pNome);
end;

constructor TControllerCliente.Create;
begin
  Self.FDao := TDaoClientes.Create;
end;

destructor TControllerCliente.Destroy;
begin
  FreeAndNil(Self.FDao);
  inherited;
end;

procedure TControllerCliente.Excluir(const pID: Integer);
begin
  if pID = 0 then
    raise Exception.Create('Selecione um Cliente antes de excluir!');

  Self.FDao.Excluir(pID);
end;

procedure TControllerCliente.Inserir(const pCliente: TCliente);
begin
  if pCliente.Nome = '' then
    raise Exception.Create('O nome do Cliente não deve ser vazio!');

  Self.FDao.Inserir(pCliente);
end;

end.
