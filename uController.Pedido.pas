unit uController.Pedido;

interface

uses
  uDao.Pedido, uPedido;

type
  TControllerPedido = class
  private
    FDao: TDaoPedido;
  public
    procedure Salvar(const pPedido: TPedido);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerPedido }

constructor TControllerPedido.Create;
begin
  Self.FDao:= TDaoPedido.Create;
end;

destructor TControllerPedido.Destroy;
begin
  FreeAndNil(Self.FDao);
  inherited;
end;

procedure TControllerPedido.Salvar(const pPedido: TPedido);
begin
  Self.FDao.Salvar(pPedido);
end;

end.
