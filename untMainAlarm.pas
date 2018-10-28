unit untMainAlarm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, MPlayer, ShellAPI, Menus, AppEvnts,
  Buttons, ExtDlgs, XPMan, IniFiles, ActnList, ComCtrls, ToolWin, ImgList;

const
  WM_ICONTRAY = WM_USER + 1;
  INI_SECTION = 'Info';

type
  TfrmAlarm = class(TForm)
    OpenDialog1: TOpenDialog;
    tmrAlarm: TTimer;
    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    tmrShowVars: TTimer;
    spbShowsvPanel: TSpeedButton;
    N1: TMenuItem;
    Quit1: TMenuItem;
    ActionList1: TActionList;
    actSnooze: TAction;
    PageScroller1: TPageScroller;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    svPanel: TPanel;
    Label2: TLabel;
    svH: TLabel;
    Label4: TLabel;
    svH1: TLabel;
    Label6: TLabel;
    svM: TLabel;
    Label8: TLabel;
    svM1: TLabel;
    Label10: TLabel;
    svS: TLabel;
    Label12: TLabel;
    svS1: TLabel;
    Label3: TLabel;
    svtmrAlarmInterval: TLabel;
    svTime: TLabel;
    svAlarmNow: TLabel;
    actStopSound: TAction;
    tbnStop: TToolButton;
    tbnSnooze: TToolButton;
    ImageList1: TImageList;
    gbxOptions: TGroupBox;
    edtFileName: TEdit;
    btnOpenFile: TButton;
    Label1: TLabel;
    edtAlertMessage: TEdit;
    Label7: TLabel;
    btnStopSound: TButton;
    gbxMainSettings: TGroupBox;
    mskTime: TMaskEdit;
    lblAlarm: TLabel;
    ToolButton1: TToolButton;
    tbnAbout: TToolButton;
    actAbout: TAction;
    chbActive: TCheckBox;
    chbRepeat: TCheckBox;
    chbMatchSeconds: TCheckBox;
    Label5: TLabel;
    mskSnooze: TMaskEdit;
    actGoToTray: TAction;
    mplAlarm: TMediaPlayer;
    rgpAction: TRadioGroup;
    tbnCalendar: TToolButton;
    actCalendar: TAction;
    N2: TMenuItem;
    N11: TMenuItem;
    Snooze1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    procedure btnOpenFileClick(Sender: TObject);
    procedure chbActiveClick(Sender: TObject);
    procedure tmrAlarmTimer(Sender: TObject);
    procedure mskTimeChange(Sender: TObject);
    procedure mskTimeExit(Sender: TObject);
    procedure mplAlarmNotify(Sender: TObject);
    procedure chbMatchSecondsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure tmrShowVarsTimer(Sender: TObject);
    procedure spbShowsvPanelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure actSnoozeExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actGoToTrayExecute(Sender: TObject);
    procedure actStopSoundExecute(Sender: TObject);
    procedure actCalendarExecute(Sender: TObject);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;
    procedure InitialTrayIcon;
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure ShowVars;
    procedure RegisterInIni(Section, Ident: String; Value: Variant);
    procedure RegIniBoolean(Section, Ident: String; Value: Boolean);
    procedure RegIniInteger(Section, Ident: String; Value: Integer);
    procedure RegIniString(Section, Ident: String; Value: String);
    procedure ShowsvPanel;
    procedure procGoToTray;
    procedure Alarm;
    function Sto_GetFmtFileVersion(const FileName: String = '';
      const Fmt: String = '%d.%d.%d.%d'): String;
  public
    { Public declarations }
    procedure WMSysCommand(var msg: TWMSysCommand); message WM_SYSCOMMAND;
  end;

var
  frmAlarm: TfrmAlarm;
  SysOp: TIniFile;
  AlarmNow, GoToTray: Boolean;
  H, M, S, mS, H1, M1, S1: Word;
  CurrDir: String;
  formWidth: Integer = 560;
  AlarmTime: TDateTime;

implementation

uses DateUtils, Types, Math, Convert_Dates;

{$R *.dfm}

procedure TfrmAlarm.InitialTrayIcon;
begin
  with TrayIconData do
  begin
    cbSize := SizeOf(TrayIconData);
    Wnd := Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;

  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
