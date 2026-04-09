unit uStringUtils;

interface

uses
  System.SysUtils, System.Classes;

const FIELD_TOPIC = 'TOPIC:';
const FIELD_SUMMARY = 'SUMMARY:';
const FIELD_KEYWORDS = 'KEYWORDS:';

function ExtractField(const Source: string; const Field: string): string;
function JoinString(const Arr: TArray<string>; const Delimiter: string): string;
function SplitString(const S, Delimiter: string): TArray<string>;

function GetAnalysisPrompt: string;

implementation

function JoinString(const Arr: TArray<string>; const Delimiter: string): string;
var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    for I := 0 to Length(Arr) - 1 do
      SL.Add(Arr[I]);
    Result := SL.CommaText;
    if Delimiter <> ',' then
      Result := StringReplace(Result, ',', Delimiter, [rfReplaceAll]);
  finally
    SL.Free;
  end;
end;

function SplitString(const S, Delimiter: string): TArray<string>;
var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    SL.Delimiter := Delimiter[1];
    SL.StrictDelimiter := True;
    SL.DelimitedText := S;
    SetLength(Result, SL.Count);
    for I := 0 to SL.Count - 1 do
      Result[I] := Trim(SL[I]);
  finally
    SL.Free;
  end;
end;

function ExtractField(const Source: string; const Field: string): string;
var
  i: Integer;
  MarkerPos: Integer;
begin
  MarkerPos := 0;
  for i := Length(Source) - Length(Field) + 1 downto 1 do
  begin
    if Copy(Source, i, Length(Field)) = Field then
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
  Result := Trim(Copy(Source, MarkerPos + Length(Field), MaxInt));
  i := Pos(#13#10, Result);
  if i > 0 then
    Result := Trim(Copy(Result, 1, i - 1));
end;

function GetAnalysisPrompt: string;
begin
  Result :=
    'Analyze the following text and extract information.' + sLineBreak +
    sLineBreak +
    'Return EXACTLY 3 lines:' + sLineBreak +
    FIELD_SUMMARY + ' <one short sentence>' + sLineBreak +
    FIELD_TOPIC + ' <1-5 words>' + sLineBreak +
    FIELD_KEYWORDS + ' <3-7 words, comma-separated>' + sLineBreak +
    sLineBreak +
    'Rules:' + sLineBreak +
    '- Do not change field names (SUMMARY, TOPIC, KEYWORDS)' + sLineBreak +
    '- Do not rename fields' + sLineBreak +
    '- Each field must be on one line' + sLineBreak +
    '- Keep summary short and simple' + sLineBreak +
    '- Do not write anything else' + sLineBreak +
    sLineBreak;
end;

end.
