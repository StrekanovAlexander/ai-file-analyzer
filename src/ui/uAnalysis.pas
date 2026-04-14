unit uAnalysis;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.Threading, System.SyncObjs,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, SVGIconImageListBase, SVGIconImageList,
  uAppServices, uRecords,
  uFileItem, uFileExtractor, uFileSystemService, uStringUtils;

type
  TfmAnalysis = class(TForm)
    lblFileName: TLabel;
    lblFileSize: TLabel;
    lblStatus: TLabel;
    lblProgress: TLabel;
    pgbMain: TProgressBar;
    btnBtn: TBitBtn;
    svgBtns: TSVGIconImageList;
    Label1: TLabel;
    memoLog: TMemo;
    procedure btnBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FFileItemList: TObjectList<TFileItem>;
    FIsProcess: Integer; // 1 = running, 0 = stopped
    FClosing: Boolean;
    FIndex: Integer;
    FFilesCount: Integer;
    procedure Start;
    procedure UpdateControls;
    procedure ChangeBtnToClose;
  public
    constructor Create(AOwner: TComponent;
      AFileItemList: TObjectList<TFileItem>); reintroduce;
    destructor Destroy; override;
  end;

var
  fmAnalysis: TfmAnalysis;

implementation

{$R *.dfm}

constructor TfmAnalysis.Create(AOwner: TComponent;
  AFileItemList: TObjectList<TFileItem>);
begin
  inherited  Create(AOwner);
  FFileItemList := AFileItemList;
  FIsProcess := 1;
  FIndex := 0;
  FFilesCount := FFileItemList.Count;
end;

destructor TfmAnalysis.Destroy;
begin
  FClosing := True;
  inherited;
end;

procedure TfmAnalysis.btnBtnClick(Sender: TObject);
begin
 if FIsProcess = 1 then
  begin
    TInterlocked.Exchange(FIsProcess, 0);
    lblStatus.Caption := 'Status: Stopping...';
    btnBtn.Enabled := False;
  end
  else
    Close;
end;

procedure TfmAnalysis.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FIsProcess = 1 then
  begin
    TInterlocked.Exchange(FIsProcess, 0);
    lblStatus.Caption := 'Status: Stopping...';
    btnBtn.Enabled := False;
    CanClose := False;
  end;
end;

procedure TfmAnalysis.FormShow(Sender: TObject);
begin
  pgbMain.Min := 0;
  pgbMain.Max := FFilesCount;
  Start;
end;

procedure TfmAnalysis.UpdateControls;
var
  FormattedFileSize: string;
begin
  lblFileName.Caption := Format( 'Analysing: %s', [FFileItemList[FIndex].FileName]);
  FormattedFileSize := TFileSystemService.FormatFileSize(FFileItemList[FIndex].Size);
  lblFileSize.Caption := Format( 'Size: %s', [FormattedFileSize]);
  lblStatus.Caption := 'Status: Extracting content...';
  lblProgress.Caption := Format( 'Progress: %d / %d', [FIndex + 1, FFilesCount]);
end;

procedure TfmAnalysis.Start;
var
  FileItem: TFileItem;
  FileContent: string;
  FileExtractor: TFileExtractor;
  AnalysisRecord: TAnalysisRecord;
begin
  TTask.Run(
    procedure
    begin
      for var I := 0 to FFilesCount - 1 do
      begin
        if FIsProcess = 0 then
          Break;
        // ===== SNAPSHOT 1 =====
        var LocalIndex := I;
        FileItem := FFileItemList[I];
        TThread.Queue(nil,
          procedure
          begin
            if FClosing then Exit;

            FIndex := LocalIndex;
            UpdateControls;
            pgbMain.Position := LocalIndex + 1;
          end);
        // ===== Working with Files =====
        FileExtractor := TFileExtractor.Create(FileItem.Path);
        try
          FileContent := FileExtractor.GetFileContent;
          AnalysisRecord := TAppServices.InitAIModel.AnalyzeContent(FileContent);
          // ===== SNAPSHOT 2 (UI) =====
          var LocalFileName := FileItem.FileName;
          var LocalTopic := AnalysisRecord.Topic;
          var LocalSummary := AnalysisRecord.Summary;
          var LocalKeywords := JoinString(AnalysisRecord.Keywords, ', ');
          TThread.Queue(nil,
            procedure
            begin
              if FClosing then Exit;
              memoLog.Lines.Add(Format('File: %d. %s', [LocalIndex + 1, LocalFileName]));
              memoLog.Lines.Add('Topic: ' + LocalTopic);
              memoLog.Lines.Add('Summary: ' + LocalSummary);
              memoLog.Lines.Add('Keywords: ' + LocalKeywords);
              memoLog.Lines.Add('');
            end);
        finally
          FileExtractor.Free;
        end;
      end;
      TThread.Queue(nil,
        procedure
        begin
          if FIsProcess = 0 then
          begin
            lblStatus.Caption := 'Status: Stopped';
          end
          else
          begin
            lblStatus.Caption := 'Status: Done';
            TInterlocked.Exchange(FIsProcess, 0);
          end;
          ChangeBtnToClose;
          btnBtn.Enabled := True;
        end);
    end
  );
end;

procedure TfmAnalysis.ChangeBtnToClose;
begin
  btnBtn.Caption := 'Close';
  btnBtn.ImageIndex := 1;
end;

end.
