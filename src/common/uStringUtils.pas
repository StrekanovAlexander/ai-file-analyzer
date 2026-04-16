unit uStringUtils;

interface

uses
  System.SysUtils, System.Classes,
  uConsts;

const FIELD_TOPIC = 'TOPIC:';
const FIELD_SUMMARY = 'SUMMARY:';
const FIELD_INSIGHT = 'INSIGHT:';
const FIELD_KEYWORDS = 'KEYWORDS:';

function ExtractField(const Source: string; const Field: string): string;
function JoinString(const Arr: TArray<string>; const Delimiter: string): string;
function SplitString(const S, Delimiter: string): TArray<string>;
function CleanQuotes(const S: string): string;
function RemoveAllQuotes(const S: string): string;
function FileStatusToStr(FileStatus: TFileStatus): string;
function GetAnalysisPrompt: string;
function GetAnalysisPrompt2: string;
function EscapeCSV(const S: string): string;
function NormalizeKeywords(const S: string): string;

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

function CleanQuotes(const S: string): string;
begin
  Result := Trim(S);
  Result := Result.Replace('"', '');
end;

function RemoveAllQuotes(const S: string): string;
begin
  Result := StringReplace(S, '"', '', [rfReplaceAll]);
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


function GetAnalysisPrompt2: string;
begin
  Result :=
    'Analyze the following text and extract information.' + sLineBreak +
    sLineBreak +
    'Return EXACTLY 4 lines:' + sLineBreak +
    FIELD_SUMMARY + ' <one concise sentence (up to 20 words) describing the main point or conclusion>' + sLineBreak +
    FIELD_TOPIC + ' <1-5 words, specific and descriptive>' + sLineBreak +
    FIELD_KEYWORDS + ' <3-7 specific keywords, comma-separated>' + sLineBreak +
    FIELD_INSIGHT + ' <one short sentence describing the key takeaway or implication>' + sLineBreak +
    sLineBreak +
    'Rules:' + sLineBreak +
    '- Do not change field names (SUMMARY, TOPIC, KEYWORDS, INSIGHT)' + sLineBreak +
    '- Each field must be on one line' + sLineBreak +
    '- Keep output concise but meaningful' + sLineBreak +
    '- Avoid generic terms and vague language' + sLineBreak +
    '- Avoid overly generic topics like "Finance", "Technology", "Data"' + sLineBreak +
    '- Focus on the main point or outcome, not just general description' + sLineBreak +
    '- Insight must provide a meaningful takeaway, not repeat the summary' + sLineBreak +
    '- Prefer specific keyword phrases over single generic words' + sLineBreak +
    '- Do not write anything else' + sLineBreak +
    sLineBreak;
end;

function FileStatusToStr(FileStatus: TFileStatus): string;
begin
  case FileStatus of
    fsPending: Result := 'Pending';
    fsProcessing: Result := 'Processing';
    fsDone: Result := 'Done';
    fsError: Result := 'Error';
    fsSkipped: Result := 'Skipped';
  end;
end;

function EscapeCSV(const S: string): string;
begin
  Result := StringReplace(S, '"', '""', [rfReplaceAll]);
end;

function NormalizeKeywords(const S: string): string;
begin
  Result := StringReplace(S, ',', ';', [rfReplaceAll]);
end;

end.
