object frmAlarm: TfrmAlarm
  Left = 199
  Top = 112
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Alarm'
  ClientHeight = 243
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object spbShowsvPanel: TSpeedButton
    Left = 373
    Top = 33
    Width = 22
    Height = 22
    Caption = '>>'
    Flat = True
    OnClick = spbShowsvPanelClick
  end
  object PageScroller1: TPageScroller
    Left = 399
    Top = 25
    Width = 99
    Height = 218
    Align = alRight
    Control = svPanel
    TabOrder = 0
    ExplicitTop = 27
    ExplicitHeight = 216
    object svPanel: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 218
      TabOrder = 0
      Visible = False
      object Label2: TLabel
        Left = 14
        Top = 49
        Width = 11
        Height = 13
        Caption = 'H:'
      end
      object svH: TLabel
        Left = 25
        Top = 49
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label4: TLabel
        Left = 42
        Top = 49
        Width = 17
        Height = 13
        Caption = 'H1:'
      end
      object svH1: TLabel
        Left = 58
        Top = 49
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label6: TLabel
        Left = 14
        Top = 62
        Width = 13
        Height = 13
        Caption = 'M:'
      end
      object svM: TLabel
        Left = 25
        Top = 62
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label8: TLabel
        Left = 42
        Top = 62
        Width = 19
        Height = 13
        Caption = 'M1:'
      end
      object svM1: TLabel
        Left = 58
        Top = 62
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label10: TLabel
        Left = 14
        Top = 76
        Width = 9
        Height = 13
        Caption = 'S:'
      end
      object svS: TLabel
        Left = 25
        Top = 76
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label12: TLabel
        Left = 42
        Top = 76
        Width = 15
        Height = 13
        Caption = 'S1:'
      end
      object svS1: TLabel
        Left = 58
        Top = 76
        Width = 12
        Height = 13
        Caption = '00'
      end
      object Label3: TLabel
        Left = 14
        Top = 93
        Width = 71
        Height = 13
        Caption = 'Timer Interval:'
      end
      object svtmrAlarmInterval: TLabel
        Left = 16
        Top = 105
        Width = 12
        Height = 13
        Caption = '00'
      end
      object svTime: TLabel
        Left = 15
        Top = 7
        Width = 36
        Height = 11
        Caption = '00:00:00'
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object svAlarmNow: TLabel
        Left = 14
        Top = 28
        Width = 56
        Height = 13
        Caption = 'Alarm Now'
        Enabled = False
      end
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 498
    Height = 25
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 21
        Width = 492
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 485
      Height = 21
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 68
      Caption = 'tbrStandard'
      Customizable = True
      ShowCaptions = True
      TabOrder = 0
      object tbnStop: TToolButton
        Left = 0
        Top = 0
        Action = actStopSound
      end
      object tbnSnooze: TToolButton
        Left = 68
        Top = 0
        Action = actSnooze
      end
      object tbnCalendar: TToolButton
        Left = 136
        Top = 0
        Hint = 'Show Calendar Form'
        Action = actCalendar
      end
      object ToolButton1: TToolButton
        Left = 204
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 0
        Style = tbsSeparator
      end
      object tbnAbout: TToolButton
        Left = 212
        Top = 0
        Action = actAbout
      end
    end
  end
  object gbxOptions: TGroupBox
    Left = 7
    Top = 118
    Width = 223
    Height = 119
    Caption = ' Alarm '
    TabOrder = 2
    object Label1: TLabel
      Left = 7
      Top = 81
      Width = 75
      Height = 13
      Caption = 'Alert Message:'
    end
    object Label7: TLabel
      Left = 8
      Top = 22
      Width = 124
      Height = 13
      Caption = 'Sound to play on Alarm:'
    end
    object edtFileName: TEdit
      Left = 7
      Top = 34
      Width = 209
      Height = 21
      TabOrder = 0
      Text = 'Alarm.mp3'
    end
    object btnOpenFile: TButton
      Left = 159
      Top = 55
      Width = 57
      Height = 22
      Caption = 'Open'
      TabOrder = 1
      OnClick = btnOpenFileClick
    end
    object edtAlertMessage: TEdit
      Left = 7
      Top = 94
      Width = 209
      Height = 19
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'A L A R M ! ! !'
    end
    object btnStopSound: TButton
      Left = 84
      Top = 55
      Width = 74
      Height = 22
      Action = actStopSound
      TabOrder = 3
    end
  end
  object gbxMainSettings: TGroupBox
    Left = 7
    Top = 28
    Width = 223
    Height = 91
    Caption = ' Alarm Main Settings '
    TabOrder = 3
    object lblAlarm: TLabel
      Left = 8
      Top = 19
      Width = 45
      Height = 13
      Caption = 'Alarm at:'
    end
    object Label5: TLabel
      Left = 7
      Top = 52
      Width = 89
      Height = 13
      Caption = 'Snooze duration:'
    end
    object mskTime: TMaskEdit
      Left = 57
      Top = 16
      Width = 48
      Height = 21
      EditMask = '!90:00:00;1;_'
      MaxLength = 8
      TabOrder = 0
      Text = '00:00:00'
      OnChange = mskTimeChange
      OnExit = mskTimeExit
    end
    object chbActive: TCheckBox
      Left = 121
      Top = 45
      Width = 50
      Height = 15
      Caption = 'Active'
      TabOrder = 1
      OnClick = chbActiveClick
    end
    object chbRepeat: TCheckBox
      Left = 121
      Top = 59
      Width = 50
      Height = 15
      Caption = 'Repeat'
      TabOrder = 2
    end
    object chbMatchSeconds: TCheckBox
      Left = 121
      Top = 73
      Width = 98
      Height = 15
      Caption = 'Match Seconds'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chbMatchSecondsClick
    end
    object mskSnooze: TMaskEdit
      Left = 7
      Top = 65
      Width = 50
      Height = 21
      EditMask = '!90:00:00;1;_'
      MaxLength = 8
      TabOrder = 4
      Text = '00:00:00'
      OnChange = mskTimeChange
      OnExit = mskTimeExit
    end
    object mplAlarm: TMediaPlayer
      Left = 146
      Top = 9
      Width = 85
      Height = 26
      VisibleButtons = [btPlay, btPause, btStop]
      Visible = False
      TabOrder = 5
      OnNotify = mplAlarmNotify
    end
  end
  object rgpAction: TRadioGroup
    Left = 234
    Top = 28
    Width = 127
    Height = 91
    Caption = ' Action '
    ItemIndex = 0
    Items.Strings = (
      'Alarm'
      'Log Off'
      'Restart'
      'Shut Down')
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Audio Files|*.mp3; *.wav; *.wma'
    Title = 'Open a file for Alarm'
    Left = 272
    Top = 158
  end
  object tmrAlarm: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrAlarmTimer
    Left = 240
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 272
    Top = 191
    object Show1: TMenuItem
      Caption = 'Show Window'
      OnClick = Show1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N11: TMenuItem
      Action = actStopSound
    end
    object Snooze1: TMenuItem
      Action = actSnooze
    end
    object N1: TMenuItem
      Action = actCalendar
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Action = actAbout
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Quit1: TMenuItem
      Caption = 'Quit'
      OnClick = Quit1Click
    end
  end
  object tmrShowVars: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tmrShowVarsTimer
    Left = 440
    Top = 155
  end
  object ActionList1: TActionList
    Left = 240
    Top = 160
    object actSnooze: TAction
      Caption = 'Snooze!!'
      Hint = 'Snooze!'
      ShortCut = 116
      OnExecute = actSnoozeExecute
    end
    object actStopSound: TAction
      Caption = 'Stop Sound'
      Hint = 'Stop sound'
      ShortCut = 16464
      OnExecute = actStopSoundExecute
    end
    object actAbout: TAction
      Caption = 'About'
      Hint = 'About'
      ShortCut = 112
      OnExecute = actAboutExecute
    end
    object actGoToTray: TAction
      Caption = 'Go To Tray'
      Hint = 'Go to system tray'
      ShortCut = 16468
      OnExecute = actGoToTrayExecute
    end
    object actCalendar: TAction
      Caption = 'Calendar'
      ShortCut = 120
      OnExecute = actCalendarExecute
    end
  end
  object ImageList1: TImageList
    Left = 240
    Top = 192
  end
end
