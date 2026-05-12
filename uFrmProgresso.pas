unit uFrmProgresso;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmProgresso = class(TForm)
    Panel1: TPanel;
    lbStatus: TLabel;
    lbPercentual: TLabel;
    pb: TProgressBar;
  public
    procedure Atualizar(Progresso: Integer; const Texto: string = 'Processando...');
  end;

var
  FrmProgresso: TFrmProgresso;

implementation

{$R *.dfm}

procedure TFrmProgresso.Atualizar(Progresso: Integer; const Texto: string);
begin
  if Progresso < 0 then Progresso := 0;
  if Progresso > 100 then Progresso := 100;

  pb.Position := Progresso;
  lbPercentual.Caption := Progresso.ToString + '%';
  lbStatus.Caption := Texto;

  Application.ProcessMessages;
end;

end.

