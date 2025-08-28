object Dados: TDados
  OnCreate = DataModuleCreate
  Height = 154
  Width = 135
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 32
    Top = 32
  end
end
