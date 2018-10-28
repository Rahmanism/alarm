unit Convert_Dates;
{Convet Dates BY Mojtaba Noorafshan 79/05/25}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Grids, ExtCtrls;

Const
// CountDays Miladi - CountDays Shamsi
   S_M = 226955;
// Extra Time on Year (365 / 5:48:46)
   STimeYear = 20926;

// Tables Months

   Smonth : array [Boolean] of TDayTable =
     ((31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29),
      (31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30));

   miladi : array [1..12] of word = (0,31,59,90,120,151,181,212,243,273,304,334);
   Ghamar : array [1..12] of word = (1,30,59,89,118,148,177,207,236,266,295,325);

   miladi_Month : array[1..12] of String[20] =('Januray','February','March',
  'April','May','June','July','August','September','October','November','December');

   Ghamari_Month : array [1..12] of String[20] = ('ãÍÑã',
                                                   'ÕÝÑ',
                                                   'ÑÈíÚ ÇáÇæá',
                                                   'ÑÈíÚ ÇáËÇäí',
                                                   'ÌãÇÏí ÇáÇæá',
                                                   'ÌãÇÏí ÇáËÇäí',
                                                   'ÑÌÈ',
                                                   'ÔÚÈÇä',
                                                   'ÑãÖÇä',
                                                   'ÔæÇá',
                                                   'Ðí ÇáÞÚÏå',
                                                   'Ðí ÇáÍÌå');
   WeekDay_Table : array [0..6] of String[15] =  ('ÔäÈå',
                                                  'í˜ÔäÈå',
                                                  'ÏæÔäÈå',
                                                  'Óå ÔäÈå',
                                                  'åÇÑÔäÈå',
                                                  'äÌÔäÈå',
                                                  'ÌãÚå');
type
  Fdate = record
     Year  : LongWord;
     Month : 1..12;
     Day   : 1..31;
  end;
  NumDateTime = record
     Date  : LongWord;
     Time : currency;
  end;
  TDateForm = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    DateGrid: TStringGrid;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure DateGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DateGridDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Public
      Procedure UpData_Date(ADate : Fdate);
      procedure cls;
      procedure UpDate_GH_Mi(ADate : Fdate);

  end;
  Function GetNextM(MyDate : string): String;
  Function  Kabiseh(sYear : Word) : Boolean;
  Function  Shamsi2Num(Date_S : Fdate) : LongWord;
  Function  Num2Shamsi(NumberDate : LongWord) : Fdate;
// Convert Date Shamsi To Miladi
  Function  Shamsi2Miladi(Sdate : Fdate) : Tdate;
// Convert Date Miladi To Shamsi
  Function  Miladi2Shamsi(Mdate : Tdate) : Fdate;
// Convert Date Miladi To Ghamari
  Function  Miladi2Ghamari(Mdate : Tdate) : Fdate;
// Convert Date Shamsi To Ghamari
  Function  Shamsi2Ghamari(Sdate : Fdate) : Fdate;
  Function  DayWeek(Sdate : Fdate) : Integer;
  Function  ToFdate(Year_s : LongWord; Month_s,Day_s : byte) : Fdate;
  Function  FdateToStr(Date_S : Fdate) : String;
  Function  StrToFdate(Date_S_G : String) : Fdate;
  Function  FixStrDate (Date_SGM : String) : String;
  Function  Fnow : Fdate;
   procedure MirrorControl(Control : TWinControl);
var
  DateForm   : TDateForm;
  ActiveDate : Fdate;
  BakDate    : Fdate;

implementation



{$R *.DFM}

function Kabiseh(sYear: Word): Boolean;
Const
 KhayyamTable : array [1..30] of Byte = (5, 9, 13, 17, 21, 25, 29, 34, 38, 42,
                                         46, 50, 54, 58, 62, 67, 71, 75, 79, 83,
                                         87, 91, 95, 100, 104, 108, 112, 116,
                                         120, 124);
var
  dd : integer;

     Function In_Khayyam_Table(sd : integer) : Boolean;
       var tt : Word;
     Begin
        tt := 0;
        Repeat
            inc(tt);
            Result := (sd = KhayyamTable[tt]);
        until (tt = 30) or (Result = True);
     End;

begin
   if sYear >= 470 Then
   begin
     dd := (sYear - 470) mod 161;
     Result := dd in [0,5,9,13,17,21,25,29,34,38,42,46,50,54,58,62,67,71,
                      75,79,83,87,91,95,100,104,108,112,116,120,124,128,
                      133,137,141,145,149,153,157];
   End
   else if sYear >= 342 then
   begin
     dd := sYear - 342;
     Result := (In_Khayyam_Table(dd));
   end
   else
   begin
     dd := (128 - (374 - sYear)) mod 128;
     Result := (In_Khayyam_Table(dd));
   end;
