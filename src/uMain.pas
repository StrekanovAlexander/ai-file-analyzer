unit uMain;

interface

uses
  Windows,
  Messages,
  System.SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Vcl.Forms,
  Dialogs,
  StdCtrls,
  Vcl.Buttons,
  uAppPaths,
  uAIModel,
  uFileUnit,
  uRecords,
  uStringUtils;

type
  TfmMain = class(TForm)
    btnRun: TBitBtn;
    Memo1: TMemo;
    procedure btnRunClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAppPaths: TAppPaths;
    FAIModel: TAIModel;
  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnRunClick(Sender: TObject);
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

  FilePath := 'D:\ai-organizer-examples\example.txt';

//  FilePath := 'D:\ai-organizer-examples\sample2.docx';

  if not FileExists(FilePath) then
  begin
    ShowMessage('File not found: ' + FilePath);
    Exit;
  end;

  FileUnit := TFileUnit.Create(FilePath);
  try
    FileContent := FileUnit.GetFileContent;
    Memo1.Lines.Add(FileContent);
    Memo1.Lines.Add(IntToStr(FileUnit.FileSize));
    Memo1.Lines.Add(DateToStr(FileUnit.FileLastModified));
  finally
    FileUnit.Free;
  end;

  {
  AnalysisRecord := FAIModel.AnalyzeContent(FilePath);
  Memo1.Lines.Add('Topic: ' + AnalysisRecord.Topic);
  Memo1.Lines.Add('Summary: ' + AnalysisRecord.Summary);
  Memo1.Lines.Add('Keywords: ' + JoinString(AnalysisRecord.Keywords, ', '));
  }
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FAIModel.Free;
  FAppPaths.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  FAppPaths := TAppPaths.Create;
  if not FAppPaths.IsCliAvailable then
  begin
    ShowMessage('llama-cli.exe not found');
    Close;
    Exit;
  end;

  if not FAppPaths.IsModelAvailable then
  begin
    ShowMessage('LLM Model not found');
    Close;
    Exit;
  end;

  FAIModel := TAIModel.Create(FAppPaths.GetLlamaPath, FAppPaths.GetModelPath);
end;

end.
