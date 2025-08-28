unit uLanche;

interface

uses
  System.Generics.Collections, uIngrediente;

type
  TLanche = class
  private
    FID: integer;
    FNome: string;
    FListaIngredientes: TObjectList<TIngrediente>;
    FPreco: Double;

    function GetPreco: Double;
  public
    property ID: integer read FID write FID;
    property Nome: string read FNome write FNome;
    property ListaIngredientes: TObjectList<TIngrediente> read FListaIngredientes write FListaIngredientes;
    property Preco: Double read GetPreco;
  end;

implementation

{ TLanche }

function TLanche.GetPreco: Double;
var
  vIngrediente: TIngrediente;
begin
  Result:= 0;

  for vIngrediente in Self.FListaIngredientes do
    Result:= Result + (vIngrediente.Quantidade * vIngrediente.Preco);
end;

end.
