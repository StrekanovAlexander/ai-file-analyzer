unit uViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uFileItem, uFileReader;

type
  TfmViewer = class(TForm)
    memoContent: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FFileItem: TFileItem;
    FFileReader: TFileReader;
    FIsClosing: Boolean;
    procedure OnFileReadDone(Sender: TObject; FileContent: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AFileItem: TFileItem); reintroduce;
  end;

var
  fmViewer: TfmViewer;

implementation

{$R *.dfm}

constructor TfmViewer.Create(AOwner: TComponent; AFileItem: TFileItem);
begin
  inherited Create(AOwner);
  FFileItem := AFileItem;
  FFileReader := TFileReader.Create;
  FFileReader.OnReadDone := OnFileReadDone;
end;

procedure TfmViewer.OnFileReadDone(Sender: TObject; FileContent: string);
begin
  if FIsClosing then Exit;
  memoContent.Lines.Text := FFileItem.FileName + sLineBreak + sLineBreak + FileContent;;
end;

procedure TfmViewer.FormDestroy(Sender: TObject);
begin
  FIsClosing := True;
  if Assigned(FFileReader) then
  begin
    FFileReader.OnReadDone := nil;
    FFileReader.Free;
  end;
end;

procedure TfmViewer.FormShow(Sender: TObject);
begin
  memoContent.Lines.Text := 'Loading file content...';
  FFileReader.Start(FFileItem.Path);
end;

end.
