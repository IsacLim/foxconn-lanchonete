program TesteLanchonete;

{$APPTYPE CONSOLE}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  uTesteLanchonete in 'uTesteLanchonete.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
begin
  try
    // Verifica parâmetros da linha de comando (opcional)
    TDUnitX.CheckCommandLine;

    // Cria o runner
    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;
    Runner.FailsOnNoAsserts := False;

    // Logger no console
    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);

    // Executa os testes
    Results := Runner.Execute;

    // Retorna erro se algum teste falhar
    if not Results.AllPassed then
      System.ExitCode := 1
    else
      System.ExitCode := 0;

    // Espera o usuário apertar Enter antes de fechar (opcional)
    Writeln;
    Writeln('Execução concluída. Pressione ENTER para sair...');
    Readln;

  except
    on E: Exception do
    begin
      Writeln('Erro: ', E.ClassName, ': ', E.Message);
      System.ExitCode := 1;
      Readln;
    end;
  end;
end.
