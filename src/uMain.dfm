object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'AI FileAnalyzer v1.0'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  StyleName = 'Aqua Graphite'
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object btnRun: TBitBtn
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnRun'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 48
    Width = 608
    Height = 385
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
