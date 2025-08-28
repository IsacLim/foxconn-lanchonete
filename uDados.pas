unit uDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait;

type
  TDados = class(TDataModule)
    Conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dados: TDados;

implementation

uses
  vcl.Forms;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDados.DataModuleCreate(Sender: TObject);
begin
  Conn.Connected:= False;
  Conn.Params.Clear;
  Conn.Params.DriverID:= 'SQLite';
  Conn.Params.Database:= ExtractFilePath(Application.ExeName) + 'banco';
  Conn.Connected:= True;
end;

end.
