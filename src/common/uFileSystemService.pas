unit uFileSystemService;

interface

uses
  System.SysUtils,
  System.Classes;

type TFileSystemService = class
  public
    class function ScanFolder(Path: string): TStringList;
    class function FormatFileSize(Size: Int64): string;
end;

implementation

class function TFileSystemService.ScanFolder(Path: string): TStringList;
var
  SR: TSearchRec;
begin
  Result := TStringList.Create;
  if FindFirst(Path + '\*.*', faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Attr and faDirectory) = 0 then
        Result.Add(Path + '\' + SR.Name);
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

class function TFileSystemService.FormatFileSize(Size: Int64): string;
const
  KB = 1024;
  MB = KB * 1024;
begin
  if Size >= MB then
    Result := Format('%.2f MB', [Size / MB])
  else if Size >= KB then
    Result := Format('%.2f KB', [Size / KB])
  else
    Result := Format('%d B', [Size]);
end;

end.