end;

procedure TfrmAlarm.TrayMessage(var Msg: TMessage);
var
  p : TPoint;
begin
{  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      ShowMessage('This icon responds to RIGHT BUTTON click!');
    end;
    WM_RBUTTONDOWN:
    begin
       SetForegroundWindow(Handle);
       GetCursorPos(p);
       PopUpMenu1.Popup(p.x, p.y);
       PostMessage(Handle, WM_NULL, 0, 0);
    end;
  end;}
  if (Msg.LParam = WM_LBUTTONDOWN) or (Msg.LParam = WM_RBUTTONDOWN) then
  begin
    SetForegroundWindow(Handle);
    GetCursorPos(p);
    PopUpMenu1.Popup(p.x, p.y);
    //frmAlarm.Show;
    PostMessage(Handle, WM_NULL, 0, 0);
  end;
end;

procedure TfrmAlarm.WMSysCommand(var msg: TWMSysCommand);
begin
  if msg.CmdType = SC_MINIMIZE then
    procGoToTray
  else
    DefaultHandler(msg);
end;

procedure TfrmAlarm.btnOpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtFileName.Text := OpenDialog1.FileName;
end;

procedure TfrmAlarm.chbActiveClick(Sender: TObject);
begin
  tmrAlarm.Enabled := chbActive.Checked;
  if chbActive.Checked then
    Application.Title := 'Alarm at ' + TimeToStr(AlarmTime)
  else
    Application.Title := 'Alarm - ' + FdateToStr(Fnow);// 'Alarm';
end;

procedure TfrmAlarm.tmrAlarmTimer(Sender: TObject);
begin
  Caption := TimeToStr(Time);
  DecodeTime(Time, H, M, S, mS);
//  ShowMessage(IntToStr(H) + ':' + IntToStr(M));
  DecodeTime(AlarmTime, H1, M1, S1, mS);
//  H1 := StrToInt(copy(mskTime.Text, 0, 2));
//  M1 := StrToInt(copy(mskTime.Text, 4, 2));
//  S1 := StrToInt(copy(mskTime.Text, 7, 2));
//  ShowMessage(IntToStr(H1) + ':' + IntToStr(M1) + ':' + IntToStr(S1));

  if (chbMatchSeconds.Checked) then
  begin
    if (H = H1) and (M = M1) and (S = S1) then
      AlarmNow := True;
  end
  else
  begin
    if (H = H1) and ((M = M1) or (M = M1 + 1)) then
      AlarmNow := True;
  end;

  if AlarmNow then
  begin
    case rgpAction.ItemIndex of
      0: Alarm;
      1: //ExitWindowsEx(EWX_LOGOFF, 0);
         WinExec('shutdown /l /t 0', SW_HIDE);
      2: //ExitWindowsEx(EWX_REBOOT, 0);
         WinExec('shutdown /r /t 0', SW_HIDE);
      3: //ExitWindowsEx(EWX_SHUTDOWN, 0);
         WinExec('shutdown /s /t 0', SW_HIDE);
    end;
  end;
end;

