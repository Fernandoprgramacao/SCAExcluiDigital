object FrmSenhaBanco: TFrmSenhaBanco
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Autentica'#231#227'o'
  ClientHeight = 116
  ClientWidth = 420
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnSenha: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 116
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitHeight = 160
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 127
      Height = 15
      Caption = 'Digite a senha do banco'
    end
    object edtSenha: TEdit
      Left = 8
      Top = 33
      Width = 406
      Height = 23
      BevelInner = bvNone
      PasswordChar = '*'
      TabOrder = 0
      Text = '*******'
    end
    object btnOK: TButton
      Left = 8
      Top = 80
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancelar: TButton
      Left = 112
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
