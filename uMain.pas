unit uMain;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.FileCtrl, Data.DB, Data.Win.ADODB, uDM, uFrmProgresso, uFrmSenhaBanco, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Fundo: TPanel;
    gbCaminho: TGroupBox;
    PanelRodape: TPanel;
    btExcluir: TButton;
    btCancelar: TButton;
    btConectar: TButton;
    rbCaminhoC: TRadioButton;
    lbOutro: TLabel;
    pnTopo: TPanel;
    pnFechar: TPanel;
    pnMinimizar: TPanel;
    lbTituloFormXY: TLabel;
    pnLeft: TPanel;
    pnRodape: TPanel;
    pnRight: TPanel;
    pnBordaTop: TPanel;
    btnAbrirSincronizador: TButton;
    gbResumo: TGroupBox;
    lbStatus: TLabel;
    lbQtd: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); // ⬅ AQUI
    procedure btConectarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);

    procedure btCancelarClick(Sender: TObject);
    procedure rbCaminhoCClick(Sender: TObject);
    procedure pnFecharClick(Sender: TObject);
    procedure pnMinimizarClick(Sender: TObject);

    procedure pnFecharMouseEnter(Sender: TObject);
    procedure pnFecharMouseLeave(Sender: TObject);
    procedure pnMinimizarMouseEnter(Sender: TObject);
    procedure pnMinimizarMouseLeave(Sender: TObject);


    procedure pnTopoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure btnAbreSincronizadorClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);


    private
      FProcessandoExclusao: Boolean;
      procedure SetBotoes(Enable: Boolean);
      procedure AtualizarQuantidade;
      procedure AtualizarEstadoConexao;
      procedure PanelHoverEnter(Sender: TObject; CorHover: TColor);
      procedure PanelHoverLeave(Sender: TObject; CorNormal: TColor);
      function ConectarBanco(const CaminhoBanco: string): Boolean;

  public

end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  WindowState := wsNormal;
  Position := poScreenCenter;

  if Assigned(DM) and DM.ADOConnection1.Connected then
    DM.ADOConnection1.Connected := False;

  AtualizarEstadoConexao;

  // vincula o evento de fechamento
  Self.OnCloseQuery := FormCloseQuery;

  // inicializa a flag
  FProcessandoExclusao := False;
end;


procedure TForm1.AtualizarEstadoConexao;
var
  Conectado: Boolean;
begin
  Conectado :=
    Assigned(DM) and
    Assigned(DM.ADOConnection1) and
    DM.ADOConnection1.Connected;

  btExcluir.Enabled  := Conectado;
  btCancelar.Enabled := Conectado;
  btConectar.Enabled := not Conectado;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(DM) then
  begin
    if DM.ADOConnection1.Connected then
      DM.ADOConnection1.Connected := False;

    FreeAndNil(DM);
  end;

  Action := caFree;
end;


procedure TForm1.pnFecharClick(Sender: TObject);
begin
  Close;
end;



procedure TForm1.pnMinimizarClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.PanelHoverEnter(Sender: TObject; CorHover: TColor);
begin
  if Sender is TPanel then
  begin
    TPanel(Sender).Color := CorHover;
    TPanel(Sender).Cursor := crHandPoint;
  end;
end;

procedure TForm1.PanelHoverLeave(Sender: TObject; CorNormal: TColor);
begin
  if Sender is TPanel then
    TPanel(Sender).Color := CorNormal;
end;

procedure TForm1.pnFecharMouseEnter(Sender: TObject);
begin
  PanelHoverEnter(Sender, $002020C0);
end;

procedure TForm1.pnFecharMouseLeave(Sender: TObject);
begin
  PanelHoverLeave(Sender, $003333D8);
end;

procedure TForm1.pnMinimizarMouseEnter(Sender: TObject);
begin
  PanelHoverEnter(Sender, $00C84A00);
end;

procedure TForm1.pnMinimizarMouseLeave(Sender: TObject);
begin
  PanelHoverLeave(Sender, $00E55D0D);
end;


procedure TForm1.pnTopoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_SYSCOMMAND, SC_MOVE + HTCAPTION, 0);
end;

procedure TForm1.btnAbreSincronizadorClick(Sender: TObject);
const
  CaminhoExe = 'Caminho';
begin
  if not FileExists(CaminhoExe) then
  begin
    ShowMessage('Sincronizador não encontrado no caminho:' + sLineBreak + CaminhoExe);
    Exit;
  end;

  ShellExecute(
    Handle,
    'open',
    PChar(CaminhoExe),
    nil,
    nil,
    SW_SHOWNORMAL
  );
end;


function TForm1.ConectarBanco(const CaminhoBanco: string): Boolean;
var
  SenhaBanco: string;
