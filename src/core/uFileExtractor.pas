unit uFileExtractor;

interface

uses
  System.JSON, System.SysUtils, System.Classes, System.IOUtils,
  Windows, Vcl.Dialogs,
  uPaths, uGlobal;

type TFileExtractor = class
  private
    FFilePath: string;
    FFileExt: string;
    function GetFileTxtContent: string;
    function GetFileDocxContent: string;
    function GetFilePdfContent: string;
    function GetFileJSONContent: string;
    function GetJsonToReadable(Value: TJSONValue; Level: Integer): string;
  public
    constructor Create(AFilePath: string);
    destructor Destroy; override;
    property FilePath: string read FFilePath;
    function GetFileContent: string;
end;

implementation

constructor TFileExtractor.Create(AFilePath: string);
begin
  if not FileExists(AFilePath) then
    raise Exception.Create('File not found: ' + AFilePath);
  inherited Create;
  FFilePath := AFilePath;
  FFileExt := LowerCase(ExtractFileExt(AFilePath));
end;

destructor TFileExtractor.Destroy;
begin
  inherited;
end;

function TFileExtractor.GetFileContent: string;
begin
  Result := '';
  if FFileExt = '.txt' then
    Result := GetFileTxtContent
  else if (FFileExt = '.docx') or (FFileExt = '.odt') then
    Result := GetFileDocxContent
  else if FFileExt = '.pdf' then
    Result := GetFilePdfContent
  else if FFileExt = '.json' then
    Result := GetFileJSONContent
  else
    Result := 'File extension ' + FFileExt + ' not supports';
end;

function TFileExtractor.GetFileTxtContent: string;
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

function TFileExtractor.GetFilePdfContent: string;
var
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
  CmdLine := Format('"%s" "%s" -', [PdfToTextExe, FFilePath]);
  Result := CLIRunner.RunCommand(CmdLine);
end;

function TFileExtractor.GetFileDocxContent: string;
var
  CmdLine: string;
  DocxToTextExe: string;
begin
  Result := '';
  if not IsDocxToTextExeAvailable then
  begin
    ShowMessage('docxtotext.exe not found');
    Exit;
  end;
  DocxToTextExe := GetDocxToTextExe;
  CmdLine := Format('"%s" "%s" -t plain -o -', [DocxToTextExe, FFilePath]);
  Result := CLIRunner.RunCommand(CmdLine);
end;

function TFileExtractor.GetFileJSONContent: string;
var
  JsonText: string;
  JsonValue: TJSONValue;
begin
  Result := '';
  JsonText := TFile.ReadAllText(FFilePath, TEncoding.UTF8);
  JsonValue := TJSONObject.ParseJSONValue(JsonText);
  try
    if not Assigned(JsonValue) then
      Exit(JsonText);
    Result := GetJsonToReadable(JsonValue, 0);
  finally
    JsonValue.Free;
  end;
end;

function TFileExtractor.GetJsonToReadable(Value: TJSONValue; Level: Integer): string;
var
  Obj: TJSONObject;
  Pair: TJSONPair;
  Arr: TJSONArray;
  Item: TJSONValue;
  I: Integer;
  Indent: string;
begin
  Indent := StringOfChar(' ', Level * 2);
  Result := '';
  if Value is TJSONObject then
  begin
    Obj := TJSONObject(Value);
    for Pair in Obj do
    begin
      Result := Result + Indent + Pair.JsonString.Value + ': ';
      if (Pair.JsonValue is TJSONObject) or (Pair.JsonValue is TJSONArray) then
        Result := Result + sLineBreak + GetJsonToReadable(Pair.JsonValue, Level + 1)
      else
        Result := Result + Pair.JsonValue.Value + sLineBreak;
    end;
  end
  else if Value is TJSONArray then
  begin
    Arr := TJSONArray(Value);
    for I := 0 to Arr.Count - 1 do
    begin
      Item := Arr.Items[I];
      Result := Result + Indent + '- ';
      if (Item is TJSONObject) or (Item is TJSONArray) then
        Result := Result + sLineBreak + GetJsonToReadable(Item, Level + 1)
      else
        Result := Result + Item.Value + sLineBreak;
    end;
  end
  else
    Result := Indent + Value.Value + sLineBreak;
end;

end.
