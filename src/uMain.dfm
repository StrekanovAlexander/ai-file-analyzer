object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'AI File Analyzer v1.0'
  ClientHeight = 711
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
  TextHeight = 15
  object bvlMain: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 53
    Width = 978
    Height = 2
    Margins.Top = 0
    Align = alTop
  end
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 978
    Height = 50
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWhitesmoke
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    StyleName = 'Light'
    object svgLogo: TSVGIconImage
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 20
      Height = 44
      Margins.Left = 0
      AutoSize = False
      SVGText = 
        '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
        ' -960 960 960" width="24px" fill="#1f1f1f"><path d="M155-75q-35-' +
        '35-35-85t35-85q35-35 85-35 14 0 26 3t23 8l57-71q-28-31-39-70t-5-' +
        '78l-81-27q-17 25-43 40t-58 15q-50 0-85-35T0-580q0-50 35-85t85-35' +
        'q50 0 85 35t35 85v8l81 28q20-36 53.5-61t75.5-32v-87q-39-11-64.5-' +
        '42.5T360-840q0-50 35-85t85-35q50 0 85 35t35 85q0 42-26 73.5T510-' +
        '724v87q42 7 75.5 32t53.5 61l81-28v-8q0-50 35-85t85-35q50 0 85 35' +
        't35 85q0 50-35 85t-85 35q-32 0-58.5-15T739-515l-81 27q6 39-5 77.' +
        '5T614-340l57 70q11-5 23-7.5t26-2.5q50 0 85 35t35 85q0 50-35 85t-' +
        '85 35q-50 0-85-35t-35-85q0-20 6.5-38.5T624-232l-57-71q-41 23-87.' +
        '5 23T392-303l-56 71q11 15 17.5 33.5T360-160q0 50-35 85t-85 35q-5' +
        '0 0-85-35Zm-35-465q17 0 28.5-11.5T160-580q0-17-11.5-28.5T120-620' +
        'q-17 0-28.5 11.5T80-580q0 17 11.5 28.5T120-540Zm148.5 408.5Q280-' +
        '143 280-160t-11.5-28.5Q257-200 240-200t-28.5 11.5Q200-177 200-16' +
        '0t11.5 28.5Q223-120 240-120t28.5-11.5Zm240-680Q520-823 520-840t-' +
        '11.5-28.5Q497-880 480-880t-28.5 11.5Q440-857 440-840t11.5 28.5Q4' +
        '63-800 480-800t28.5-11.5ZM480-360q42 0 71-29t29-71q0-42-29-71t-7' +
        '1-29q-42 0-71 29t-29 71q0 42 29 71t71 29Zm268.5 228.5Q760-143 76' +
        '0-160t-11.5-28.5Q737-200 720-200t-28.5 11.5Q680-177 680-160t11.5' +
        ' 28.5Q703-120 720-120t28.5-11.5Zm120-420Q880-563 880-580t-11.5-2' +
        '8.5Q857-620 840-620t-28.5 11.5Q800-597 800-580t11.5 28.5Q823-540' +
        ' 840-540t28.5-11.5ZM480-840ZM120-580Zm360 120Zm360-120ZM240-160Z' +
        'm480 0Z"/></svg>'
      FixedColor = clCadetblue
      Align = alLeft
    end
    object lblLogo: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 15
      Width = 106
      Height = 20
      Margins.Top = 15
      Margins.Bottom = 15
      Align = alLeft
      Caption = 'AI File Analyzer'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitTop = 8
    end
    object btnAbout: TBitBtn
      AlignWithMargins = True
      Left = 878
      Top = 10
      Width = 100
      Height = 30
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 10
      Align = alRight
      Caption = 'About...'
      ImageIndex = 3
      ImageName = 'info'
      Images = svgBtns
      TabOrder = 0
      TabStop = False
      StyleName = 'Light'
      OnClick = btnAboutClick
    end
  end
  object pnlControls: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 67
    Width = 981
    Height = 36
    Margins.Left = 0
    Margins.Top = 9
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnAnalyse: TBitBtn
      AlignWithMargins = True
      Left = 881
      Top = 3
      Width = 100
      Height = 30
      Margins.Right = 0
      Align = alRight
      Caption = 'Analyse'
      ImageIndex = 2
      ImageName = 'bar_chart'
      Images = svgBtns
      TabOrder = 1
      OnClick = btnAnalyseClick
    end
    object btnBrowse: TBitBtn
      AlignWithMargins = True
      Left = 775
      Top = 3
      Width = 100
      Height = 30
      Align = alRight
      Caption = 'Browse...'
      ImageIndex = 0
      ImageName = 'folder_open'
      Images = svgBtns
      TabOrder = 0
      OnClick = btnBrowseClick
    end
    object pnlPath: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 766
      Height = 30
      Align = alClient
      TabOrder = 2
      object edSourcePath: TEdit
        AlignWithMargins = True
        Left = 4
        Top = 7
        Width = 758
        Height = 19
        Margins.Top = 6
        Align = alClient
        AutoSelect = False
        BorderStyle = bsNone
        Ctl3D = True
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = 'Choose a folder to analyze files'
      end
    end
  end
  object stbMain: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 689
    Width = 978
    Height = 19
    Enabled = False
    Panels = <
      item
        Text = 'All Files: 0'
        Width = 100
      end
      item
        Text = 'Analysing: 0'
        Width = 100
      end>
    ExplicitTop = 641
  end
  object lvwMain: TListView
    AlignWithMargins = True
    Left = 1
    Top = 141
    Width = 982
    Height = 542
    Margins.Left = 1
    Margins.Right = 1
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
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
        Caption = 'Summary'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Folder'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    SmallImages = svgExts
    SortType = stData
    TabOrder = 3
    ViewStyle = vsReport
    OnColumnClick = lvwMainColumnClick
    OnCompare = lvwMainCompare
    OnDblClick = lvwMainDblClick
    ExplicitHeight = 494
  end
  object pnlTools: TPanel
    Left = 0
    Top = 103
    Width = 984
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Shape2: TShape
      AlignWithMargins = True
      Left = 775
      Top = 3
      Width = 100
      Height = 29
      Align = alRight
      Pen.Color = clSilver
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object Shape3: TShape
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 11
      ExplicitTop = 6
      ExplicitHeight = 30
    end
    object Shape4: TShape
      AlignWithMargins = True
      Left = 427
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object Shape5: TShape
      AlignWithMargins = True
      Left = 321
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object Shape6: TShape
      AlignWithMargins = True
      Left = 215
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object Shape7: TShape
      AlignWithMargins = True
      Left = 109
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object Shape1: TShape
      AlignWithMargins = True
      Left = 533
      Top = 3
      Width = 100
      Height = 29
      Align = alLeft
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 36
    end
    object chkTxt: TCheckBox
      Left = 12
      Top = 12
      Width = 92
      Height = 13
      Hint = '.txt'
      Caption = '.txt'
      TabOrder = 0
      OnClick = chkDocxClick
    end
    object btnSave: TBitBtn
      AlignWithMargins = True
      Left = 881
      Top = 3
      Width = 100
      Height = 29
      Align = alRight
      Caption = 'Save'
      ImageIndex = 4
      ImageName = 'file-download'
      Images = svgBtns
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object cbExport: TComboBox
      Left = 779
      Top = 6
      Width = 92
      Height = 23
      Margins.Top = 6
      Style = csDropDownList
      Ctl3D = True
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 2
      Text = 'Export CSV'
      Items.Strings = (
        'Export CSV'
        'Export JSON')
    end
    object chkPdf: TCheckBox
      Left = 118
      Top = 12
      Width = 60
      Height = 13
      Hint = '.pdf'
      Caption = '.pdf'
      TabOrder = 3
      OnClick = chkDocxClick
    end
    object chkDocx: TCheckBox
      Left = 223
      Top = 12
      Width = 60
      Height = 13
      Hint = '.docx'
      Caption = '.docx'
      TabOrder = 4
      OnClick = chkDocxClick
    end
    object chkJson: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 12
      Width = 60
      Height = 13
      Hint = '.json'
      Caption = '.json'
      TabOrder = 5
      OnClick = chkDocxClick
    end
    object chkOdt: TCheckBox
      Left = 436
      Top = 12
      Width = 60
      Height = 13
      Hint = '.odt'
      Caption = '.odt'
      TabOrder = 6
      OnClick = chkDocxClick
    end
    object chkUnsupported: TCheckBox
      AlignWithMargins = True
      Left = 541
      Top = 12
      Width = 60
      Height = 13
      Caption = 'other'
      TabOrder = 7
      OnClick = chkUnsupportedClick
    end
    object btnPreview: TBitBtn
      AlignWithMargins = True
      Left = 669
      Top = 3
      Width = 100
      Height = 29
      Align = alRight
      Caption = 'Preview'
      ImageIndex = 5
      ImageName = 'preview'
      Images = svgBtns
      TabOrder = 8
      OnClick = btnPreviewClick
      ExplicitLeft = 672
      ExplicitTop = 8
      ExplicitHeight = 25
    end
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
        FixedColor = clCadetblue
      end
      item
        IconName = 'info'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' -960 960 960" width="24px" fill="#1f1f1f"><path d="M423.5-703.5' +
          'Q400-727 400-760t23.5-56.5Q447-840 480-840t56.5 23.5Q560-793 560' +
          '-760t-23.5 56.5Q513-680 480-680t-56.5-23.5ZM420-120v-480h120v480' +
          'H420Z"/></svg>'
      end
      item
        IconName = 'file-download'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0' +
          ' 0 24 24" height="48px" viewBox="0 0 24 24" width="48px" fill="#' +
          '1f1f1f"><g><rect fill="none" height="24" width="24"/></g><g><pat' +
          'h d="M18,15v3H6v-3H4v3c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2v-3H18z' +
          ' M17,11l-1.41-1.41L13,12.17V4h-2v8.17L8.41,9.59L7,11l5,5 L17,11z' +
          '"/></g></svg>'
      end
      item
        IconName = 'preview'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
          ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
          'fill="none"/><path d="M12 6.5c3.79 0 7.17 2.13 8.82 5.5-1.65 3.3' +
          '7-5.02 5.5-8.82 5.5S4.83 15.37 3.18 12C4.83 8.63 8.21 6.5 12 6.5' +
          'm0-2C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.' +
          '5c-1.73-4.39-6-7.5-11-7.5zm0 5c1.38 0 2.5 1.12 2.5 2.5s-1.12 2.5' +
          '-2.5 2.5-2.5-1.12-2.5-2.5 1.12-2.5 2.5-2.5m0-2c-2.48 0-4.5 2.02-' +
          '4.5 4.5s2.02 4.5 4.5 4.5 4.5-2.02 4.5-4.5-2.02-4.5-4.5-4.5z"/></' +
          'svg>'
      end>
    Scaled = True
    Left = 763
    Top = 181
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
        IconName = 'file-arrow-left-right'
        SVGText = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" v' +
          'iewBox="0 0 24 24"><path fill="currentColor" d="M19 13c.34 0 .67' +
          '.04 1 .09V8l-6-6H6c-1.11 0-2 .89-2 2v16c0 1.11.89 2 2 2h7.81c-.5' +
          '1-.88-.81-1.9-.81-3c0-3.31 2.69-6 6-6m-6-9.5L18.5 9H13zm7 16V18h' +
          '-4v-2h4v-1.5l3 2.5zm-2 .5h4v2h-4v1.5L15 21l3-2.5z"/></svg>'
        FixedColor = clDarkseagreen
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
        FixedColor = clSilver
      end>
    Scaled = True
    Left = 40
    Top = 184
  end
end
