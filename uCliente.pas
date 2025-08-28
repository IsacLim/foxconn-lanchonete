unit uCliente;

interface

type
  TCliente = class
  private
    FID: Integer;
    FNome: String;
    FDataCadastro: TDate;
    FMesesCadastro: Integer;

    function GetMesesDesdeCadastro: Integer;
  public
    property ID: Integer read FID write FID;
    property Nome: String read FNome write FNome;
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
    property MesesCadastro: Integer read GetMesesDesdeCadastro;
  end;

implementation

uses
  System.SysUtils, System.DateUtils;

{ TCliente }

function TCliente.GetMesesDesdeCadastro: Integer;
begin
  Result:= MonthsBetween(Now, Self.FDataCadastro);
end;

end.
