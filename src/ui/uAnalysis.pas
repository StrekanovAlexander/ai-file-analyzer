unit uAnalysis;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.Threading,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, SVGIconImageListBase, SVGIconImageList,
  uFileItem,
  uFileSystemService
;

type
  TfmAnalysis = class(TForm)
    lblFileName: TLabel;
    lblFileSize: TLabel;
    lblStatus: TLabel;
    lblProgress: TLabel;
    pgbMain: TProgressBar;
    btnBtn: TBitBtn;
    svgBtns: TSVGIconImageList;
    procedure btnBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFileItemList: TObjectList<TFileItem>;
    FIsProcess: Boolean;
    FIndex: Integer;
    FFilesCount: Integer;
    procedure Start;
    procedure UpdateControls;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AFileItemList: TObjectList<TFileItem>); reintroduce;
  end;

var
  fmAnalysis: TfmAnalysis;

implementation

{$R *.dfm}

procedure TfmAnalysis.btnBtnClick(Sender: TObject);
begin
  if FIsProcess then
  begin
    FIsProcess := False;
    btnBtn.Caption := 'Close';
    btnBtn.ImageIndex := 1;
  end
  else
    Close;
end;

constructor TfmAnalysis.Create(AOwner: TComponent; AFileItemList: TObjectList<TFileItem>);
begin
  inherited  Create(AOwner);
  FFileItemList := AFileItemList;
  FIsProcess := True;
  FIndex := 0;
  FFilesCount := FFileItemList.Count;
end;

procedure TfmAnalysis.FormShow(Sender: TObject);
begin
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
begin
  TTask.Run(
    procedure
    begin
      for var I := 0 to FFilesCount - 1 do
      begin
        if not FIsProcess then
          Break;
        FIndex := I;
        TThread.Queue(nil,
          procedure
          begin
            UpdateControls;
            pgbMain.Position := FIndex + 1;
          end);
        Sleep(1000);
      end;
      TThread.Queue(nil,
        procedure
        begin
          lblStatus.Caption := 'Status: Done';
          FIsProcess := False;
          btnBtn.Caption := 'Close';
          btnBtn.ImageIndex := 1;
        end);
    end
  );
end;

end.
