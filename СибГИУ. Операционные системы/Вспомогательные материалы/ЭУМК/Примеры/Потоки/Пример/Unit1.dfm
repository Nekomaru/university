object Form1: TForm1
  Left = 192
  Top = 114
  Width = 467
  Height = 404
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Begin'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 168
    Top = 16
    Width = 185
    Height = 185
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 24
    Top = 64
    Width = 75
    Height = 25
    Caption = 'End Event'
    TabOrder = 2
    OnClick = Button2Click
  end
end
