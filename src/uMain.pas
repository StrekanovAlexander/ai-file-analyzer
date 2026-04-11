unit uMain;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics,
  Controls, Vcl.Forms, Dialogs, StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
  SVGIconImageListBase, SVGIconImageList,
  uGlobal, uConsts, uAppServices,
  uFolderScanner, uFileReader, uFileItem,
  uFileListController, uCLIRunner, uAIModel, uRecords, uStringUtils,
  uWait;

type
  TfmMain = class(TForm)
    pnlHeader: TPanel;
    pnlControls: TPanel;
    btnAnalyse: TBitBtn;
    stbMain: TStatusBar;
    lvwMain: TListView;
    edSourcePath: TEdit;
    svgBtns: TSVGIconImageList;
    btnBrowse: TBitBtn;
    btnScan: TBitBtn;
    svgExts: TSVGIconImageList;
    pbProgressStatus: TProgressBar;
    btnStop: TBitBtn;
    splMain: TSplitter;
    memoOutput: TMemo;
    pnlFilters: TPanel;
    chkDOCX: TCheckBox;
    chkPDF: TCheckBox;
    chkODT: TCheckBox;
    chkTXT: TCheckBox;
    chkOTHERS: TCheckBox;
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure OnFileReadDone(Sender: TObject; FileContent: string);
    procedure lvwMainSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FAIModel: TAIModel;
    FFolderScanner: TFolderScanner;
    FFileReader: TFileReader;
    FFileListController: TFileListController;
    FWaitForm: TfmWait;
    FExtFilterRecord: TExtFilterRecord;
    procedure OnScanDone(Sender: TObject; FileList: TStringList);
    procedure ShowWait(const Msg: string);
    procedure HideWait;
    procedure BuildFilter;
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
  {
  FileUnit := TFileUnit.Create(FilePath);
  try
    FileContent := FileUnit.GetFileContent;
    AnalysisRecord := FAIModel.AnalyzeContent(FileContent);
    MemoOutput.Lines.Add('Topic: ' + AnalysisRecord.Topic);
    MemoOutput.Lines.Add('Summary: ' + AnalysisRecord.Summary);
    MemoOutput.Lines.Add('Keywords: ' + JoinString(AnalysisRecord.Keywords, ', '));
  finally
    FileUnit.Free;
  end;
  }
end;

procedure TfmMain.btnScanClick(Sender: TObject);
begin
  btnScan.Enabled := False;
  ShowWait('Scanning folder...');
  FFolderScanner.Start(edSourcePath.Text);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  CLIRunner := TCLIRunner.Create;
  { Folder scanning... }
  FFolderScanner := TFolderScanner.Create;
  FFolderScanner.OnScanDone := OnScanDone;
  { File content reading... }
  FFileReader := TFileReader.Create;
  FFileReader.OnReadDone := OnFileReadDone;
  {FileListController functional}
  FFileListController := TFileListController.Create(lvwMain, memoOutput, stbMain);
  edSourcePath.Text := 'D:\ai-organizer-examples';
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FFileListController.Free;
  FFileReader.Free;
  FFolderScanner.Free;
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

procedure TfmMain.lvwMainSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  FileItem: TFileItem;
begin
  if not Selected then
    Exit;
  FileItem := TFileItem(Item.Data);
  if not Assigned(FileItem) then
    Exit;
  if FileItem.Status = fsSkipped then
  begin
    memoOutput.Lines.Text := 'File not supported for preview';
    Exit;
  end;
  ShowWait('Loading file content...');
  FFileReader.Start(TFileItem(Item.Data).Path);
end;

procedure TfmMain.OnScanDone(Sender: TObject; FileList: TStringList);
begin
  try
    HideWait;
    FFileListController.Bind(FileList);
  finally
    FileList.Free;
    btnScan.Enabled := True;
  end;
end;

procedure TfmMain.OnFileReadDone(Sender: TObject; FileContent: string);
begin
  HideWait;
  memoOutput.Lines.Text := FileContent;
end;

procedure TfmMain.ShowWait(const Msg: string);
begin
  FWaitForm := TfmWait.Create(nil);
  FWaitForm.lblMsg.Caption := Msg;
  FWaitForm.Show;
  FWaitForm.Update;
  Application.ProcessMessages;
end;

procedure TfmMain.HideWait;
begin
  if Assigned(FWaitForm) then
  begin
    FWaitForm.Close;
    FreeAndNil(FWaitForm);
  end;
end;

procedure TfmMain.BuildFilter;
var
  Exts: TArray<string>;
begin
  SetLength(Exts, 0);
  if chkDOCX.Checked then
    Exts := Exts + ['.docx'];
  if chkPDF.Checked then
    Exts := Exts + ['.pdf'];
  if chkODT.Checked then
    Exts := Exts + ['.odt'];
  if chkTXT.Checked then
    Exts := Exts + ['.txt'];
  FExtFilterRecord.Exts := Exts;
  FExtFilterRecord.ShowOthers := chkOTHERS.Checked;
end;

end.
