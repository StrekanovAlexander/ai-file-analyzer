object fmAnalysis: TfmAnalysis
  Left = 0
  Top = 0
  Margins.Right = 2
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'AI FileAnalyzer v1.0 - Analysis'
  ClientHeight = 461
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 5
  Padding.Right = 5
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 15
  object memoLog: TMemo
    Left = 5
    Top = 140
    Width = 434
    Height = 274
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 208
    ExplicitHeight = 212
  end
  object pnlTop: TPanel
    Left = 5
    Top = 0
    Width = 434
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 3
    ExplicitWidth = 428
    object lblFileName: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 428
      Height = 15
      Align = alTop
      Caption = 'Analysing:'
      ExplicitWidth = 55
    end
    object lblFileSize: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 24
      Width = 428
      Height = 15
      Align = alTop
      Caption = 'Size:'
      ExplicitLeft = 24
      ExplicitTop = 65
      ExplicitWidth = 23
    end
    object lblStatus: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 45
      Width = 428
      Height = 15
      Align = alTop
      Caption = 'Status:'
      ExplicitLeft = 8
      ExplicitTop = 65
      ExplicitWidth = 35
    end
  end
  object pnlProgress: TPanel
    Left = 5
    Top = 80
    Width = 434
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblProgress: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 26
      Width = 428
      Height = 15
      Align = alTop
      Alignment = taCenter
      Caption = 'Progress:'
      ExplicitWidth = 48
    end
    object pgbMain: TProgressBar
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 434
      Height = 17
      Margins.Left = 0
      Margins.Right = 0
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 11
      ExplicitWidth = 428
    end
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 417
    Width = 428
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 32
    ExplicitTop = 400
    ExplicitWidth = 377
    object btnBtn: TBitBtn
      Left = 152
      Top = 16
      Width = 85
      Height = 25
      Caption = 'Stop'
      ImageIndex = 0
      ImageName = 'stop'
      Images = svgBtns
      TabOrder = 0
      OnClick = btnBtnClick
    end
  end
  object svgBtns: TSVGIconImageList
    SVGIconItems = <
      item
        IconName = 'stop'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M16 8v8H8V8h8m2-2H6v12h12V6z"/></svg>'
        FixedColor = clRed
      end
      item
        IconName = 'close'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10' +
          '.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.' +
          '41z"/></svg>'
      end>
    Scaled = True
    Left = 400
    Top = 8
  end
end
