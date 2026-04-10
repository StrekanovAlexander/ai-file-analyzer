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
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Size'
        Width = 75
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
        Caption = 'Status'
        Width = 100
      end
      item
        Caption = 'Topic'
        Width = 150
      end
      item
        Caption = 'Keywords'
        Width = 150
      end
      item
        AutoSize = True
        Caption = 'Summary'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    SmallImages = svgExts
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
  object svgExts: TSVGIconImageList
    Size = 20
    SVGIconItems = <
      item
        IconName = 'file-word'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path fill="currentColor" d="M14 2H6a2 2 0 0 ' +
          '0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zm1.2 18h-1.4L12 13.2L1' +
          '0.2 20H8.8l-2.2-9h1.5l1.4 6.8l1.8-6.8h1.3l1.8 6.8l1.4-6.8h1.5zM1' +
          '3 9V3.5L18.5 9z"/></svg>'
        FixedColor = clHotLight
      end
      item
        IconName = 'file-pdf'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path d="M13 9h5.5L13 3.5V9M6 2h8l6 6v12a2 2 ' +
          '0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2m4.1 9.4c-.02.04-.29 1.' +
          '76-2.1 4.69c0 0-3.5 1.82-2.67 3.18c.67 1.08 2.32-.04 3.74-2.68c0' +
          ' 0 1.82-.64 4.24-.82c0 0 3.86 1.73 4.39-.11c.52-1.86-3.06-1.44-3' +
          '.7-1.25c0 0-2-1.35-2.5-3.21c0 0 1.14-3.95-.61-3.9c-1.75.05-1.09 ' +
          '3.13-.79 4.1m.81 1.04c.03.01.47 1.21 1.89 2.46c0 0-2.33.46-3.39.' +
          '9c0 0 1-1.73 1.5-3.36m3.93 2.72c.58-.16 2.33.15 2.26.48c-.06.33-' +
          '2.26-.48-2.26-.48M7.77 17c-.53 1.24-1.44 2-1.67 2c-.23 0 .7-1.6 ' +
          '1.67-2m3.14-6.93c0-.07-.36-2.2 0-2.15c.54.08 0 2.08 0 2.15z" fil' +
          'l="currentColor"/></svg>'
        FixedColor = clOrangered
      end
      item
        IconName = 'file-text'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path fill="currentColor" d="M13 9h5.5L13 3.5' +
          'zM6 2h8l6 6v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4c0-1.11.89-2 2-2m9' +
          ' 16v-2H6v2zm3-4v-2H6v2z"/></svg>'
        FixedColor = clSteelblue
      end
      item
        IconName = 'file-text-outline'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path fill="currentColor" d="M6 2a2 2 0 0 0-2' +
          ' 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm0 2h7v5h5v11H6zm2 8' +
          'v2h8v-2zm0 4v2h5v-2z"/></svg>'
      end
      item
        IconName = 'file-hidden'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path fill="currentColor" d="M13 9h1v2h-3V7h2' +
          'zm5.5 0l-2.12-2.12l1.25-1.25L20 8v2h-2v1h-3V9zM13 3.5V2h-1v2h1v2' +
          'h-2V4H9V2H8v2H6v1H4V4c0-1.11.89-2 2-2h8l2.36 2.36l-1.25 1.25zM20' +
          ' 20a2 2 0 0 1-2 2h-2v-2h2v-1h2zm-2-5h2v3h-2zm-6 7v-2h3v2zm-4 0v-' +
          '2h3v2zm-2 0a2 2 0 0 1-2-2v-2h2v2h1v2zm-2-8h2v3H4zm0-4h2v3H4zm14 ' +
          '1h2v3h-2zM4 6h2v3H4z"/></svg>'
        FixedColor = clGray
      end>
    Scaled = True
    Left = 352
    Top = 288
  end
end
