unit uMoeda;

interface

uses
  System.JSON, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TMoeda = class
  public
    class function ConverterBrlToUsd(const pValorBRL: Double): Double;
  end;

implementation

uses
  system.SysUtils;

{ TMoeda }

class function TMoeda.ConverterBrlToUsd(const pValorBRL: Double): Double;
  function FloatToApiStr(Value: Double): string;
  var
    vFS: TFormatSettings;
  begin
    vFS := TFormatSettings.Create;
    vFS.DecimalSeparator := '.';
    Result := FloatToStr(Value, vFS);
  end;

var
  vHttp: THttpClient;
  vResp: IHTTPResponse;
  vUrl, vJsonText: string;
  vJson: TJSONObject;
begin
  Result := 0;

  vHttp := THttpClient.Create;
  try
    vUrl := 'https://moneymorph.dev/api/convert/' + FloatToApiStr(pValorBRL) + '/BRL/USD';

    vResp := vHttp.Get(vUrl);

    if vResp.StatusCode = 200 then
    begin
      vJsonText := vResp.ContentAsString(TEncoding.UTF8);
      vJson := TJSONObject.ParseJSONValue(vJsonText) as TJSONObject;
      try
        if vJson.TryGetValue('response', Result) then
          Exit;
      finally
        vJson.Free;
      end;
    end
    else
      raise Exception.Create('Erro na requisição: ' + vResp.StatusText);
  finally
    vHttp.Free;
  end;
end;

//Exemplo Json de Retorno
(*"meta":{"timestamp":1756306726,"rate":0.1839},"request":{"query":"/convert/40.0/BRL/USD","from":"BRL","to":"USD","amount":40.0},"response":7.356*)

end.
