program SCAExcluiDigitais;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  uDM in 'uDM.pas' {DM: TDataModule},
  uFrmProgresso in 'uFrmProgresso.pas' {FrmProgresso},
  uFrmSenhaBanco in 'uFrmSenhaBanco.pas' {FrmSenhaBanco};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

