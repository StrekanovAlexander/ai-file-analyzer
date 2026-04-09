program AIFileAnalyzer;

uses
  Vcl.Forms,
  uMain in 'src\uMain.pas' {fmMain},
  Vcl.Themes,
  Vcl.Styles,
  uAIModel in 'src\core\uAIModel.pas',
  uConsts in 'src\common\uConsts.pas',
  uRecords in 'src\common\uRecords.pas',
  uStringUtils in 'src\common\uStringUtils.pas',
  uFileUnit in 'src\core\uFileUnit.pas',
  uPaths in 'src\common\uPaths.pas',
  uCLIRunner in 'src\core\uCLIRunner.pas',
  uGlobal in 'src\core\uGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
