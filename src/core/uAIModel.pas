unit uAIModel;

interface

type TAIModel = class
  private
    FLlamaPath: string;
    FModelPath: string;
  public
    constructor Create(ALlamaPath: string; AModelPath: string);
    destructor Destroy; override;
    function Run(const Prompt: string): string;
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

function TAIModel.Run(const Prompt: string): string;
begin
  Result := 'Ok';
end;

end.
