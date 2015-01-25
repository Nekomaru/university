object Form1: TForm1
  Left = 643
  Top = 338
  Width = 719
  Height = 555
  Caption = #1052#1086#1076#1077#1083#1080#1088#1086#1074#1072#1085#1080#1077' '#1072#1083#1075#1086#1088#1080#1090#1084#1086#1074' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072#1084#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 145
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1086#1094#1077#1089#1089
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 455
    Top = 0
    Width = 248
    Height = 407
    Align = alRight
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 407
    Width = 703
    Height = 110
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 72
    Width = 449
    Height = 329
    Enabled = False
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 87
      Height = 13
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1075#1086#1090#1086#1074#1099#1093
    end
    object Label4: TLabel
      Left = 136
      Top = 88
      Width = 106
      Height = 13
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1086#1078#1080#1076#1072#1102#1097#1080#1093
    end
    object MemoryAwaitingProcesses: TLabel
      Left = 272
      Top = 88
      Width = 156
      Height = 13
      Caption = #1055#1088#1086#1094#1077#1089#1089#1099' '#1086#1078#1080#1076#1072#1102#1097#1080#1077' '#1087#1072#1084#1103#1090#1100
    end
    object ListBox1: TListBox
      Left = 8
      Top = 104
      Width = 121
      Height = 217
      ItemHeight = 13
      TabOrder = 0
    end
    object ListBox2: TListBox
      Left = 136
      Top = 104
      Width = 129
      Height = 217
      ItemHeight = 13
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 257
      Height = 65
      Caption = #1055#1088#1086#1094#1077#1089#1089#1086#1088
      TabOrder = 2
      object Label5: TLabel
        Left = 8
        Top = 16
        Width = 66
        Height = 13
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' = '
      end
      object Label6: TLabel
        Left = 8
        Top = 32
        Width = 50
        Height = 13
        Caption = #1055#1086#1094#1077#1089#1089' = '
      end
      object Label7: TLabel
        Left = 8
        Top = 48
        Width = 71
        Height = 13
        Caption = #1042#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '
      end
    end
    object MemoryInfoGroupBox: TGroupBox
      Left = 272
      Top = 8
      Width = 169
      Height = 65
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1072#1084#1103#1090#1080
      TabOrder = 3
      object FreePartitionCountLabel: TLabel
        Left = 8
        Top = 32
        Width = 116
        Height = 13
        Caption = #1057#1086#1074#1086#1073#1086#1076#1085#1099#1093' '#1088#1072#1079#1076#1077#1083#1086#1074':'
      end
      object EngagedPartitionsCountLabel: TLabel
        Left = 8
        Top = 48
        Width = 97
        Height = 13
        Caption = #1047#1072#1085#1103#1090#1099#1093' '#1088#1072#1079#1076#1077#1083#1086#1074':'
      end
      object PartitionCountLabel: TLabel
        Left = 8
        Top = 16
        Width = 84
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1088#1072#1079#1076#1077#1083#1086#1074':'
      end
    end
    object EngagedProcessesListBox: TListBox
      Left = 272
      Top = 104
      Width = 169
      Height = 217
      ItemHeight = 13
      TabOrder = 4
    end
  end
  object Panel1: TPanel
    Left = 304
    Top = 16
    Width = 145
    Height = 41
    TabOrder = 4
    object Label1: TLabel
      Left = 56
      Top = 16
      Width = 30
      Height = 13
      Caption = #1050#1074#1072#1085#1090
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 8
      Width = 23
      Height = 22
      Caption = '-1'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 112
      Top = 8
      Width = 23
      Height = 22
      Caption = '+1'
      OnClick = SpeedButton2Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text|*.txt|All files|*.*'
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 8
    Top = 80
  end
end
