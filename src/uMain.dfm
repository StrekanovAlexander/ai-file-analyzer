object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'AI FileAnalyzer v1.0'
  ClientHeight = 661
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  StyleName = 'Aqua Graphite'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 471
    Width = 978
    Height = 162
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 978
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlHeader'
    TabOrder = 0
  end
  object pnlControls: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 69
    Width = 978
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Padding.Top = 5
    Padding.Bottom = 5
    TabOrder = 1
    object btnAnalyse: TBitBtn
      AlignWithMargins = True
      Left = 893
      Top = 8
      Width = 85
      Height = 24
      Margins.Right = 0
      Align = alRight
      Caption = 'Analyse'
      ImageIndex = 3
      ImageName = 'bar_chart'
      Images = svgBtns
      TabOrder = 4
      OnClick = btnAnalyseClick
    end
    object edSourcePath: TEdit
      AlignWithMargins = True
      Left = 0
      Top = 7
      Width = 614
      Height = 25
      Margins.Left = 0
      Margins.Top = 2
      Align = alClient
      AutoSelect = False
      ReadOnly = True
      TabOrder = 0
      Text = 'Source path...'
      ExplicitHeight = 23
    end
    object btnBrowse: TBitBtn
      AlignWithMargins = True
      Left = 620
      Top = 8
      Width = 85
      Height = 24
      Align = alRight
      Caption = 'Browse...'
      Default = True
      ImageIndex = 0
      ImageName = 'folder_open'
      Images = svgBtns
      TabOrder = 1
    end
    object btnScan: TBitBtn
      AlignWithMargins = True
      Left = 711
      Top = 8
      Width = 85
      Height = 24
      Align = alRight
      Caption = 'Scan'
      ImageIndex = 1
      ImageName = 'search'
      Images = svgBtns
      TabOrder = 2
      OnClick = btnScanClick
    end
    object btnStopScan: TBitBtn
      AlignWithMargins = True
      Left = 802
      Top = 8
      Width = 85
      Height = 24
      Align = alRight
      Caption = 'Stop'
      ImageIndex = 2
      ImageName = 'stop'
      Images = svgBtns
      TabOrder = 3
    end
  end
  object pnlProgress: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 115
    Width = 978
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblProgressStatus: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 20
      Width = 80
      Height = 18
      Align = alLeft
      Caption = 'Progress Status'
      ExplicitHeight = 15
    end
    object pbProgressStatus: TProgressBar
      Left = 0
      Top = 0
      Width = 978
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object stbMain: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 639
    Width = 978
    Height = 19
    Panels = <>
  end
  object lvwMain: TListView
    AlignWithMargins = True
    Left = 3
    Top = 161
    Width = 981
    Height = 304
    Margins.Top = 2
    Margins.Right = 0
    Align = alClient
    Columns = <
      item
        Caption = 'File'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Size'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Ext'
      end
      item
        Caption = 'Last Modified'
        Width = 150
      end
      item
        AutoSize = True
        Caption = 'Status'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 5
    ViewStyle = vsReport
  end
  object svgBtns: TSVGIconImageList
    SVGIconItems = <
      item
        IconName = 'folder_open'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c' +
          '0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10' +
          'z"/></svg>'
      end
      item
        IconName = 'search'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.1' +
          '1 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 ' +
          '0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.' +
          '01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z' +
          '"/></svg>'
      end
      item
        IconName = 'stop'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M16 8v8H8V8h8m2-2H6v12h12V6z"/></svg>'
      end
      item
        IconName = 'bar_chart'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0' +
          ' 0 24 24" height="24px" viewBox="0 0 24 24" width="24px" fill="#' +
          '1f1f1f"><g><rect fill="none" height="24" width="24"/></g><g><g><' +
          'rect height="11" width="4" x="4" y="9"/><rect height="7" width="' +
          '4" x="16" y="13"/><rect height="16" width="4" x="10" y="4"/></g>' +
          '</g></svg>'
      end>
    Scaled = True
    Left = 851
    Top = 13
  end
end
