unit uMain;

interface

uses
  Windows, Messages,
  System.SysUtils, System.Generics.Collections, Variants,
  Classes, Graphics,
  Controls, Vcl.Forms, Dialogs, StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
  SVGIconImageListBase, SVGIconImageList, SVGIconImage,
  uGlobal, uConsts, uCLIRunner,
  uFolderScanner, uFileItem, uFileFilter,
  uFileListController, uStringUtils,
  uViewer, uAnalysis, uWait, uAbout;

type
  TfmMain = class(TForm)
    pnlHeader: TPanel;
    pnlControls: TPanel;
    btnAnalyse: TBitBtn;
    stbMain: TStatusBar;
    lvwMain: TListView;
    svgBtns: TSVGIconImageList;
    btnBrowse: TBitBtn;
    btnScan: TBitBtn;
    svgExts: TSVGIconImageList;
    pnlFilters: TPanel;
    chkDocx: TCheckBox;
    chkPdf: TCheckBox;
    chkOdt: TCheckBox;
    chkTxt: TCheckBox;
    chkUnsupported: TCheckBox;
    svgLogo: TSVGIconImage;
    lblLogo: TLabel;
    btnAbout: TBitBtn;
    bvlMain: TBevel;
    pnlPath: TPanel;
    edSourcePath: TEdit;
    bvlPdf: TBevel;
    bvlDocx: TBevel;
    bvlTxt: TBevel;
    bvlOdt: TBevel;
    bvlOther: TBevel;
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure chkDocxClick(Sender: TObject);
    procedure chkUnsupportedClick(Sender: TObject);
    procedure lvwMainDblClick(Sender: TObject);
    procedure lvwMainCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvwMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure btnAboutClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    FFolderScanner: TFolderScanner;
    FFileListController: TFileListController;
    FWaitForm: TfmWait;
    FFileItemList: TObjectList<TFileItem>;
    FFileFilter: TFileFilter;
    FSortColumn: Integer;
    FSortAsc: Boolean;
    procedure OnScanDone(Sender: TObject; var FileItemList: TObjectList<TFileItem>);
    procedure ShowWait(const Msg: string);
    procedure HideWait;
    procedure UpdateListViewItem(AFileItem: TFileItem);
    function GetFilteredFileItemList: TObjectList<TFileItem>;
    function IsListViewEmpty: Boolean;
    procedure ClearData;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAboutClick(Sender: TObject);
var fmAbout: TfmAbout;
begin
  fmAbout := TfmAbout.Create(nil);
  try
    fmAbout.ShowModal;
  finally
    fmAbout.Free;
  end;
end;

procedure TfmMain.btnAnalyseClick(Sender: TObject);
var FilteredFileItemList: TObjectList<TFileItem>;
begin
  if IsListViewEmpty then
    Exit;
  FilteredFileItemList := GetFilteredFileItemList;
  if FilteredFileItemList.Count = 0 then
  begin
    ShowMessage('There are not files for analysis');
    Exit;
  end;

  fmAnalysis := TfmAnalysis.Create(nil, FilteredFileItemList, UpdateListViewItem);
  try
    fmAnalysis.ShowModal;
  finally
    FilteredFileItemList.Free;
    fmAnalysis.Free;
    lvwMain.Invalidate;
  end;
end;

procedure TfmMain.btnBrowseClick(Sender: TObject);
var OpenDialog: TFileOpenDialog;
begin
  ClearData;
  OpenDialog := TFileOpenDialog.Create(Self);
  try
    OpenDialog.Title := 'Select source folder';
    OpenDialog.Options := OpenDialog.Options + [fdoPickFolders];
    if OpenDialog.Execute then
      edSourcePath.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
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
  FFolderScanner := TFolderScanner.Create;
  FFolderScanner.OnScanDone := OnScanDone;
  FFileListController := TFileListController.Create(lvwMain, stbMain);
  edSourcePath.Text := 'D:\ai-alanysis-examples';
  FFileFilter := TFileFilter.Create;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FFileFilter.Free;
  FFileListController.Free;
  FFolderScanner.Free;
  FFileItemList.Free;
  CLIRunner.Free;
end;

procedure TfmMain.lvwMainColumnClick(Sender: TObject; Column: TListColumn);
begin
  if IsListViewEmpty then
    Exit;
  if FSortColumn = Column.Index then
    FSortAsc := not FSortAsc
  else
  begin
    FSortColumn := Column.Index;
    FSortAsc := True;
  end;
  lvwMain.AlphaSort;
end;

procedure TfmMain.lvwMainCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  S1, S2: string;
begin
  if FSortColumn = 0 then
  begin
    S1 := Item1.Caption;
    S2 := Item2.Caption;
  end
  else
  begin
    S1 := Item1.SubItems[FSortColumn - 1];
    S2 := Item2.SubItems[FSortColumn - 1];
  end;
  Compare := CompareText(S1, S2);
  if not FSortAsc then
    Compare := -Compare;
end;

procedure TfmMain.lvwMainDblClick(Sender: TObject);
var
  Item: TListItem;
  FileItem: TFileItem;
begin
  if IsListViewEmpty then
    Exit;
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

procedure TfmMain.OnScanDone(Sender: TObject; var FileItemList: TObjectList<TFileItem>);
begin
  try
    HideWait;
    FFileItemList := FileItemList;
    FileItemList := nil;
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

procedure TfmMain.chkDocxClick(Sender: TObject);
var
  CheckBox: TCheckBox;
  Ext: string;
begin
  if IsListViewEmpty then
    Exit;
  CheckBox := (Sender as TCheckBox);
  Ext := CheckBox.Hint;
  if CheckBox.Checked then
    FFileFilter.Add(Ext)
  else
    FFileFilter.Remove(Ext);
  FFileListController.Bind(FFileItemList, FFileFilter);
end;

procedure TfmMain.chkUnsupportedClick(Sender: TObject);
begin
  if IsListViewEmpty then
    Exit;
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

procedure TfmMain.UpdateListViewItem(AFileItem: TFileItem);
var
  I: Integer;
  Item: TListItem;
begin
  for I := 0 to lvwMain.Items.Count - 1 do
  begin
    Item := lvwMain.Items[I];
    if Item.Data <> AFileItem then
      Continue;
    Item.SubItems[3] := FileStatusToStr(AFileItem.Status);
    Item.SubItems[4] := AFileItem.Topic;
    Item.SubItems[5] := AFileItem.Keywords;
    Item.SubItems[6] := AFileItem.Summary;
    Item.Update;
    Exit;
  end;
end;

function TfmMain.IsListViewEmpty: Boolean;
begin
  Result := (lvwMain.Items.Count = 0);
end;

procedure TfmMain.ClearData;
begin
  lvwMain.Items.BeginUpdate;
  try
    lvwMain.Items.Clear;
  finally
    lvwMain.Items.EndUpdate;
  end;
  FreeAndNil(FFileItemList);
end;

end.
