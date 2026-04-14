unit uFileSystemService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uConsts, uFileItem;

type TFileSystemService = class
  public
    class function ScanFolder(Path: string): TObjectList<TFileItem>;
    class function FormatFileSize(Size: Int64): string;
    class function GetExtIndex(const Ext: string): Integer;
end;

implementation

class function TFileSystemService.ScanFolder(Path: string): TObjectList<TFileItem>;
var
  SR: TSearchRec;
  procedure Scan(const APath: string);
  var
    LocalSR: TSearchRec;
    FileItem: TFileItem;
  begin
    if FindFirst(APath + '\*.*', faAnyFile, LocalSR) = 0 then
    try
      repeat
        if (LocalSR.Name = '.') or (LocalSR.Name = '..') then
          Continue;
        if (LocalSR.Attr and faDirectory) <> 0 then
        begin
          Scan(APath + '\' + LocalSR.Name);
        end
        else
        begin
          FileItem := TFileItem.Create(APath + '\' + LocalSR.Name);
          Result.Add(FileItem);
        end;
      until FindNext(LocalSR) <> 0;
    finally
      FindClose(LocalSR);
    end;
  end;
begin
  Result := TObjectList<TFileItem>.Create(True);
  Scan(Path);
end;

{
class function TFileSystemService.ScanFolder(Path: string): TObjectList<TFileItem>;
var
  SR: TSearchRec;
  FileItem: TFileItem;
  FileItemList: TObjectList<TFileItem>;
begin
  FileItemList := TObjectList<TFileItem>.Create;
  if FindFirst(Path + '\*.*', faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Attr and faDirectory) = 0 then
      begin
        FileItem := TFileItem.Create(Path + '\' + SR.Name);
        FileItemList.Add(FileItem);
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
  Result := FileItemList;
end;
}

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
