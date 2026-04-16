object fmViewer: TfmViewer
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'AI File Analyzer v1.0 - Content Viewer'
  ClientHeight = 461
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object memoContent: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 778
    Height = 455
    Align = alClient
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
