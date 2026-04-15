unit uAnalysis;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.Threading,
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
    FAnalysisState: TAnalysisState;
    FClosing: Boolean;
    FIndex: Integer;
    FFilesCount: Integer;
    FOnUpdateItem: TOnUpdateItem;
    FTask: ITask;
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
  inherited Create(AOwner);
  FOnUpdateItem := AOnUpdateItem;
  FFileItemList := AFileItemList;
  FAnalysisState := asRunning;
  FIndex := 0;
  FFilesCount := FFileItemList.Count;
  FClosing := False;
end;

destructor TfmAnalysis.Destroy;
begin
  FClosing := True;
  if Assigned(FTask) then
    FTask.Cancel;
  inherited;
end;

procedure TfmAnalysis.btnBtnClick(Sender: TObject);
begin
  if FAnalysisState = asRunning then
  begin
    FAnalysisState := asStopped;
    lblStatus.Caption := 'Status: Stopping...';
    btnBtn.Enabled := False;
  end
  else
    Close;
end;

procedure TfmAnalysis.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FAnalysisState <> asRunning;
end;

procedure TfmAnalysis.FormShow(Sender: TObject);
begin
  pgbMain.Min := 0;
  pgbMain.Max := FFilesCount;
  Start;
end;

procedure TfmAnalysis.Start;
begin
  FTask := TTask.Run(
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
        if (FAnalysisState = asStopped) or FClosing then
          Break;

        FileItem := FFileItemList[I];

        TThread.Synchronize(nil,
          procedure
          begin
            if FClosing then Exit;

            FIndex := I;
            lblFileName.Caption := Format('Analysing: %s', [FileItem.Path]);
            lblFileSize.Caption := Format('Size: %s',
              [TFileSystemService.FormatFileSize(FileItem.Size)]);
            lblStatus.Caption := 'Status: Processing...';
            lblProgress.Caption := Format('%d / %d', [I + 1, FFilesCount]);
            pgbMain.Position := I + 1;
            memoLog.Lines.Add(Format('File %d: %s - Processing...',
              [I + 1, FileItem.Path]));
          end);

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

        LogText :=
          'Topic: ' + FileItem.Topic + sLineBreak +
          'Summary: ' + FileItem.Summary + sLineBreak +
          'Keywords: ' + FileItem.Keywords + sLineBreak;

        TThread.Synchronize(nil,
          procedure
          begin
            if FClosing then Exit;
            memoLog.Lines.Add(Format('File %d: %s - Done',
              [I + 1, FileItem.Path]));
            memoLog.Lines.Add(LogText);
            memoLog.Lines.Add('');
          end);
      end;

      TThread.Synchronize(nil,
        procedure
        begin
          if FClosing then Exit;
          lblStatus.Caption := 'Status: Done';
          memoLog.Lines.Add('Done.');
          btnBtn.Enabled := True;
          FAnalysisState := asDone;
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
