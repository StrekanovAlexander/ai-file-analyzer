unit uFileItem;

interface

uses
  System.SysUtils,
  System.IOUtils,
  uConsts;

type TFileItem = class
  private
    FPath: string;
    FFileName: string;
    FIsSupported: Boolean;
    FExt: string;
    FSize: Int64;
    FLastModified: TDateTime;
    FStatus: TFileStatus;
    FTopic: string;
    FSummary: string;
    FKeywords: string;
    function IsSupportedExt(const Ext: string): Boolean;
  public
    constructor Create(const APath: string);
    property Path: string read FPath;
    property FileName: string read FFileName;
    property Ext: string read FExt;
    property Size: Int64 read FSize;
    property LastModified: TDateTime read FLastModified;
    property IsSupported: Boolean read FIsSupported;
    property Status: TFileStatus read FStatus write FStatus;
    property Topic: string read FTopic write FTopic;
    property Summary: string read FSummary write FSummary;
    property Keywords: string read FKeywords write FKeywords;
end;

implementation

constructor TFileItem.Create(const APath: string);
begin
  inherited Create;
  FPath := APath;
  FFileName := ExtractFileName(APath);
  FExt := LowerCase(ExtractFileExt(APath));
  FSize := TFile.GetSize(APath);
  FLastModified := TFile.GetLastWriteTime(APath);
  FIsSupported := IsSupportedExt(FExt);
  if FIsSupported then
    FStatus := fsPending
  else
    FStatus := fsSkipped;
  FTopic := '';
  FSummary := '';
  FKeywords := '';
end;

function TFileItem.IsSupportedExt(const Ext: string): Boolean;
var
  S: string;
begin
  for S in SUPPORTED_EXTS do
    if SameText(S, Ext) then
      Exit(True);
  Result := False;
end;

end.
