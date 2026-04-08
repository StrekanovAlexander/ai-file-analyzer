unit uAIModel;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, System.RegularExpressions,
  Windows;

type TAIModel = class
  private
    FLlamaPath: string;
    FModelPath: string;
    function RunPrompt(Prompt:string): string;
    function ExtractTopic(const Source: string): string;
  public
    constructor Create(ALlamaPath: string; AModelPath: string);
    destructor Destroy; override;
    function AnalyzeContent(const FilePath: string): string;
end;

implementation

constructor TAIModel.Create(ALlamaPath: string; AModelPath: string);
begin
  inherited Create;
  FLlamaPath := ALlamaPath;
  FModelPath := AModelPath;
end;

destructor TAIModel.Destroy;
begin
  inherited;
end;

function TAIModel.AnalyzeContent(const FilePath: string): string;
var
  FileContent: string;
  Prompt: string;
  OutputStr: string;
begin
  FileContent := TFile.ReadAllText(FilePath, TEncoding.UTF8);
  Prompt := 'Read the following text and return its main topic in 1-3 words.' +
            'Return topic in format:' + sLineBreak +
            'Format: TOPIC: your answer' + sLineBreak + FileContent;
  OutputStr := RunPrompt(Prompt);
  Result := ExtractTopic(OutputStr);
end;

function TAIModel.RunPrompt(Prompt: string): string;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  SecAttr: TSecurityAttributes;
  StdOutRead, StdOutWrite: THandle;
  Buffer: array[0..4095] of AnsiChar;
  BytesRead: DWORD;
  CmdLine: string;
  AppPath: string;
  Output: string;
begin
  SecAttr.nLength := SizeOf(SecAttr);
  SecAttr.bInheritHandle := TRUE;
  SecAttr.lpSecurityDescriptor := nil;
  if not CreatePipe(StdOutRead, StdOutWrite, @SecAttr, 0) then
    raise Exception.Create('Cannot create pipe');
  ZeroMemory(@SI, SizeOf(SI));
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  SI.hStdOutput := StdOutWrite;
  SI.hStdError := StdOutWrite;
  SI.hStdInput := INVALID_HANDLE_VALUE;
  SI.wShowWindow := SW_HIDE;
  ZeroMemory(@PI, SizeOf(PI));
  CmdLine := Format(
    '"%s" --model "%s" --prompt "%s" --n_predict 16',
    [FLlamaPath, FModelPath, Prompt]
  );
  if not CreateProcess(nil, PChar(CmdLine), nil, nil, TRUE, 0, nil, nil, SI, PI) then
    raise Exception.Create('Failed to start llama-cli.exe');
  CloseHandle(StdOutWrite);
  WaitForSingleObject(PI.hProcess, INFINITE);
  Output := '';
  repeat
    if ReadFile(StdOutRead, Buffer, SizeOf(Buffer)-1, BytesRead, nil) then
    begin
      if BytesRead > 0 then
      begin
        Buffer[BytesRead] := #0;
        Output := Output + UTF8ToString(AnsiString(Buffer));
      end;
    end;
  until BytesRead = 0;
  CloseHandle(PI.hProcess);
  CloseHandle(PI.hThread);
  CloseHandle(StdOutRead);
  Result := Output;
end;

function TAIModel.ExtractTopic(const Source: string): string;
var
  i: Integer;
  MarkerPos: Integer;
begin
  MarkerPos := 0;
  for i := Length(Source) - Length('TOPIC:') + 1 downto 1 do
  begin
    if Copy(Source, i, Length('TOPIC:')) = 'TOPIC:' then
    begin
      MarkerPos := i;
      Break;
    end;
  end;
  if MarkerPos = 0 then
  begin
    Result := '';
    Exit;
  end;
  Result := Trim(Copy(Source, MarkerPos + Length('TOPIC:'), MaxInt));
  i := Pos(#13#10, Result);
  if i > 0 then
    Result := Trim(Copy(Result, 1, i - 1));
end;

end.
