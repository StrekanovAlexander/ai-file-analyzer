unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SVGIconImage;

type
  TfmAbout = class(TForm)
    svgImg: TSVGIconImage;
    lblDescription: TLabel;
    lblDeveloper: TLabel;
    lblYear: TLabel;
    lblAppName: TLabel;
    lblVersion: TLabel;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.dfm}

procedure TfmAbout.btnOkClick(Sender: TObject);
begin
  Close;
end;

end.
