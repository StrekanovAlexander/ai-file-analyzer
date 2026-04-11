unit uWait;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SVGIconImage, Vcl.ExtCtrls;

type
  TfmWait = class(TForm)
    pnlMain: TPanel;
    svgImg: TSVGIconImage;
    lblMsg: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWait: TfmWait;

implementation

{$R *.dfm}

end.
