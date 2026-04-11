unit uFileSystemService;

interface

uses
  System.SysUtils,
  System.Classes,
  uConsts;

type TFileSystemService = class
  public
    class function ScanFolder(Path: string): TStringList;
    class function FormatFileSize(Size: Int64): string;
    class function IsSupportedExt(const Ext: string): Boolean;
    class function GetExtIndex(const Ext: string): Integer;
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

class function TFileSystemService.IsSupportedExt(const Ext: string): Boolean;
var
  S: string;
begin
  for S in SUPPORTED_EXTS do
    if SameText(S, Ext) then
      Exit(True);
  Result := False;
end;

class function TFileSystemService.GetExtIndex(const Ext: string): Integer;
var
  I: Integer;
begin
  for I := Low(SUPPORTED_EXTS) to High(SUPPORTED_EXTS) do
    if SameText(SUPPORTED_EXTS[I], Ext) then
      Exit(I);
  Result := Length(SUPPORTED_EXTS);
end;

end.
