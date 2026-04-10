unit uAppServices;

interface

uses
  System.SysUtils,
  uAIModel, uPaths;

type
  TAppServices = class
  public
    class function InitAIModel: TAIModel;
  end;

implementation

class function TAppServices.InitAIModel: TAIModel;
begin
  if not IsLlamaCliExeAvailable then
    raise Exception.Create('llama-cli.exe not found');

  if not IsModelGgufAvailable then
    raise Exception.Create('LLM Model not found');

  Result := TAIModel.Create(GetLlamaCliExe, GetModelGguf);
end;

end.
