unit uFrmSenhaBanco;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, System.Classes, Vcl.Controls, Vcl.ExtCtrls, Winapi.Windows;

type
  TFrmSenhaBanco = class(TForm)
    Label1: TLabel;
    edtSenha: TEdit;
    btnOK: TButton;
    btnCancelar: TButton;
  private
  public
    function GetSenha: string;
  end;

implementation

{$R *.dfm}

function TFrmSenhaBanco.GetSenha: string;
begin
  Result := edtSenha.Text;
end;

end.

