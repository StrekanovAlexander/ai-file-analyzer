unit uFileItem;

interface

uses
  System.SysUtils,
  System.IOUtils,
  uConsts,
  uFileSystemService;

type TFileItem = class
  private
    FPath: string;
    FExt: string;
    FSize: Int64;
    FLastModified: TDateTime;
    FStatus: TFileStatus;
    FTopic: string;
    FSummary: string;
    FKeywords: string;
  public
    constructor Create(const APath: string);
    property Path: string read FPath;
    property Ext: string read FExt;
    property Size: Int64 read FSize;
    property LastModified: TDateTime read FLastModified;
    property Status: TFileStatus read FStatus;
    property Topic: string read FTopic;
    property Summary: string read FSummary;
    property Keywords: string read FKeywords;
end;

implementation

constructor TFileItem.Create(const APath: string);
begin
  inherited Create;
  FPath := APath;
  FExt := LowerCase(ExtractFileExt(APath));
  FSize := TFile.GetSize(APath);
  FLastModified := TFile.GetLastWriteTime(APath);
  if TFileSystemService.IsSupportedExt(FExt) then
    FStatus := fsPending
  else
    FStatus := fsSkipped;
  FTopic := '';
  FSummary := '';
  FKeywords := '';

end;

end.
