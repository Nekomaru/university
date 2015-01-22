object Form1: TForm1
  Left = 749
  Top = 282
  Width = 696
  Height = 586
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
    Left = 280
    Top = 0
    Width = 400
    Height = 438
    Align = alRight
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 438
    Width = 680
    Height = 110
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 80
    Width = 273
    Height = 353
    Enabled = False
    TabOrder = 3
    object Label3: TLabel
      Left = 24
      Top = 128
      Width = 87
      Height = 13
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1075#1086#1090#1086#1074#1099#1093
    end
    object Label4: TLabel
      Left = 152
      Top = 128
      Width = 106
      Height = 13
      Caption = #1054#1095#1077#1088#1077#1076#1100' '#1086#1078#1080#1076#1072#1102#1097#1080#1093
    end
    object Panel1: TPanel
      Left = 8
      Top = 8
      Width = 113
      Height = 41
      TabOrder = 0
      object Label1: TLabel
        Left = 40
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
        Left = 80
        Top = 8
        Width = 23
        Height = 22
        Caption = '+1'
        OnClick = SpeedButton2Click
      end
    end
    object Panel2: TPanel
      Left = 136
      Top = 8
      Width = 121
      Height = 41
      TabOrder = 1
      object Label2: TLabel
        Left = 32
        Top = 16
        Width = 54
        Height = 13
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
      end
      object SpeedButton3: TSpeedButton
        Left = 8
        Top = 8
        Width = 23
        Height = 22
        Caption = '-1'
        OnClick = SpeedButton3Click
      end
      object SpeedButton4: TSpeedButton
        Left = 88
        Top = 8
        Width = 23
        Height = 22
        Caption = '+1'
        OnClick = SpeedButton4Click
      end
    end
    object ListBox1: TListBox
      Left = 8
      Top = 144
      Width = 121
      Height = 201
      ItemHeight = 13
      TabOrder = 2
    end
    object ListBox2: TListBox
      Left = 144
      Top = 144
      Width = 121
      Height = 201
      ItemHeight = 13
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 56
      Width = 241
      Height = 73
      Caption = #1055#1088#1086#1094#1077#1089#1089#1086#1088
      TabOrder = 4
      object Label5: TLabel
        Left = 16
        Top = 16
        Width = 66
        Height = 13
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' = '
      end
      object Label6: TLabel
        Left = 16
        Top = 40
        Width = 50
        Height = 13
        Caption = #1055#1086#1094#1077#1089#1089' = '
      end
      object Label7: TLabel
        Left = 16
        Top = 56
        Width = 71
        Height = 13
        Caption = #1042#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text|*.txt|All files|*.*'
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 16
    Top = 144
  end
  object Timer2: TTimer
    Enabled = False
    Left = 144
    Top = 224
  end
end
