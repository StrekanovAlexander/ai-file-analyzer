unit uMain;

interface

uses
  Windows, Messages,
  System.SysUtils, System.Generics.Collections, Variants,
  Classes, Graphics, System.JSON, System.IOUtils,
  Controls, Vcl.Forms, Dialogs, StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
  SVGIconImageListBase, SVGIconImageList, SVGIconImage,
  uGlobal, uConsts, uCLIRunner,
  uFolderScanner, uFileItem, uFileFilter,
  uFileListController, uStringUtils,
  uViewer, uAnalysis,
  uSummary,
  uWait, uAbout;

type
  TfmMain = class(TForm)
    pnlHeader: TPanel;
    pnlControls: TPanel;
    btnAnalyse: TBitBtn;
    stbMain: TStatusBar;
    lvwMain: TListView;
    svgBtns: TSVGIconImageList;
    btnBrowse: TBitBtn;
    svgExts: TSVGIconImageList;
    svgLogo: TSVGIconImage;
    lblLogo: TLabel;
    btnAbout: TBitBtn;
    bvlMain: TBevel;
    pnlPath: TPanel;
    edSourcePath: TEdit;
    pnlTools: TPanel;
    Shape2: TShape;
    chkTxt: TCheckBox;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape1: TShape;
    btnSave: TBitBtn;
    cbExport: TComboBox;
    chkPdf: TCheckBox;
    chkDocx: TCheckBox;
    chkJson: TCheckBox;
    chkOdt: TCheckBox;
    chkUnsupported: TCheckBox;
    btnPreview: TBitBtn;
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkDocxClick(Sender: TObject);
    procedure chkUnsupportedClick(Sender: TObject);
    procedure lvwMainDblClick(Sender: TObject);
    procedure lvwMainCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvwMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure btnAboutClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
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
    procedure ExportToCsv;
    procedure ExportToJson;
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
      begin
        edSourcePath.Text := OpenDialog.FileName;
        ShowWait('Scanning folder...');
        FFolderScanner.Start(edSourcePath.Text);
      end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfmMain.btnPreviewClick(Sender: TObject);
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

procedure TfmMain.btnSaveClick(Sender: TObject);
begin
  if IsListViewEmpty then
    Exit;
  if cbExport.ItemIndex = 0 then
    ExportToCsv
  else
    ExportToJson;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  CLIRunner := TCLIRunner.Create;
  FFolderScanner := TFolderScanner.Create;
  FFolderScanner.OnScanDone := OnScanDone;
  FFileListController := TFileListController.Create(lvwMain, stbMain);
  FFileFilter := TFileFilter.Create;
  FSortAsc := True;
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
  fmSummary: TfmSummary;
begin
  if IsListViewEmpty then
    Exit;
    Item := lvwMain.Selected;
    if not Assigned(Item) then Exit;
    FileItem := TFileItem(Item.Data);
    if not Assigned(FileItem) then Exit;
    if not FileItem.IsSupported then Exit;
    fmSummary := TfmSummary.Create(nil, FileItem);
    try
      fmSummary.ShowModal;
    finally
      fmSummary.Free;
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
    Item.SubItems[7] := AFileItem.Insight;
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

procedure TfmMain.ExportToCsv;
var
  SaveDialog: TFileSaveDialog;
  StringList: TStringList;
  ListItem: TListItem;
  Line: string;
begin
  SaveDialog := TFileSaveDialog.Create(Self);
  StringList := TStringList.Create;
  try
    SaveDialog.Title := 'Save results to CSV';
    SaveDialog.DefaultExtension := 'csv';
    SaveDialog.FileName := 'analysis_results.csv';
    SaveDialog.Options := SaveDialog.Options + [fdoOverWritePrompt];
    SaveDialog.FileTypes.Clear;
    SaveDialog.FileTypes.Add.FileMask := '*.csv';
    SaveDialog.FileTypes.Add.DisplayName := 'CSV files';
    if not SaveDialog.Execute then
      Exit;
    StringList.Add('File,Size,Extension,Modified,Status,Topic,Keywords,Summary,Insight,Folder');
    for var I := 0 to lvwMain.Items.Count - 1 do
    begin
      ListItem := lvwMain.Items[I];
      Line :=
        '"' + EscapeCSV(ListItem.Caption) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[0]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[1]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[2]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[3]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[4]) + '",' +
        '"' + EscapeCSV(NormalizeKeywords(ListItem.SubItems[5])) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[6]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[7]) + '",' +
        '"' + EscapeCSV(ListItem.SubItems[8]) + '"';
        StringList.Add(Line);
    end;
    StringList.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
  finally
    StringList.Free;
    SaveDialog.Free;
  end;
end;

procedure TfmMain.ExportToJson;
var
  SaveDialog: TFileSaveDialog;
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
  ListItem: TListItem;
  KeywordsArray: TJSONArray;
  Keywords: TArray<string>;
  K: string;
begin
  if IsListViewEmpty then
    Exit;
  SaveDialog := TFileSaveDialog.Create(Self);
  JsonArray := TJSONArray.Create;
  try
    SaveDialog.Title := 'Save results to JSON';
    SaveDialog.DefaultExtension := 'json';
    SaveDialog.FileName := 'analysis_results.json';
    SaveDialog.Options := SaveDialog.Options + [fdoOverWritePrompt];
    SaveDialog.FileTypes.Clear;
    SaveDialog.FileTypes.Add.FileMask := '*.json';
    SaveDialog.FileTypes.Add.DisplayName := 'JSON files';
    if not SaveDialog.Execute then
      Exit;
    for var I := 0 to lvwMain.Items.Count - 1 do
    begin
      ListItem := lvwMain.Items[I];
      JsonObject := TJSONObject.Create;
      JsonObject.AddPair('file', ListItem.Caption);
      JsonObject.AddPair('size', ListItem.SubItems[0]);
      JsonObject.AddPair('extension', ListItem.SubItems[1]);
      JsonObject.AddPair('modified', ListItem.SubItems[2]);
      JsonObject.AddPair('status', ListItem.SubItems[3]);
      JsonObject.AddPair('topic', ListItem.SubItems[4]);
      KeywordsArray := TJSONArray.Create;
      Keywords := SplitString(ListItem.SubItems[5], ',');
      for K in Keywords do
        KeywordsArray.Add(CleanQuotes(K));
      JsonObject.AddPair('keywords', KeywordsArray);
      JsonObject.AddPair('summary', ListItem.SubItems[6]);
      JsonObject.AddPair('insight', ListItem.SubItems[7]);
      JsonObject.AddPair('folder', ListItem.SubItems[8]);
      JsonArray.AddElement(JsonObject);
    end;
    TFile.WriteAllText(
      SaveDialog.FileName,
      JsonArray.Format(2).Replace('\/', '/'),
      TEncoding.UTF8
    );
  finally
    JsonArray.Free;
    SaveDialog.Free;
  end;
end;

end.