begin
  Result := False;


  SenhaBanco := '';

  if DM.Conectar(CaminhoBanco, SenhaBanco) then
  begin
    lbStatus.Caption := 'Conectado ao banco!';
    lbQtd.Caption := 'Digitais cadastradas: ' + DM.ContarDigitais.ToString;
    AtualizarEstadoConexao;
    Result := True;
  end
  else
    lbStatus.Caption := 'Não foi possível conectar ao banco. Verifique o caminho.';
end;

procedure TForm1.rbCaminhoCClick(Sender: TObject);
begin
  if rbCaminhoC.Checked then
  begin
    if not ConectarBanco('Caminho') then
      rbCaminhoC.Checked := False;
  end;
end;

procedure TForm1.btConectarClick(Sender: TObject);
var
  CaminhoBanco: string;
  dlgOpen: TOpenDialog;
begin
  dlgOpen := TOpenDialog.Create(Self);
  try
    dlgOpen.Title := 'Abrir...';
    dlgOpen.Filter := 'Arquivos MDB|*.mdb';
    dlgOpen.Options := [ofFileMustExist, ofPathMustExist];

    if not dlgOpen.Execute then
    begin
      lbStatus.Caption := 'Conexão cancelada pelo usuário.';
      Exit;
    end;

    CaminhoBanco := dlgOpen.FileName;
    ConectarBanco(CaminhoBanco);
  finally
    dlgOpen.Free;
  end;
end;


procedure TForm1.btCancelarClick(Sender: TObject);
begin
  if DM.ADOConnection1.Connected then
  begin
    DM.ADOConnection1.Connected := False;
    lbStatus.Caption := 'Conexão encerrada.';
  end;

  lbQtd.Caption := 'Digitais cadastradas: 0';
  rbCaminhoC.Checked := False;

  AtualizarEstadoConexao;
end;


procedure TForm1.AtualizarQuantidade;
begin
  lbQtd.Caption := 'Digitais cadastradas: ' + DM.ContarDigitais.ToString;
end;


procedure TForm1.SetBotoes(Enable: Boolean);
begin
  btExcluir.Enabled := Enable;
  btCancelar.Enabled := Enable;
  btConectar.Enabled := Enable;
  btnAbrirSincronizador.Enabled := Enable;
  // Adicione aqui outros botões que queira bloquear
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FProcessandoExclusao then
  begin
    CanClose := False;
    ShowMessage('A exclusão está em andamento. Aguarde finalizar.');
  end
  else
    CanClose := True;
end;

procedure TForm1.btExcluirClick(Sender: TObject);
var
  FrmProg: TFrmProgresso;
  ProgressoAtual, Alvo, Total: Integer;
begin
  Total := DM.ContarDigitais;
  if Total = 0 then
  begin
    lbStatus.Caption := 'Nenhuma digital para excluir.';
    lbQtd.Caption := 'Digitais cadastradas: 0';
    ShowMessage('Nenhuma digital encontrada para exclusão.');
    Exit;
  end;

  // BLOQUEIA BOTOES E FECHAMENTO
  SetBotoes(False);
  FProcessandoExclusao := True;

  FrmProg := TFrmProgresso.Create(Self);
  try
    FrmProg.Show;
    FrmProg.Update;

    // FASE 0 – PREPARANDO (0%)
    ProgressoAtual := 0;
    FrmProg.Atualizar(0, 'Preparando...');
    Sleep(800);

    // FASE 1 – EXCLUINDO (1 → 90)
    DM.ExcluirDigitaisComProgresso(
      procedure(Percentual: Integer)
      begin
        Alvo := 1 + (Percentual * 89 div 100);
        if Alvo > 90 then
          Alvo := 90;

        while ProgressoAtual < Alvo do
        begin
          Inc(ProgressoAtual);
          FrmProg.Atualizar(ProgressoAtual, 'Excluindo digitais...');
          Sleep(90);
        end;
      end
    );

    // FASE 2 – FINALIZANDO (95 → 99)
    ProgressoAtual := 95;
    FrmProg.Atualizar(95, 'Finalizando...');
    Sleep(300);

    while ProgressoAtual < 99 do
    begin
      Inc(ProgressoAtual);
      FrmProg.Atualizar(ProgressoAtual, 'Finalizando...');
      Sleep(120);
    end;

    // FINALIZADO (100)
    FrmProg.Atualizar(100, 'Finalizado');
    Sleep(400);

  finally
    FrmProg.Close;
    FrmProg.Free;

    // DESBLOQUEIA BOTOES E FECHAMENTO
  SetBotoes(True);
    FProcessandoExclusao := False;
  end;

  lbStatus.Caption := 'Digitais excluídas com sucesso!';
  lbQtd.Caption := 'Digitais cadastradas: 0';

  ShowMessage('Realize a sincronização no dispositivo.');
end;



end.

