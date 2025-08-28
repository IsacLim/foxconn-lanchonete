unit uIngrediente;

interface

uses
  uTypes;

type
  TIngrediente = class
  private
    FID: Integer;
    FNome: String;
    FPreco: Double;
    FQuantidade: Integer;
    FTipo: TTipo;
  public
    property ID: Integer read FID write FID;
    property Nome: String read FNome write FNome;
    property Preco: Double read FPreco write FPreco;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property Tipo: TTipo read FTipo write FTipo;
  end;

implementation

end.
