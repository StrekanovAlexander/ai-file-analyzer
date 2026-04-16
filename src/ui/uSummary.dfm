object fmSummary: TfmSummary
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'AI File Analyzer v1.0 - AI Summary'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object lblFileName: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblFileName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 65
  end
  object lblFolder: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 24
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblFolder'
    ExplicitWidth = 46
  end
  object lblStatus: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 99
    Width = 618
    Height = 15
    Margins.Top = 15
    Align = alTop
    Caption = 'lblStatus'
    ExplicitWidth = 45
  end
  object lblTopic: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 132
    Width = 618
    Height = 15
    Margins.Top = 15
    Align = alTop
    Caption = 'lblTopic'
    ExplicitWidth = 41
  end
  object lblSummary: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 153
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblSummary'
    WordWrap = True
    ExplicitWidth = 64
  end
  object lblKeywords: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 195
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblKeywords'
    WordWrap = True
    ExplicitWidth = 64
  end
  object lblLastModified: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 45
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblLastModified'
    ExplicitWidth = 82
  end
  object lblSize: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 66
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblSize'
    ExplicitWidth = 33
  end
  object lblInsight: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 174
    Width = 618
    Height = 15
    Align = alTop
    Caption = 'lblInsight'
    WordWrap = True
    ExplicitLeft = 8
  end
  object bvlMain: TBevel
    Left = 4
    Top = 392
    Width = 615
    Height = 1
    Shape = bsTopLine
  end
  object btnOK: TBitBtn
    Left = 280
    Top = 406
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
