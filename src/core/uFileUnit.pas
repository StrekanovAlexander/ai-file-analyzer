unit uFileUnit;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, Windows, Vcl.Dialogs,
  uPaths, uGlobal;

type TFileUnit = class
  private
    FFilePath: string;
    FFileExt: string;
    FFileLastModified: TDateTime;
    FFileSize: Int64;
    function GetFileSize: Int64;
    function GetFormattedFileSize: string;
    function GetFormattedFileLastModified: string;
    function GetFileTxtContent: string;
    function GetFileDocxContent: string;
    function GetFilePdfContent: string;
  public
    constructor Create(AFilePath: string);
    destructor Destroy; override;
    property FilePath: string read FFilePath;
    property FileExt: string read FFileExt;
    property FileSize: Int64 read FFileSize;
    property FormattedFileSize: string read GetFormattedFileSize;
    property FileLastModified: TDateTime read FFileLastModified;
    property FormattedFileLastModified: string read GetFormattedFileLastModified;
    function GetFileContent: string;
end;

implementation

constructor TFileUnit.Create(AFilePath: string);
begin
  if not FileExists(AFilePath) then
    raise Exception.Create('File not found: ' + AFilePath);
  inherited Create;
  FFilePath := AFilePath;
  FFileExt := LowerCase(ExtractFileExt(AFilePath));
  FFileLastModified := TFile.GetLastWriteTime(FFilePath);
  FFileSize := GetFileSize;
end;

destructor TFileUnit.Destroy;
begin
  inherited;
end;

function TFileUnit.GetFileContent: string;
begin
  Result := '';
  if FFileExt = '.txt' then
    Result := GetFileTxtContent
  else if FFileExt = '.docx' then
    Result := GetFileDocxContent
  else if FFileExt = '.pdf' then
    Result := GetFilePdfContent
  else if FFileExt = '.odt' then
    Result := GetFileDocxContent
  else
    Result := 'File extension ' + FFileExt + ' not supports';
end;

function TFileUnit.GetFileTxtContent: string;
var
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FFilePath, TEncoding.UTF8);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function TFileUnit.GetFilePdfContent: string;
var
  CmdLine: string;
  PdfToTextExe: string;
begin
  Result := '';
  if not IsPdfToTextExeAvailable then
  begin
    ShowMessage('pdftotext.exe not found');
    Exit;
  end;
  PdfToTextExe := GetPdfToTextExe;
  CmdLine := Format('"%s" "%s" -', [PdfToTextExe, FFilePath]);
  Result := CLIRunner.RunCommand(CmdLine);
end;

function TFileUnit.GetFileDocxContent: string;
var
  CmdLine: string;
  DocxToTextExe: string;
begin
  Result := '';
  if not IsDocxToTextExeAvailable then
  begin
    ShowMessage('docxtotext.exe not found');
    Exit;
  end;
  DocxToTextExe := GetDocxToTextExe;
  CmdLine := Format('"%s" "%s" -t plain -o -', [DocxToTextExe, FFilePath]);
  Result := CLIRunner.RunCommand(CmdLine);
end;

function TFileUnit.GetFileSize: Int64;
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FFilePath, fmOpenRead or fmShareDenyWrite);
  try
    Result := FS.Size;
  finally
    FS.Free;
  end;
end;

function TFileUnit.GetFormattedFileSize: string;
const
  KB = 1024;
  MB = KB * 1024;
begin
  if FFileSize >= MB then
    Result := Format('%.2f MB', [FFileSize / MB])
  else if FFileSize >= KB then
    Result := Format('%.2f KB', [FFileSize / KB])
  else
    Result := Format('%d B', [FFileSize]);
end;

function TFileUnit.GetFormattedFileLastModified: string;
begin
  Result := DateTimeToStr(FFileLastModified);
end;

end.