end;

function Shamsi2Num(Date_S : Fdate): LongWord;
var
 ii : LongWord;
begin
 begin
     Result := 0;
     for ii := 1 to Date_S.Year - 1 do
       if Kabiseh(ii) Then Result := Result + 366
       else Result := Result + 365;
     ii := 1;
     While ii < Date_S.Month do
     begin
       Result := Result + Smonth[Kabiseh(Date_S.Year),ii];
       inc(ii);
     end;
     inc(Result,Date_S.Day);
 end;
end;

function ToFdate(Year_s: LongWord; Month_s, Day_s: byte): Fdate;
begin
   Result.Year :=  Year_s;
   Result.Month := Month_s;
   Result.Day := Day_s;
end;

function Num2Shamsi(NumberDate : LongWord): Fdate;
Var
 NUM,SAL : longWORD;
 MK : BYTE;
begin
 SAL := 1;
 num := NumberDate;
 mk := 0;
 while num > (365 + mk) do
 begin
   Num := Num - (365 + mk);
   inc(sal);
   if Kabiseh(sal) Then Mk := 1
   else mk := 0;
 end;

 mk := 1;
 while num > (Smonth[Kabiseh(Sal),mk]) do
 begin
  num := num - (Smonth[Kabiseh(Sal),mk]);
  inc(mk);
 end;
 Result.Year := Sal;
 Result.Month := mk;
 Result.Day := num;

end;

function FdateToStr(Date_S: Fdate): String;
var
s1,s2,s3 : string[10];
begin
 s1 := IntToStr(Date_S.Year);
 s2 := IntToStr(Date_S.Month);
 s3 := IntToStr(Date_S.Day);
 while length(s1) < 4 do s1 := '0' + s1;
 if length(s2) <> 2 then s2 := '0' + s2;
 if length(s3) <> 2 then s3 := '0' + s3;
 Result := s1 + '/' + s2 + '/' + s3;
end;

Function  StrToFdate(Date_S_G : String) : Fdate;
var
SS,s1,s2,s3 : string[10];
D,index : WORD;
begin
 S1 := '';
 S2 := '';
 S3 := '';
 index := 1;
 ss := Date_S_G;
 for d := 1 to length(ss) do
 begin
   if ss[d] = '/' then inc(index)
   else
    case index of
      1 : s1 := s1 + ss[d];
      2 : s2 := s2 + ss[d];
      3 : s3 := s3 + ss[d];
    end;{case}
 end;{for}
 Result.Year := StrToInt(s1);
 Result.Month := StrToInt(s2);
 Result.Day := StrToInt(s3);
end;

Function  FixStrDate (Date_SGM : String) : String;
begin
 Result := FdateToStr(StrToFdate(Date_SGM));
end;

function Shamsi2Miladi(Sdate: Fdate): Tdate;
var dd : Integer;
    mm : TTimeStamp;
begin
 dd := Shamsi2Num(Sdate);
 dd := dd + S_M;
 MM.Date := DD;
 MM.Time := 1;
 Result := TimeStampToDateTime(MM);
end;

function Miladi2Shamsi(Mdate: Tdate): Fdate;
var dd : LongWord;
begin
 dd := DateTimeToTimeStamp(Mdate).Date;
 dd := dd - S_M;
 Result := Num2Shamsi(dd);
end;

function DayWeek(Sdate: Fdate): Integer;
const
WW : array [0..6] of byte = (2,3,4,5,6,0,1);
var
 dd : byte;
begin
 dd := (Shamsi2Num(Sdate) mod 7);
 Result := WW[dd];
end;

Function  Miladi2Ghamari(Mdate : Tdate) : Fdate;
var
 yy,mm,dd : Word;
 X ,y: currency;
 Rm : Integer;
 alfa,i : Byte;
begin
 DecodeDate(Mdate,yy,mm,dd);
 X := (((yy - 1600) * 1.030690) + 1008.4547);
 Result.Year := Trunc(X);
 y := (Frac(X) * 354);
 Rm := miladi[mm] + dd + Trunc(y);
 if (IsLeapYear(yy)  and (mm > 2)) Then Inc(rm);
 IF rm > 354 then
 begin
 rm := rm - 353;
 inc(Result.Year);
 end;
 alfa := 0;
 for i := 1 to 12 do
     if rm > Ghamar[i] then alfa := i;
 Result.Day := rm - Ghamar[alfa];
 Result.Month := alfa;
end;

