object Form1: TForm1
  Left = 812
  Top = 325
  Width = 803
  Height = 556
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
  object NewProcessPriorityLabel: TLabel
    Left = 160
    Top = 20
    Width = 146
    Height = 13
    Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1085#1086#1074#1086#1075#1086' '#1087#1088#1086#1094#1077#1089#1089#1072':'
  end
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 145
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1086#1094#1077#1089#1089
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 472
    Top = 0
    Width = 315
    Height = 408
    Align = alRight
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 408
    Width = 787
    Height = 110
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 48
    Width = 465
    Height = 353
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
    object AwaitingForMemoryLabel: TLabel
      Left = 272
      Top = 88
      Width = 146
      Height = 13
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1086#1078#1080#1076#1072#1102#1097#1080#1093' '#1087#1072#1084#1103#1090#1100
    end
    object ListBox1: TListBox
      Left = 8
      Top = 104
      Width = 121
      Height = 241
      ItemHeight = 13
      TabOrder = 0
    end
    object ListBox2: TListBox
      Left = 136
      Top = 104
      Width = 129
      Height = 241
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
    object MemoryInfo: TGroupBox
      Left = 272
      Top = 8
      Width = 185
      Height = 65
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1072#1084#1103#1090#1080
      TabOrder = 3
      object MemoryTotalLabel: TLabel
        Left = 8
        Top = 16
        Width = 73
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1087#1072#1084#1103#1090#1080':'
      end
      object FreeMemoryLabel: TLabel
        Left = 8
        Top = 32
        Width = 92
        Height = 13
        Caption = #1057#1074#1086#1073#1086#1076#1085#1086' '#1087#1072#1084#1103#1090#1080':'
      end
      object PartitionCountLabel: TLabel
        Left = 8
        Top = 48
        Width = 97
        Height = 13
        Caption = #1056#1072#1079#1076#1077#1083#1086#1074' '#1089#1086#1079#1076#1072#1085#1086':'
      end
    end
    object AwaitingForMemoryListBox: TListBox
      Left = 272
      Top = 104
      Width = 185
      Height = 241
      ItemHeight = 13
      TabOrder = 4
    end
  end
  object NewProcessPriorityComboBox: TComboBox
    Left = 312
    Top = 18
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text|*.txt|All files|*.*'
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 8
    Top = 72
  end
  object Timer2: TTimer
    Enabled = False
    Left = 144
    Top = 224
  end
end
