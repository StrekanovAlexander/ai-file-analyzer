unit uAIModel;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils,
  Windows,
  uRecords,
  uStringUtils;

type TAIModel = class
  private
    FLlamaPath: string;
    FModelPath: string;
    function RunPrompt(Prompt:string): string;
  public
    constructor Create(ALlamaPath: string; AModelPath: string);
    destructor Destroy; override;
    function AnalyzeContent(const FileContent: string): TAnalysisRecord;
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

function TAIModel.AnalyzeContent(const FileContent: string): TAnalysisRecord;
var
  Prompt: string;
  OutputStr: string;
  AnalysisRecord: TAnalysisRecord;
  KeywordsStr: string;
begin
  Prompt := GetAnalysisPrompt + FileContent;
  OutputStr := RunPrompt(Prompt);
  AnalysisRecord.Summary := ExtractField(OutputStr, FIELD_SUMMARY);
  AnalysisRecord.Topic := ExtractField(OutputStr, FIELD_TOPIC);
  KeywordsStr := ExtractField(OutputStr, FIELD_KEYWORDS);
  AnalysisRecord.Keywords := SplitString(KeywordsStr, ',');
  Result := AnalysisRecord;
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
    '"%s" --model "%s" --prompt "%s" --n_predict 128',
    [FLlamaPath, FModelPath, Prompt]
  );
  if not CreateProcess(nil, PChar(CmdLine), nil, nil, True, CREATE_NO_WINDOW, nil, nil, SI, PI) then
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

end.
