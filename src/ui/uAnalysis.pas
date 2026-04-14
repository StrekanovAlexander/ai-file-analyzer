unit uAnalysis;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.Threading, System.SyncObjs,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, SVGIconImageListBase, SVGIconImageList,
  uConsts, uAppServices, uRecords,
  uFileItem, uFileExtractor, uFileSystemService, uStringUtils, Vcl.ExtCtrls;

type
  TOnUpdateItem = procedure(AFileItem: TFileItem) of object;

  TfmAnalysis = class(TForm)
    svgBtns: TSVGIconImageList;
    memoLog: TMemo;
    pnlTop: TPanel;
    lblFileName: TLabel;
    lblFileSize: TLabel;
    lblStatus: TLabel;
    pnlProgress: TPanel;
    pgbMain: TProgressBar;
    lblProgress: TLabel;
    pnlBottom: TPanel;
    btnBtn: TBitBtn;
    procedure btnBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FFileItemList: TObjectList<TFileItem>;
    FIsProcess: Integer; // 1 = running, 0 = stopped
    FClosing: Boolean;
    FIndex: Integer;
    FFilesCount: Integer;
    FOnUpdateItem: TOnUpdateItem;
    procedure Start;
    procedure ChangeBtnToClose;
  public
    constructor Create(AOwner: TComponent;
      AFileItemList: TObjectList<TFileItem>;
      AOnUpdateItem: TOnUpdateItem); reintroduce;
    destructor Destroy; override;
  end;

var
  fmAnalysis: TfmAnalysis;

implementation

{$R *.dfm}

constructor TfmAnalysis.Create(AOwner: TComponent;
  AFileItemList: TObjectList<TFileItem>;
  AOnUpdateItem: TOnUpdateItem);
begin
  inherited  Create(AOwner);
  FOnUpdateItem := AOnUpdateItem;
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

procedure TfmAnalysis.Start;
begin
  TTask.Run(
    procedure
    var
      I: Integer;
      FileItem: TFileItem;
      FileExtractor: TFileExtractor;
      FileContent: string;
      AnalysisRecord: TAnalysisRecord;
      LogText: string;
    begin
      for I := 0 to FFilesCount - 1 do
      begin
        if FIsProcess = 0 then
          Exit;
        FileItem := FFileItemList[I];
        // 1. UI: mark processing (SYNC, not queue)
        TThread.Synchronize(nil,
          procedure
          begin
            if FClosing then Exit;
            FIndex := I;
            lblStatus.Caption := 'Processing...';
            lblFileName.Caption := FileItem.FileName;
            lblProgress.Caption := Format('%d / %d', [I + 1, FFilesCount]);
            pgbMain.Position := I + 1;
            memoLog.Lines.Add(Format('File %d: %s - Processing...',
              [I + 1, FileItem.FileName]));
          end);
        // 2. Work
        FileExtractor := TFileExtractor.Create(FileItem.Path);
        try
          FileContent := FileExtractor.GetFileContent;
          AnalysisRecord := TAppServices.InitAIModel.AnalyzeContent(FileContent);
          FileItem.Status := fsDone;
          FileItem.Topic := AnalysisRecord.Topic;
          FileItem.Summary := AnalysisRecord.Summary;
          FileItem.Keywords := JoinString(AnalysisRecord.Keywords, ', ');
          TThread.Synchronize(nil,
            procedure
            begin
              if FClosing then Exit;
              if Assigned(FOnUpdateItem) then
                FOnUpdateItem(FileItem);
            end);
        finally
          FileExtractor.Free;
        end;
        // 3. Prepare full result BEFORE UI
        LogText :=
          'Topic: ' + FileItem.Topic + sLineBreak +
          'Summary: ' + FileItem.Summary + sLineBreak +
          'Keywords: ' + FileItem.Keywords + sLineBreak;
        // 4. UI: final result (SYNC, atomic)
        TThread.Synchronize(nil,
          procedure
          begin
            if FClosing then Exit;
            memoLog.Lines.Add(Format('File %d: %s - Done',
              [I + 1, FileItem.FileName]));
            memoLog.Lines.Add(LogText);
            memoLog.Lines.Add('');
          end);
      end;
      // final state
      TThread.Synchronize(nil,
        procedure
        begin
          lblStatus.Caption := 'Done';
          btnBtn.Enabled := True;
          FIsProcess := 0;
          ChangeBtnToClose;
        end);
    end);
end;

procedure TfmAnalysis.ChangeBtnToClose;
begin
  btnBtn.Caption := 'Close';
  btnBtn.ImageIndex := 1;
end;

end.
