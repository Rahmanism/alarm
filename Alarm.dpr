program Alarm;

uses
  Forms,
  untMainAlarm in 'untMainAlarm.pas' {frmAlarm},
  Convert_Dates in 'Convert_Dates.pas' {DateForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAlarm, frmAlarm);
  Application.CreateForm(TDateForm, DateForm);
  Application.Run;
end.
