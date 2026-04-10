unit uFileSystemService;

interface

uses
  System.SysUtils,
  System.Classes;

type TFileSystemService = class
  public
    class function ScanFolder(Path: string): TStringList;
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

end.
