program AIFileAnalyzer;

uses
  Vcl.Forms,
  Vcl.Styles,
  Vcl.Themes,
  Winapi.Windows,
  uMain in 'src\uMain.pas' {fmMain},
  uGlobal in 'src\core\uGlobal.pas',
  uConsts in 'src\common\uConsts.pas',
  uRecords in 'src\common\uRecords.pas',
  uPaths in 'src\common\uPaths.pas',
  uAIModel in 'src\core\uAIModel.pas',
  uCLIRunner in 'src\core\uCLIRunner.pas',
  uAppServices in 'src\common\uAppServices.pas',
  uFileSystemService in 'src\common\uFileSystemService.pas',
  uFileExtractor in 'src\core\uFileExtractor.pas',
  uFileItem in 'src\core\uFileItem.pas',
  uFileListController in 'src\controllers\uFileListController.pas',
  uStringUtils in 'src\common\uStringUtils.pas',
  uWait in 'src\ui\uWait.pas' {fmWait},
  uFolderScanner in 'src\tasks\uFolderScanner.pas',
  uFileReader in 'src\tasks\uFileReader.pas',
  uFileFilter in 'src\core\uFileFilter.pas',
  uViewer in 'src\ui\uViewer.pas' {fmViewer},
  uAnalysis in 'src\ui\uAnalysis.pas' {fmAnalysis},
  uAbout in 'src\ui\uAbout.pas' {fmAbout};

var
  hMutex: THandle;

{$R *.res}

begin
  hMutex := CreateMutex(nil, True, 'MyUniqueAppNameMutex');
  if (hMutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
    Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'AI File Analyzer v1.0';
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmWait, fmWait);
  Application.CreateForm(TfmViewer, fmViewer);
  Application.CreateForm(TfmAnalysis, fmAnalysis);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.Run;
end.