Function  Shamsi2Ghamari(Sdate : Fdate) : Fdate;
begin
 Result := Miladi2Ghamari((Shamsi2Miladi(Sdate)));
end;

function Fnow : Fdate;
begin
 Result := Miladi2Shamsi(Now);
end;

procedure TDateForm.DateGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 CanSelect := DateGrid.Cells[ACol,ARow] <> '';
 if CanSelect then
 begin
   ActiveDate.Day :=StrToInt(DateGrid.Cells[ACol,ARow]);
   UpDate_GH_Mi(ActiveDate);
 end;
end;
procedure TDateForm.FormCreate(Sender: TObject);
begin
 Edit1.Ctl3D := False;
 ActiveDate := Fnow;
 UpData_Date(ActiveDate);
end;

procedure TDateForm.cls;
var
 xx,yy : word;
begin
 for xx := 0 to 5 do
   for yy := 0 to 6 do DateForm.DateGrid.cells[xx,yy] := '';
end;

procedure TDateForm.UpData_Date(ADate: Fdate);
var
x,y,i : Word;
DG : Fdate;
r,c : integer;
begin
  c := 0;
  r := 0;
  cls;
  UpDate_GH_Mi(ADate);
  ComboBox1.ItemIndex := ADate.Month-1;
  UpDown1.Position := ADate.Year;
  DG := ADate;
  DG.Day := 1;
  x := 0;
  y := DayWeek(DG);
  For i := 1 to Smonth[Kabiseh(ADate.Year),ADate.Month] do
  Begin
  DateGrid.cells[x,y] := inttostr(i);

  if i = ADate.Day then
  begin
   c := x;
   r := y;
  end;
  if  y = 6 then
  begin
    y := 0;
    inc(x);
  end else inc(y);
  End;
  DateGrid.Col := c;
  DateGrid.Row := r;
  DateGrid.Col := c;
end;

procedure TDateForm.ComboBox1Change(Sender: TObject);
var
aa : Word;
begin
 aa := ComboBox1.ItemIndex+1;
 if ActiveDate.Day > Smonth[Kabiseh(ActiveDate.Year),aa] then
 ActiveDate.Day := Smonth[Kabiseh(ActiveDate.Year),aa];
 ActiveDate.Month := aa;
 UpData_Date(ActiveDate);
end;

procedure TDateForm.BitBtn1Click(Sender: TObject);
begin
cls;
end;

procedure TDateForm.UpDate_GH_Mi(ADate: Fdate);
var
yy,mm,dd : Word;
DM : Tdate;
DG : Fdate;
begin
  Edit2.Text := FdateToStr(ADate);
//********* Miladi **********************
  DM := Shamsi2Miladi(ADate);
  Label1.Hint := DateToStr(Dm);
  DecodeDate(DM,yy,mm,dd);
  Label1.Caption :=IntToStr(dd)+'/ '+miladi_Month[mm]+' /'+IntToStr(yy);
//********* Ghamari *********************
  DG := Miladi2Ghamari(DM);
  Label2.Hint := FdateToStr(DG);
  Label2.Caption := IntToStr(DG.Day)+'/ '+ Ghamari_Month[dg.Month] +' /'+
                    IntToStr(DG.Year);
end;

procedure TDateForm.Edit1Change(Sender: TObject);
var
aa : word;
begin
 ActiveDate.Year := UpDown1.Position;
 aa := ActiveDate.Month;
 if ActiveDate.Day > Smonth[Kabiseh(ActiveDate.Year),aa] then
 ActiveDate.Day := Smonth[Kabiseh(ActiveDate.Year),aa];
 UpData_Date(ActiveDate);
end;

procedure TDateForm.SpeedButton1Click(Sender: TObject);
begin
  ActiveDate := Fnow;
  UpData_Date(ActiveDate);
end;

procedure TDateForm.DateGridDblClick(Sender: TObject);
begin
 close;
end;

procedure TDateForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = Vk_Escape Then Close;
end;

procedure TDateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //  DateForm.Free;
  // DateForm.Destroy
end;
procedure MirrorControl(Control : TWinControl);
var
  ExStyle : integer;
begin
  ExStyle := GetWindowLong(Control.Handle,GWL_EXSTYLE	);
  SetWindowLong(Control.Handle,GWL_EXSTYLE ,ExStyle + WS_EX_LAYOUTRTL);
  Control.Invalidate;
end;

Function GetNextM(MyDate :String): String;
var
   NextDate : String;
   yy,mm,mm1,dd:integer;

   Begin
    yy:=Shamsi2Num(StrToFdate(mydate));
    yy:=yy+30;
    NextDate:=FdateToStr(Num2Shamsi(yy));
   Result := NextDate;
end;


end.
