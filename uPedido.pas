unit uPedido;

interface

uses
  system.Generics.Collections,
  uLanche, uAcompanhamento, uCliente;

type
  TPedido = class
  private
    FAdicionouXSalada, FAdicionouBataFrita: Boolean;
  private
    FID: Integer;
    FCliente: TCliente;
    FListaLanche: TObjectList<TLanche>;
    FListaAcompanhamento: TObjectList<TAcompanhamento>;
    FPreco: Double;

    function GetPreco: Double;
  public
    property ID: Integer read FID write FID;
    property Cliente: TCliente read FCliente write FCliente;
    property ListaLanche: TObjectList<TLanche> read FListalanche;
    property ListaAcompanhamento: TObjectList<TAcompanhamento> read FListaAcompanhamento;
    property Preco: Double read GetPreco;

    procedure AdicionarLanche(const pLanche: TLanche);
    procedure AdicionarAcompanhamento(const pAcompanhamento: TAcompanhamento);

    function TemDireitoRefrigeranteGratis: Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TPedido }

procedure TPedido.AdicionarAcompanhamento(const pAcompanhamento: TAcompanhamento);
var
  vCompanhamento: TAcompanhamento;
begin
  vCompanhamento:= TAcompanhamento.Create;
  vCompanhamento.ID:= pAcompanhamento.ID;
  vCompanhamento.Nome:= pAcompanhamento.Nome;
  vCompanhamento.Preco:= pAcompanhamento.Preco;
  vCompanhamento.Quantidade:= pAcompanhamento.Quantidade;
  vCompanhamento.Tipo:= pAcompanhamento.Tipo;

  Self.FListaAcompanhamento.Add(vCompanhamento);

  if not(Self.FAdicionouBataFrita) then
    Self.FAdicionouBataFrita:= LowerCase(vCompanhamento.Nome) = 'batata frita';
end;

procedure TPedido.AdicionarLanche(const pLanche: TLanche);
var
  vLanche: TLanche;
begin
  vLanche:= TLanche.Create;
  vLanche.ID:= pLanche.ID;
  vLanche.Nome:= pLanche.Nome;
  vLanche.ListaIngredientes:= pLanche.ListaIngredientes;

  Self.FListaLanche.Add(vLanche);

  if not(Self.FAdicionouXSalada) then
    Self.FAdicionouXSalada:= LowerCase(vLanche.Nome) = 'x-salada';
end;

constructor TPedido.Create;
begin
  Self.FListaLanche:= TObjectList<TLanche>.Create;
  Self.FListaAcompanhamento:= TObjectList<TAcompanhamento>.Create;

  Self.FAdicionouXSalada:= False;
  Self.FAdicionouBataFrita:= False;
end;

destructor TPedido.Destroy;
begin
  FreeAndNil(Self.FListaLanche);
  FreeAndNil(Self.FListaAcompanhamento);
  inherited;
end;

function TPedido.GetPreco: Double;
var
  vLanche: TLanche;
  vAcompanhamento: TAcompanhamento;
begin
  Result:= 0;

  for vLanche in Self.FListaLanche do
    Result:= Result + vLanche.Preco;

  for vAcompanhamento in Self.FListaAcompanhamento do
    Result:= Result + vAcompanhamento.Preco;

  //Desconto de 3% se pedido Maior que 50
  if Result > 50 then
    Result:= Result * 0.97;

  //Desconto de 5% se o cliente foi cadastrado a mais de 6 meses
  if ((Self.FCliente <> nil) and (Self.FCliente.MesesCadastro > 6)) then
    Result:= Result * 0.95;
end;

function TPedido.TemDireitoRefrigeranteGratis: Boolean;
begin
  Result:= ((Self.FAdicionouXSalada) and (Self.FAdicionouBataFrita));
end;

end.
