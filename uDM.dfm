object DM: TDM
  Height = 480
  Width = 640
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 40
    Top = 40
  end
  object qSelect: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '    CadastrosDigitais.*'
      'FROM'
      '    CadastrosDigitais;')
    Left = 160
    Top = 56
  end
  object qExec: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 360
    Top = 88
  end
end
