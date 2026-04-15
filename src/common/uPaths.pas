unit uPaths;

interface

uses
  System.SysUtils, Vcl.Forms;

const DOCX_TO_EXE     = 'libs\common\docxto.exe';
const PDF_TO_EXE      = 'libs\common\pdfto.exe';
const LLAMA_CLI_EXE   = 'libs\llama\llama-cli.exe';
const MODEL_GGUF      = 'libs\llama\models\qwen2.5-3b-instruct-q4_k_m.gguf';

function GetBasePath: string;

function GetDocxToTextExe: string;
function GetPdfToTextExe: string;
function GetLlamaCliExe: string;
function GetModelGguf: string;

function IsDocxToTextExeAvailable: Boolean;
function IsPdfToTextExeAvailable: Boolean;
function IsLlamaCliExeAvailable: Boolean;
function IsModelGgufAvailable: Boolean;

implementation

function GetBasePath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function GetDocxToTextExe: string;
begin
  Result := GetBasePath + DOCX_TO_EXE;
end;

function GetPdfToTextExe: string;
begin
  Result := GetBasePath + PDF_TO_EXE;
end;

function GetLlamaCliExe: string;
begin
  Result := GetBasePath + LLAMA_CLI_EXE;
end;

function GetModelGguf: string;
begin
  Result := GetBasePath + MODEL_GGUF;
end;

function IsDocxToTextExeAvailable: Boolean;
begin
  Result := FileExists(GetDocxToTextExe);
end;

function IsPdfToTextExeAvailable: Boolean;
begin
  Result := FileExists(GetPdfToTextExe);
end;

function IsLlamaCliExeAvailable: Boolean;
begin
  Result := FileExists(GetLlamaCliExe);
end;

function IsModelGgufAvailable: Boolean;
begin
  Result := FileExists(GetModelGguf);
end;

end.
