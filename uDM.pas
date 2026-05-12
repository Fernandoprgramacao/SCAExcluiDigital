unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.Variants, Vcl.Dialogs;

type
  TDM = class(TDataModule)
    ADOConnection1: TADOConnection;
    qExec: TADOQuery;
    qSelect: TADOQuery;
  public
    function Conectar(const Caminho, Senha: string): Boolean;
    function ContarDigitais: Integer;
    function ContarDigitaisExcluidas: Integer;
    procedure ExcluirDigitaisComProgresso(
       AOnProgresso: TProc<Integer>
    );
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TDM.Conectar(const Caminho, Senha: string): Boolean;
begin
  Result := False;
  try
    ADOConnection1.Connected := False;
    ADOConnection1.ConnectionString :=
      'Provider=Microsoft.Jet.OLEDB.4.0;' +
      'Data Source=' + Caminho + ';' +
      'Persist Security Info=False;' +
      'Jet OLEDB:Database Password=' + Senha;

    ADOConnection1.Connected := True;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Erro ao conectar: ' + E.Message);
    end;
  end;
end;


function TDM.ContarDigitais: Integer;
begin
  Result := 0;
  qSelect.Close;
  qSelect.SQL.Text := 'SELECT COUNT(*) AS Total FROM CadastrosDigitais';
  qSelect.Open;
  Result := qSelect.FieldByName('Total').AsInteger;
end;

function TDM.ContarDigitaisExcluidas: Integer;
begin
  Result := 0;
  qSelect.Close;
  qSelect.SQL.Text := 'SELECT COUNT(*) AS Total FROM DigitaisExcluir';
  qSelect.Open;
  Result := qSelect.FieldByName('Total').AsInteger;
end;

procedure TDM.ExcluirDigitaisComProgresso(
  AOnProgresso: TProc<Integer>
);
var
  TotalAntes, TotalDepois: Integer;
begin
  // 🔹 Quantos registros existem antes
  qSelect.Close;
  qSelect.SQL.Text := 'SELECT COUNT(*) AS Total FROM CadastrosDigitais';
  qSelect.Open;
  TotalAntes := qSelect.FieldByName('Total').AsInteger;
  qSelect.Close;

  if TotalAntes = 0 then
  begin
    if Assigned(AOnProgresso) then
      AOnProgresso(100);
    Exit;
  end;

  ADOConnection1.BeginTrans;
  try
    // ===============================
    // PASSO 1 – COPIA
    // ===============================
    qExec.Close;
    qExec.SQL.Text :=
      'INSERT INTO DigitaisExcluir (CodigoDigital) ' +
      'SELECT C.CodigoDigital ' +
      'FROM CadastrosDigitais AS C ' +
      'WHERE C.CodigoDigital IS NOT NULL ' +
      'AND NOT EXISTS (' +
      '  SELECT 1 FROM DigitaisExcluir AS D ' +
      '  WHERE D.CodigoDigital = C.CodigoDigital' +
      ')';
    qExec.ExecSQL;

    if Assigned(AOnProgresso) then
      AOnProgresso(50);

    // ===============================
    // PASSO 1.1 – VALIDA SE COPIOU
    // ===============================
    qSelect.Close;
    qSelect.SQL.Text := 'SELECT COUNT(*) AS Total FROM DigitaisExcluir';
    qSelect.Open;
    TotalDepois := qSelect.FieldByName('Total').AsInteger;
    qSelect.Close;

    if TotalDepois = 0 then
      raise Exception.Create(
        'Aviso: Nenhuma digital foi copiada para DigitaisExcluir.'
      );

    // ===============================
    // PASSO 2 – DELETE (SÓ SE COPIOU)
    // ===============================
    qExec.Close;
    qExec.SQL.Text := 'DELETE FROM CadastrosDigitais';
    qExec.ExecSQL;

    if Assigned(AOnProgresso) then
      AOnProgresso(100);

    ADOConnection1.CommitTrans;

  except
    ADOConnection1.RollbackTrans;
    raise Exception.Create(
      'Erro durante o processamento. Nenhuma alteração foi salva.'
    );
  end;
end;


end.

