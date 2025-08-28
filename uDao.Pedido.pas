unit uDao.Pedido;

interface

uses
  uPedido;

type
  TDaoPedido = class
  public
    procedure Salvar(const pPedido: TPedido);
  end;

implementation

uses
  FireDAC.Comp.Client, System.SysUtils,
  uLanche, uAcompanhamento, uDados;

{ TDaoPedido }

procedure TDaoPedido.Salvar(const pPedido: TPedido);
var
  vQy: TFDQuery;
  vLanche: TLanche;
  vAcompanhamento: TAcompanhamento;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;

    for vLanche in pPedido.ListaLanche do
    begin
      vQy.ExecSQL('insert into Pedido (CodigoCliente, CodigoLanche, CodigoAcompanhamento, Preco, DataCriacao) values '+
                  '(?, ?, ?, ?, ?)', [pPedido.Cliente.ID, vLanche.ID, 0, pPedido.Preco, DateToStr(Now)]);
    end;

    for vAcompanhamento in pPedido.ListaAcompanhamento do
    begin
      vQy.ExecSQL('insert into Pedido (CodigoCliente, CodigoLanche, CodigoAcompanhamento, Preco, DataCriacao) values '+
                  '(?, ?, ?, ?, ?)', [pPedido.Cliente.ID, 0, vAcompanhamento.ID, pPedido.Preco, DateToStr(Now)]);
    end;
  finally
    vQy.Free;
  end;
end;

end.
