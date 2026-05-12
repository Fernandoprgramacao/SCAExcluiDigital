object FrmProgresso: TFrmProgresso
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Processando...'
  ClientHeight = 170
  ClientWidth = 408
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 408
    Height = 170
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lbStatus: TLabel
      Left = 0
      Top = 0
      Width = 408
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Processando...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 110
    end
    object lbPercentual: TLabel
      Left = 0
      Top = 18
      Width = 408
      Height = 133
      Align = alClient
      Alignment = taCenter
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = 56
      ExplicitWidth = 18
      ExplicitHeight = 17
    end
    object pb: TProgressBar
      Left = 0
      Top = 151
      Width = 408
      Height = 19
      Align = alBottom
      Smooth = True
      TabOrder = 0
    end
  end
end
