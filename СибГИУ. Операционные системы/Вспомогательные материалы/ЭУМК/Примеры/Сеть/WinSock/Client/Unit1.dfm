object Form1: TForm1
  Left = 192
  Top = 122
  Width = 538
  Height = 193
  Caption = #1050#1083#1080#1077#1085#1090#1089#1082#1086#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 137
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '#1089' '#1089#1077#1088#1074#1077#1088#1086#1084
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 46
      Height = 13
      Caption = 'IP-'#1072#1076#1088#1077#1089':'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 28
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object Button1: TButton
      Left = 64
      Top = 72
      Width = 89
      Height = 25
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 64
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '127.0.0.1'
    end
    object Edit2: TEdit
      Left = 64
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '1025'
    end
  end
  object GroupBox2: TGroupBox
    Left = 264
    Top = 8
    Width = 249
    Height = 137
    Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1089#1077#1088#1074#1077#1088#1086#1084
    Enabled = False
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 35
      Height = 13
      Caption = #1063#1080#1089#1083#1086':'
    end
    object Label4: TLabel
      Left = 8
      Top = 88
      Width = 33
      Height = 13
      Caption = #1054#1090#1074#1077#1090':'
    end
    object Label5: TLabel
      Left = 40
      Top = 88
      Width = 11
      Height = 13
    end
    object Edit3: TEdit
      Left = 48
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button2: TButton
      Left = 56
      Top = 48
      Width = 75
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
