object MainForm: TMainForm
  Left = 695
  Top = 67
  Width = 289
  Height = 159
  Caption = 'Array 23'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ArrayLabel: TLabel
    Left = 8
    Top = 16
    Width = 42
    Height = 13
    Caption = #1052#1072#1089#1089#1080#1074':'
  end
  object KLabel: TLabel
    Left = 8
    Top = 40
    Width = 10
    Height = 13
    Caption = 'K:'
  end
  object LLabel: TLabel
    Left = 80
    Top = 40
    Width = 9
    Height = 13
    Caption = 'L:'
  end
  object AverageLabel: TLabel
    Left = 8
    Top = 64
    Width = 3
    Height = 13
  end
  object ArrayEdit: TEdit
    Left = 56
    Top = 12
    Width = 209
    Height = 21
    TabOrder = 0
  end
  object RunButton: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082
    TabOrder = 1
    OnClick = RunButtonClick
  end
  object KEdit: TEdit
    Left = 24
    Top = 36
    Width = 49
    Height = 21
    TabOrder = 2
  end
  object LEdit: TEdit
    Left = 96
    Top = 36
    Width = 49
    Height = 21
    TabOrder = 3
  end
end
