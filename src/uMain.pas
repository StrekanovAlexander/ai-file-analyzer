unit uMain;

interface

uses
  Windows,
  Messages,
  System.SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Vcl.Forms,
  Dialogs,
  StdCtrls,
  Vcl.Buttons,
  uAppPaths,
  uAIModel;

type
  TfmMain = class(TForm)
    btnRun: TBitBtn;
    Memo1: TMemo;
    procedure btnRunClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAppPaths: TAppPaths;
    FAIModel: TAIModel;
  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnRunClick(Sender: TObject);
var
  Prompt: string;
  ResultStr: string;
begin
  if not Assigned(FAIModel) then
  begin
    ShowMessage('Model is not initialized.');
    Exit;
  end;

  Prompt := 'Hello, model!';
  ResultStr := FAIModel.Run(Prompt);
  Memo1.Lines.Text := ResultStr;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FAIModel.Free;
  FAppPaths.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  FAppPaths := TAppPaths.Create;
  if not FAppPaths.IsCliAvailable then
  begin
    ShowMessage('llama-cli.exe not found');
    Close;
    Exit;
  end;

  if not FAppPaths.IsModelAvailable then
  begin
    ShowMessage('LLM Model not found');
    Close;
    Exit;
  end;

  FAIModel := TAIModel.Create(FAppPaths.GetLlamaPath, FAppPaths.GetModelPath);
end;

end.
