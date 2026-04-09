unit uAppPaths;

interface

uses
  System.SysUtils,
  Vcl.Forms;

type
  TAppPaths = class
  private
    FBasePath: string;
  public
    constructor Create;
    function GetPdfToTextExe: string;
    function GetLlamaPath: string;
    function GetModelPath: string;
    function IsCliAvailable: Boolean;
    function IsModelAvailable: Boolean;
  end;

implementation

const
  PDF_TO_TEXT_EXE = 'libs\pdf\pdftotext.exe';
  LLAMA_FILE_PATH = 'libs\llama\llama-cli.exe';
  MODEL_FILE_PATH = 'libs\llama\models\qwen2.5-3b-instruct-q4_k_m.gguf';

constructor TAppPaths.Create;
begin
  inherited Create;
  FBasePath := ExtractFilePath(Application.ExeName);
end;

function TAppPaths.GetPdfToTextExe: string;
begin
  Result := FBasePath + PDF_TO_TEXT_EXE;
end;

function TAppPaths.GetLlamaPath: string;
begin
  Result := FBasePath + LLAMA_FILE_PATH;
end;

function TAppPaths.GetModelPath: string;
begin
  Result := FBasePath + MODEL_FILE_PATH;
end;

function TAppPaths.IsCliAvailable: Boolean;
begin
  Result := FileExists(GetLlamaPath);
end;

function TAppPaths.IsModelAvailable: Boolean;
begin
  Result := FileExists(GetModelPath);
end;

end.
