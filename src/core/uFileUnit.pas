unit uFileUnit;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, ComObj;

type TFileUnit = class
  private
    FFilePath: string;
    FFileExt: string;
    FFileLastModified: TDateTime;
    function GetFileSize: Int64;
    function GetFileTxtContent: string;
    function GetFileDocContent: string;
  public
    constructor Create(AFilePath: string);
    destructor Destroy; override;
    property FilePath: string read FFilePath;
    property FileExt: string read FFileExt;
    property FileSize: Int64 read GetFileSize;
    property FileLastModified: TDateTime read FFileLastModified;
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
  else if (FFileExt = '.doc') or (FFileExt = '.docx') then
    Result := GetFileDocContent;
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

function TFileUnit.GetFileDocContent: string;
var
  WordApp, Doc: OleVariant;
begin
  Result := '';
  try
    WordApp := CreateOleObject('Word.Application');
  except
    on E: EOleException do
      raise Exception.Create('Microsoft Word is not installed or cannot be started.');
  end;
  WordApp.Visible := False;
  try
    Doc := WordApp.Documents.Open(FFilePath, ReadOnly := True);
    Result := Doc.Content.Text;
    Doc.Close(False);
  finally
    WordApp.Quit;
  end;
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

end.
