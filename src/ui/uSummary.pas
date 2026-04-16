unit uSummary;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls,
  uConsts, uFileItem, uFileSystemService, uStringUtils;

type
  TfmSummary = class(TForm)
    lblFileName: TLabel;
    lblFolder: TLabel;
    lblStatus: TLabel;
    lblTopic: TLabel;
    lblSummary: TLabel;
    lblKeywords: TLabel;
    btnOK: TBitBtn;
    lblLastModified: TLabel;
    lblSize: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FFileItem: TFileItem;
  public
    constructor Create(AOwner: TComponent; AFileItem: TFileItem); reintroduce;
  end;

var
  fmSummary: TfmSummary;

implementation

{$R *.dfm}

procedure TfmSummary.btnOKClick(Sender: TObject);
begin
  Close;
end;

constructor TfmSummary.Create(AOwner: TComponent; AFileItem: TFileItem);
begin
  inherited Create(AOwner);
  FFileItem := AFileItem;
end;

procedure TfmSummary.FormShow(Sender: TObject);
var
  Keywords: string;
begin
  lblFileName.Caption := Format('File: %s', [FFileItem.FileName]);
  lblFolder.Caption := Format('Folder: %s', [FFileItem.Folder]);
  lblLastModified.Caption := Format('Last Modified: %s', [DateTimeToStr(FFileItem.LastModified)]);
  lblSize.Caption := Format('Size: %s', [TFileSystemService.FormatFileSize(FFileItem.Size)]);

  lblStatus.Caption := Format('Status: %s', [FileStatusToStr(FFileItem.Status)]);
  lblTopic.Caption := 'File has not been processed yet...';
  lblSummary.Caption := '';
  lblKeywords.Caption := '';
  if FFileItem.Status = fsDone then
  begin
    lblTopic.Caption := Format('Topic: %s', [FFileItem.Topic]);
    lblSummary.Caption := Format('Summary: %s', [FFileItem.Summary]);
    Keywords := StringReplace(FFileItem.Keywords, '"', '', [rfReplaceAll]);
    lblKeywords.Caption := 'Keywords: ' + StringReplace(
      Keywords, ',', ', ', [rfReplaceAll]
    );
  end;
end;

end.
