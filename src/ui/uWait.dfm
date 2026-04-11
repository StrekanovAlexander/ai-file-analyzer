object fmWait: TfmWait
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'fmWait'
  ClientHeight = 120
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 120
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 280
    object svgImg: TSVGIconImage
      AlignWithMargins = True
      Left = 4
      Top = 36
      Width = 242
      Height = 20
      Margins.Top = 35
      AutoSize = False
      SVGText = 
        '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0' +
        ' 0 24 24" width="24px" fill="#1f1f1f"><path d="M0 0h24v24H0V0z" ' +
        'fill="none"/><path d="M6 2v6h.01L6 8.01 10 12l-4 4 .01.01H6V22h1' +
        '2v-5.99h-.01L18 16l-4-4 4-3.99-.01-.01H18V2H6zm10 14.5V20H8v-3.5' +
        'l4-4 4 4zm-4-5l-4-4V4h8v3.5l-4 4z"/></svg>'
      FixedColor = clBlack
      Align = alTop
    end
    object lblMsg: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 62
      Width = 242
      Height = 15
      Align = alTop
      Alignment = taCenter
      Caption = 'Please wait...'
      ExplicitTop = 67
      ExplicitWidth = 67
    end
  end
end
