unit uMain;

interface

uses
  Windows, Messages,
  System.SysUtils, System.Generics.Collections, Variants,
  Classes, Graphics,
  Controls, Vcl.Forms, Dialogs, StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
  SVGIconImageListBase, SVGIconImageList,
  uGlobal, uConsts, uCLIRunner, uAIModel, uAppServices,
  uFolderScanner, uFileItem, uFileFilter,
  uFileListController,
  uStringUtils,
  uViewer, uAnalysis, uWait;

type
  TfmMain = class(TForm)
    pnlHeader: TPanel;
    pnlControls: TPanel;
    btnAnalyse: TBitBtn;
    stbMain: TStatusBar;
    lvwMain: TListView;
    edSourcePath: TEdit;
    svgBtns: TSVGIconImageList;
    btnBrowse: TBitBtn;
    btnScan: TBitBtn;
    svgExts: TSVGIconImageList;
    pbProgressStatus: TProgressBar;
    splMain: TSplitter;
    memoOutput: TMemo;
    pnlFilters: TPanel;
    chkDOCX: TCheckBox;
    chkPDF: TCheckBox;
    chkODT: TCheckBox;
    chkTXT: TCheckBox;
    chkOTHERS: TCheckBox;
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure chkDOCXClick(Sender: TObject);
    procedure chkOTHERSClick(Sender: TObject);
    procedure lvwMainDblClick(Sender: TObject);
  private
    FAIModel: TAIModel;
    FFolderScanner: TFolderScanner;
    FFileListController: TFileListController;
    FWaitForm: TfmWait;
    FFileItemList: TObjectList<TFileItem>;
    FFileFilter: TFileFilter;
    procedure OnScanDone(Sender: TObject; FileItemList: TObjectList<TFileItem>);
    procedure ShowWait(const Msg: string);
    procedure HideWait;
    function GetFilteredFileItemList: TObjectList<TFileItem>;
  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAnalyseClick(Sender: TObject);
var FilteredFileItemList: TObjectList<TFileItem>;
begin
  FilteredFileItemList := GetFilteredFileItemList;
  if FilteredFileItemList.Count = 0 then
  begin
    ShowMessage('There are not files for analysis');
    Exit;
  end;

  fmAnalysis := TfmAnalysis.Create(nil, FilteredFileItemList);
  try
    fmAnalysis.ShowModal;
  finally
    FilteredFileItemList.Free;
    fmAnalysis.Free;
  end;

end;

procedure TfmMain.btnScanClick(Sender: TObject);
begin
  btnScan.Enabled := False;
  ShowWait('Scanning folder...');
  FFolderScanner.Start(edSourcePath.Text);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  CLIRunner := TCLIRunner.Create;
  { Folder scanning... }
  FFolderScanner := TFolderScanner.Create;
  FFolderScanner.OnScanDone := OnScanDone;
  {FileListController functional}
  FFileListController := TFileListController.Create(lvwMain, memoOutput, stbMain);
  edSourcePath.Text := 'D:\ai-organizer-examples';
  FFileFilter := TFileFilter.Create;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FFileFilter.Free;
  FFileListController.Free;
  FFolderScanner.Free;
  FFileItemList.Free;
  FAIModel.Free;
  CLIRunner.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  try
    FAIModel := TAppServices.InitAIModel;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Close;
    end;
  end;
end;

procedure TfmMain.lvwMainDblClick(Sender: TObject);
var
  Item: TListItem;
  FileItem: TFileItem;
begin
  Item := lvwMain.Selected;
  if not Assigned(Item) then Exit;
  FileItem := TFileItem(Item.Data);
  if not Assigned(FileItem) then Exit;
  if FileItem.Status = fsSkipped then Exit;
  fmViewer := TfmViewer.Create(nil, FileItem);
  try
    fmViewer.ShowModal;
  finally
    fmViewer.Free;
  end;
end;

procedure TfmMain.OnScanDone(Sender: TObject; FileItemList: TObjectList<TFileItem>);
begin
  try
    HideWait;
    FFileItemList := FileItemList;
    FFileListController.Bind(FFileItemList, FFileFilter);
  finally
    btnScan.Enabled := True;
  end;
end;

procedure TfmMain.ShowWait(const Msg: string);
begin
  FWaitForm := TfmWait.Create(nil);
  FWaitForm.lblMsg.Caption := Msg;
  FWaitForm.Show;
  FWaitForm.Update;
  Application.ProcessMessages;
end;

procedure TfmMain.HideWait;
begin
  if Assigned(FWaitForm) then
  begin
    FWaitForm.Close;
    FreeAndNil(FWaitForm);
  end;
end;

procedure TfmMain.chkDOCXClick(Sender: TObject);
var
  CheckBox: TCheckBox;
  Ext: string;
  ListItem: string;
begin
  CheckBox := (Sender as TCheckBox);
  Ext := CheckBox.Hint;
  if CheckBox.Checked then
    FFileFilter.Add(Ext)
  else
    FFileFilter.Remove(Ext);
  FFileListController.Bind(FFileItemList, FFileFilter);
end;

procedure TfmMain.chkOTHERSClick(Sender: TObject);
begin
  FFileFilter.ShowUnsupported := (Sender as TCheckBox).Checked;
  FFileListController.Bind(FFileItemList, FFileFilter);
end;

function TfmMain.GetFilteredFileItemList: TObjectList<TFileItem>;
var
  ListItem: TListItem;
  FileItem: TFileItem;
begin
  Result := TObjectList<TFileItem>.Create(False);
  for var I := 0 to lvwMain.Items.Count - 1 do
  begin
    ListItem := lvwMain.Items[I];
    if not Assigned(ListItem.Data) then
      Continue;
    FileItem := TFileItem(ListItem.Data);
    if FileItem.IsSupported then
      Result.Add(FileItem);
  end;
end;

end.