procedure TfrmAlarm.Alarm;
begin
  if svPanel.Visible then
    ShowVars;
  Caption := 'Alarm - ' + FdateToStr(Fnow);
  AlarmNow := False;
  tmrAlarm.Enabled := False;
  chbActive.Checked := False;
  if not (edtFileName.Text = '') then
  // WinExec(PChar('wmplayer' + edtFileName.Text), SW_NORMAL)
  begin
    if FileExists(edtFileName.Text) then
    begin
      try
        mplAlarm.Close;
        mplAlarm.FileName := edtFileName.Text;
        mplAlarm.Open;
        mplAlarm.Play;
        mplAlarm.Notify := True;
        tbnStop.Enabled := True;
      except
        ;
      end;
    end
    else
      ShowMessage(edtAlertMessage.Text + #13 + 'File not found.');
  end
  else
    MessageBeep(60);

  if not (edtAlertMessage.Text = '') then
    ShowMessage(edtAlertMessage.Text)
  else
    ShowMessage('A L A R M ! ! !');
end;

procedure TfrmAlarm.mskTimeChange(Sender: TObject);
begin
  tmrAlarm.Enabled := False;
  chbActive.Checked := False;
  AlarmTime := StrToTime(mskTime.Text);
end;

procedure TfrmAlarm.mskTimeExit(Sender: TObject);
begin
  tmrAlarm.Enabled := chbActive.Checked;
end;

procedure TfrmAlarm.mplAlarmNotify(Sender: TObject);
begin
  try
    if (mplAlarm.Position >= mplAlarm.Length) and (chbRepeat.Checked) then
    begin
      mplAlarm.Rewind;
      mplAlarm.Play;
    end;
  except
    ;
  end;
end;

procedure TfrmAlarm.chbMatchSecondsClick(Sender: TObject);
begin
  if chbMatchSeconds.Checked then
    tmrAlarm.Interval := 500
  else
    tmrAlarm.Interval := 30000;
end;

procedure TfrmAlarm.FormCreate(Sender: TObject);
begin
  CurrDir := GetCurrentDir;
  SysOp := TIniFile.Create(CurrDir + '\i.ini');
  //if SysOp.ValueExists(INI_SECTION, 'Time') then
  mskTime.Text := SysOp.ReadString(INI_SECTION, 'Time', '05:00:00');
  AlarmTime := StrToTime(mskTime.Text);
  mskSnooze.Text := SysOp.ReadString(INI_SECTION, 'Snooze', '00:05:00');
  edtFileName.Text := SysOp.ReadString(INI_SECTION, 'FileName', GetCurrentDir + '\Alarm.mp3');
  edtAlertMessage.Text := SysOp.ReadString(INI_SECTION, 'AlertMessage', 'A L A R M ! ! !');
  chbRepeat.Checked := SysOp.ReadBool(INI_SECTION, 'Repeat', False);
  chbMatchSeconds.Checked := SysOp.ReadBool(INI_SECTION, 'MatchSeconds', True);
  svPanel.Visible := SysOp.ReadBool(INI_SECTION, 'svPanel', False);
  GoToTray := SysOp.ReadBool(INI_SECTION, 'GoToTray', False);

  AlarmNow := False;
  svPanel.Visible := not svPanel.Visible;
  ShowsvPanel;
  if GoToTray then
  begin
    Application.ShowMainForm := False;
    procGoToTray;
  end;

  Caption := 'Alarm - ' + FdateToStr(Fnow);
  Application.Title := Caption;
end;

procedure TfrmAlarm.Show1Click(Sender: TObject);
begin
  GoToTray := False;
  frmAlarm.Show;
//  ApplicationEvents1.
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TfrmAlarm.procGoToTray;
begin
  GoToTray := True;
  InitialTrayIcon;
  Hide;
end;

procedure TfrmAlarm.ShowVars;
begin
  svTime.Caption := TimeToStr(Time);
  if AlarmNow then
  begin
    svAlarmNow.Enabled := True;
    svAlarmNow.Color := clRed;
    frmAlarm.Refresh;
  end
  else
  begin
    svAlarmNow.Color := clBtnFace;
    svAlarmNow.Enabled := False;
  end;
  svH.Caption := IntToStr(H);
  svH1.Caption := IntToStr(H1);
  svM.Caption := IntToStr(M);
  svM1.Caption := IntToStr(M1);
  svS.Caption := IntToStr(S);
  svS1.Caption := IntToStr(S1);
  svtmrAlarmInterval.Caption := IntToStr(tmrAlarm.Interval);
end;

procedure TfrmAlarm.tmrShowVarsTimer(Sender: TObject);
begin
  ShowVars;
end;

procedure TfrmAlarm.spbShowsvPanelClick(Sender: TObject);
begin
  ShowsvPanel;
end;

procedure TfrmAlarm.ShowsvPanel;
begin
  svPanel.Visible := not svPanel.Visible;
  tmrShowVars.Enabled := svPanel.Visible;
  if svPanel.Visible then
  begin
    spbShowsvPanel.Caption := '<<';
    frmAlarm.Width := formWidth;// + svPanel.Width;
  end
  else
  begin
    spbShowsvPanel.Caption := '>>';
    frmAlarm.Width := formWidth - svPanel.Width;
  end;
end;

procedure TfrmAlarm.RegisterInIni(Section, Ident: String; Value: Variant);
var
  ValueType: TVarType;
begin
  ValueType := VarType(Value);
  case ValueType of
    varInteger: RegIniInteger(Section, Ident, Value);
    varBoolean: RegIniBoolean(Section, Ident, Value);
    varString: RegIniString(Section, Ident, Value);
  end;
end;

procedure TfrmAlarm.RegIniInteger(Section, Ident: String; Value: Integer);
begin
  SysOp.DeleteKey(Section, Ident);
  SysOp.WriteInteger(Section, Ident, Value);
end;

procedure TfrmAlarm.RegIniBoolean(Section, Ident: String; Value: Boolean);
begin
  SysOp.DeleteKey(Section, Ident);
  SysOp.WriteBool(Section, Ident, Value);
end;

procedure TfrmAlarm.RegIniString(Section, Ident: String; Value: String);
begin
  SysOp.DeleteKey(Section, Ident);
  SysOp.WriteString(Section, Ident, Value);
end;

procedure TfrmAlarm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RegisterInIni(INI_SECTION, 'Time', mskTime.Text);
  RegisterInIni(INI_SECTION, 'Snooze', mskSnooze.Text);
  RegisterInIni(INI_SECTION, 'FileName', edtFileName.Text);
  RegisterInIni(INI_SECTION, 'AlertMessage', edtAlertMessage.Text);
  RegisterInIni(INI_SECTION, 'Repeat', chbRepeat.Checked);
  RegisterInIni(INI_SECTION, 'MatchSeconds', chbMatchSeconds.Checked);
  RegisterInIni(INI_SECTION, 'svPanel', svPanel.Visible);
  RegisterInIni(INI_SECTION, 'GoToTray', GoToTray);
end;

procedure TfrmAlarm.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TfrmAlarm.Quit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlarm.actSnoozeExecute(Sender: TObject);
begin
  try
    mplAlarm.Close;
  except
    ;
  end;
  AlarmTime := Time + StrToTime(mskSnooze.Text);
  chbActive.Checked := True;
  tmrAlarm.Enabled := True;
end;

function TfrmAlarm.Sto_GetFmtFileVersion(const FileName: String = '';
  const Fmt: String = '%d.%d.%d.%d'): String;
var
  sFileName: String;
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array[1..4] of Word;
begin
  // set default value
  Result := '';
  // get filename of exe/dll if no filename is specified
  sFileName := FileName;
  if (sFileName = '') then
  begin
    // prepare buffer for path and terminating #0
    SetLength(sFileName, MAX_PATH + 1);
    SetLength(sFileName,
      GetModuleFileName(hInstance, PChar(sFileName), MAX_PATH + 1));
  end;
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(sFileName), iDummy);
  if (iBufferSize > 0) then
  begin
    GetMem(pBuffer, iBufferSize);
    try
      // get fixed file info (language independent)
      GetFileVersionInfo(PChar(sFileName), 0, iBufferSize, pBuffer);
      VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
      // read version blocks
      iVer[1] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[2] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[3] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
      iVer[4] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      FreeMem(pBuffer);
    end;
    // format result string
    Result := Format(Fmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
  end;
end;

procedure TfrmAlarm.actAboutExecute(Sender: TObject);
const
  spaces = '       ';
begin
  ShowMessage(spaces + 'Done by:'#13 +
    spaces + 'Sayyed Mostafa Rahmani'#13 +
    spaces + 's.mostafa.rahmani@gmail.com   ' + #13 +
    spaces + 'http://hemmat.freehostia.com/' + #13#13 +
    spaces + 'Version: ' + Sto_GetFmtFileVersion() + #13 +
    spaces + '86/03/10' + #13#13 +
    spaces + 'Last Modified: 87/04/11');
end;

procedure TfrmAlarm.actGoToTrayExecute(Sender: TObject);
begin
  procGoToTray;
end;

procedure TfrmAlarm.actStopSoundExecute(Sender: TObject);
begin
  try
    mplAlarm.Stop;
    mplAlarm.Close;
  except
    ;
  end;
  tbnStop.Enabled := False;
end;

procedure TfrmAlarm.actCalendarExecute(Sender: TObject);
begin
  DateForm.Show;
end;

initialization

finalization
  SysOp.UpdateFile;

end.
