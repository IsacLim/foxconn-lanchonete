unit ufrLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, uTypes, ufrStyle;

type
  TfrLogin = class(TForm)
    pnFundo: TPanel;
    edLogin: TEdit;
    edSenha: TEdit;
    lbSenha: TLabel;
    lbLogin: TLabel;
    btLogar: TCornerButton;
    procedure btLogarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FClassificacao: TClassificacao;
  public
    property Classificacao: TClassificacao read FClassificacao;
  end;

var
  frLogin: TfrLogin;

implementation

uses
  uDados, FireDAC.Comp.Client;

{$R *.fmx}

procedure TfrLogin.btLogarClick(Sender: TObject);
var
  vQy: TFDQuery;
begin
  vQy:= TFDQuery.Create(nil);
  try
    vQy.Connection:= dados.Conn;
    vQy.Open('select * from usuarios where login = ? and senha = ?', [Trim(edLogin.Text), Trim(edSenha.Text)]);

    if not(vQy.Eof) then
      Self.FClassificacao:= TClassificacao(vQy.FieldByName('classificacao').AsInteger)
    else
      Raise exception.Create('Usuário ou Senha inválido(a).');
  finally
    vQy.Free;
  end;
end;

procedure TfrLogin.FormCreate(Sender: TObject);
begin
  Self.FClassificacao:= clCliente;
end;

procedure TfrLogin.FormShow(Sender: TObject);
begin
  edLogin.SetFocus;
end;

end.
