unit uAIModel;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils,
  Windows,
  uGlobal,
  uRecords,
  uStringUtils;

type TAIModel = class
  private
    FLlamaPath: string;
    FModelPath: string;
    function RunPrompt(Prompt:string): string;
  public
    constructor Create(ALlamaPath: string; AModelPath: string);
    destructor Destroy; override;
    function AnalyzeContent(const FileContent: string): TAnalysisRecord;
end;

implementation

constructor TAIModel.Create(ALlamaPath: string; AModelPath: string);
begin
  inherited Create;
  FLlamaPath := ALlamaPath;
  FModelPath := AModelPath;
end;

destructor TAIModel.Destroy;
begin
  inherited;
end;

function TAIModel.AnalyzeContent(const FileContent: string): TAnalysisRecord;
var
  Prompt: string;
  OutputStr: string;
  AnalysisRecord: TAnalysisRecord;
  KeywordsStr: string;
begin
  Prompt := GetAnalysisPrompt2 + FileContent;
  OutputStr := RunPrompt(Prompt);
  AnalysisRecord.Summary := ExtractField(OutputStr, FIELD_SUMMARY);
  AnalysisRecord.Topic := ExtractField(OutputStr, FIELD_TOPIC);
  KeywordsStr := ExtractField(OutputStr, FIELD_KEYWORDS);
  AnalysisRecord.Keywords := SplitString(KeywordsStr, ',');
  AnalysisRecord.Insight := ExtractField(OutputStr, FIELD_INSIGHT);
  Result := AnalysisRecord;
end;

function TAIModel.RunPrompt(Prompt: string): string;
var
  CmdLine: string;
begin
  // sanitize prompt
  Prompt := StringReplace(Prompt, '"', '\"', [rfReplaceAll]);
  Prompt := StringReplace(Prompt, sLineBreak, ' ', [rfReplaceAll]);

  CmdLine := Format(
    '"%s" --model "%s" --prompt "%s" --n_predict 160 --temp 0.3',
    [FLlamaPath, FModelPath, Prompt]
  );

  Result := CLIRunner.RunCommand(CmdLine);
end;

{
Base Version
function TAIModel.RunPrompt(Prompt: string): string;
var
  CmdLine: string;
begin
  CmdLine := Format(
    '"%s" --model "%s" --prompt "%s" --n_predict 128',
    [FLlamaPath, FModelPath, Prompt]
  );
  Result := CLIRunner.RunCommand(CmdLine);
end;
}

end.
