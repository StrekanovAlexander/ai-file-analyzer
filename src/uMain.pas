unit uMain;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics,
  Controls, Vcl.Forms, Dialogs, StdCtrls, Vcl.Buttons,
  uGlobal, uAppServices, uFileSystemService,
  uFileListController,
  uCLIRunner, uAIModel, uFileUnit, uRecords, uStringUtils, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, SVGIconImageListBase,
  SVGIconImageList;

type
  TfmMain = class(TForm)
    Memo1: TMemo;
    pnlHeader: TPanel;
    pnlControls: TPanel;
    pnlProgress: TPanel;
    pbProgressStatus: TProgressBar;
    lblProgressStatus: TLabel;
    btnAnalyse: TBitBtn;
    stbMain: TStatusBar;
    lvwMain: TListView;
    edSourcePath: TEdit;
    svgBtns: TSVGIconImageList;
    btnBrowse: TBitBtn;
    btnScan: TBitBtn;
    btnStopScan: TBitBtn;
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
  private
    FAIModel: TAIModel;
    FFileListController: TFileListController;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAnalyseClick(Sender: TObject);
var
  FilePath: string;
  AnalysisRecord: TAnalysisRecord;
  FileUnit: TFileUnit;
  FileContent: string;
begin
  if not Assigned(FAIModel) then
  begin
    ShowMessage('Model is not initialized.');
    Exit;
  end;

  FilePath := 'D:\ai-organizer-examples\sample7.odt';

  if not FileExists(FilePath) then
  begin
    ShowMessage('File not found: ' + FilePath);
    Exit;
  end;

  FileUnit := TFileUnit.Create(FilePath);
  try
    FileContent := FileUnit.GetFileContent;
    AnalysisRecord := FAIModel.AnalyzeContent(FileContent);
    Memo1.Lines.Add('Topic: ' + AnalysisRecord.Topic);
    Memo1.Lines.Add('Summary: ' + AnalysisRecord.Summary);
    Memo1.Lines.Add('Keywords: ' + JoinString(AnalysisRecord.Keywords, ', '));
    Memo1.Lines.Add('Size: ' + FileUnit.FormattedFileSize);
    Memo1.Lines.Add('DateTime: ' + FileUnit.FormattedFileLastModified);
  finally
    FileUnit.Free;
  end;
end;

procedure TfmMain.btnScanClick(Sender: TObject);
var
  FileList: TStringList;
begin
  FileList := TFileSystemService.ScanFolder(edSourcePath.Text);
  FFileListController.Bind(FileList);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  CLIRunner := TCLIRunner.Create;
  FFileListController := TFileListController.Create(lvwMain);
  edSourcePath.Text := 'D:\ai-organizer-examples';
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FFileListController.Free;
  FAIModel.Free;
  CLIRunner.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  try
    FAIModel := TAppServices.InitAIModel;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Close;
    end;
  end;
end;

end.
