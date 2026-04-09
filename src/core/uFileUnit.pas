unit uFileUnit;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, ComObj,
  Windows, Vcl.Dialogs,
  uPaths
  ;

type TFileUnit = class
  private
    FFilePath: string;
    FFileExt: string;
    FFileLastModified: TDateTime;
    function GetFileSize: Int64;
    function GetFileTxtContent: string;
    function GetFileDocContent: string;
    function GetFilePdfContent: string;
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
    Result := GetFileDocContent
  else if FFileExt = '.pdf' then
    Result := GetFilePdfContent
  else
    Result := 'File extension ' + FFileExt + ' not support';
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
  SA: TSecurityAttributes;
  StdOutRead, StdOutWrite: THandle;
  SI: TStartupInfo;
  PI: TProcessInformation;
  Buffer: array[0..4095] of AnsiChar;
  BytesRead: DWORD;
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

  FillChar(SA, SizeOf(SA), 0);
  SA.nLength := SizeOf(SA);
  SA.bInheritHandle := True;

  CreatePipe(StdOutRead, StdOutWrite, @SA, 0);

  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.hStdOutput := StdOutWrite;
  SI.hStdError := StdOutWrite;
  SI.dwFlags := STARTF_USESTDHANDLES;

  CmdLine := Format('"%s" "%s" -', [PdfToTextExe, FFilePath]);

  if CreateProcess(nil, PChar(CmdLine), nil, nil, True, CREATE_NO_WINDOW, nil, nil, SI, PI) then
  begin
    CloseHandle(StdOutWrite);

    repeat
      if ReadFile(StdOutRead, Buffer, SizeOf(Buffer)-1, BytesRead, nil) then
      begin
        if BytesRead > 0 then
        begin
          Buffer[BytesRead] := #0;
          Result := Result + UTF8ToString(AnsiString(Buffer));
        end;
      end;
    until BytesRead = 0;

    WaitForSingleObject(PI.hProcess, INFINITE);

    CloseHandle(PI.hProcess);
    CloseHandle(PI.hThread);
    CloseHandle(StdOutRead);
  end
  else
    raise Exception.Create('Failed to start pdftotext');
end;

function TFileUnit.GetFileDocContent: string;
//var WordApp, Doc: OleVariant;
begin
  Result := 'Doc content example';
  {
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
  }
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
