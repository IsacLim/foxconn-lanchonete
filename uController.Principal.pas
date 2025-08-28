unit uController.Principal;

interface

uses
  System.Generics.Collections,
  uTypes, uDao.Lanche, uLanche, uDao.Acompanhamentos, uAcompanhamento;

type
  TControllerPrincipal = class
  private
    FDaoLanche: TDaoLanche;
    FDaoAcompanhamento: TDaoAcompanhamentos;
  public
    function ConsultarLanches: TObjectList<TLanche>;
    function ConsultarAcompanhamentos(const pTipo: TTipo): TObjectList<TAcompanhamento>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TControllerPrincipal }

function TControllerPrincipal.ConsultarAcompanhamentos(const pTipo: TTipo): TObjectList<TAcompanhamento>;
begin
  Result:= Self.FDaoAcompanhamento.Consultar(pTipo);
end;

function TControllerPrincipal.ConsultarLanches: TObjectList<TLanche>;
begin
  Result:= Self.FDaoLanche.Consultar;
end;

constructor TControllerPrincipal.Create;
begin
  Self.FDaoLanche := TDaoLanche.Create;
  Self.FDaoAcompanhamento := TDaoAcompanhamentos.Create;
end;

destructor TControllerPrincipal.Destroy;
begin
  FreeAndNil(Self.FDaoLanche);
  FreeAndnil(Self.FDaoAcompanhamento);
  inherited;
end;

end.
