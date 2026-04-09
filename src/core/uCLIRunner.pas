unit uCLIRunner;

interface

uses
  System.SysUtils,
  Windows;

type TCLIRunner = class
  private
    FStdOutRead: THandle;
    FStdOutWrite: THandle;
    FBuffer: array[0..4095] of AnsiChar;
    FSecAttr: TSecurityAttributes;
  public
    constructor Create;
    destructor Destroy; override;
    function RunCommand(const CmdLine: string): string;
end;

implementation

constructor TCLIRunner.Create;
begin
  inherited Create;
  FillChar(FSecAttr, SizeOf(FSecAttr), 0);
  FSecAttr.nLength := SizeOf(FSecAttr);
  FSecAttr.bInheritHandle := True;
  FSecAttr.lpSecurityDescriptor := nil;
end;

destructor TCLIRunner.Destroy;
begin
end;

function TCLIRunner.RunCommand(const CmdLine: string): string;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  BytesRead: DWORD;
  Output: string;
begin
  Result := '';

  if not CreatePipe(FStdOutRead, FStdOutWrite, @FSecAttr, 0) then
    raise Exception.Create('Cannot create pipe');

  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESTDHANDLES;
  SI.hStdOutput := FStdOutWrite;
  SI.hStdError := FStdOutWrite;
  SI.hStdInput := INVALID_HANDLE_VALUE;

  FillChar(PI, SizeOf(PI), 0);

  if not CreateProcess(nil, PChar(CmdLine), nil, nil, True, CREATE_NO_WINDOW, nil, nil, SI, PI) then
  begin
    CloseHandle(FStdOutRead);
    CloseHandle(FStdOutWrite);
    raise Exception.Create('Failed to start CLI process');
  end;
  CloseHandle(FStdOutWrite);

  repeat
    if ReadFile(FStdOutRead, FBuffer, SizeOf(FBuffer)-1, BytesRead, nil) then
    begin
      if BytesRead > 0 then
      begin
        FBuffer[BytesRead] := #0;
        Result := Result + UTF8ToString(AnsiString(FBuffer));
      end;
    end;
  until BytesRead = 0;

  WaitForSingleObject(PI.hProcess, INFINITE);
  CloseHandle(PI.hProcess);
  CloseHandle(PI.hThread);
  CloseHandle(FStdOutRead);
end;

end.
