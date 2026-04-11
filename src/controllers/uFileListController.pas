unit uFileListController;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.ComCtrls, Vcl.Forms, Vcl.StdCtrls, Vcl.Graphics,
  uConsts, uFileItem, uFileSystemService
;

type TFileListController = class
  private
    FListView: TListView;
    FMemoOutput: TMemo;
    FStatusBar: TStatusBar;
    FFilesForAnalyseCount: Integer;
    procedure Clear;
    procedure UpdateListItem(ListItem: TListItem);
    procedure UpdateStatusBar;
    procedure OnDraw(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    function FileStatusToStr(FileStatus: TFileStatus): string;
  public
    constructor Create(AListView: TListView; AMemoOutput: TMemo; AStatusBar: TStatusBar);
    destructor Destroy; override;
    procedure Bind(const FileList: TStrings);
  end;

implementation

constructor TFileListController.Create(AListView: TListView; AMemoOutput: TMemo; AStatusBar: TStatusBar);
begin
  inherited Create;
  FListView := AListView;
  FMemoOutput := AMemoOutput;
  FListView.OnAdvancedCustomDrawItem := OnDraw;
  FStatusBar := AStatusBar;
  FFilesForAnalyseCount := 0;
end;

destructor TFileListController.Destroy;
begin
  Clear;
  inherited;
end;

procedure TFileListController.Clear;
begin
  if not Assigned(FListView) then
    Exit;
  for var I := 0 to FListView.Items.Count - 1 do
    if Assigned(FListView.Items[I].Data) then
      TObject(FListView.Items[I].Data).Free;
  FListView.Clear;
end;

procedure TFileListController.Bind(const FileList: TStrings);
const
  SUBITEMS_COUNT = 6;
var
  ListItem: TListItem;
  FilePath: string;
  FileItem: TFileItem;
begin
  if not Assigned(FListView) then
    Exit;
  Clear;
  FFilesForAnalyseCount := 0;
  FListView.Items.BeginUpdate;
  try
    for var I := 0 to FileList.Count - 1 do
    begin
      FilePath := FileList[I];
      FileItem := TFileItem.Create(FilePath);
      ListItem := FListView.Items.Add;
      ListItem.Data := FileItem;
      if TFileSystemService.IsSupportedExt(FileItem.Ext) then
        Inc(FFilesForAnalyseCount);
      ListItem.ImageIndex := TFileSystemService.GetExtIndex(FileItem.Ext);
      for var J := 0 to SUBITEMS_COUNT do
        ListItem.SubItems.Add('');
      UpdateListItem(ListItem);
    end;
  finally
    FListView.Items.EndUpdate;
  end;
  UpdateStatusBar;
end;

function TFileListController.FileStatusToStr(FileStatus: TFileStatus): string;
begin
  case FileStatus of
    fsPending: Result := 'Pending';
    fsProcessing: Result := 'Processing';
    fsDone: Result := 'Done';
    fsError: Result := 'Error';
    fsSkipped: Result := 'Skipped';
  end;
end;

procedure TFileListController.UpdateListItem(ListItem: TListItem);
var
  FileItem: TFileItem;
begin
  if not Assigned(ListItem) then
    Exit;

  FileItem := TFileItem(ListItem.Data);
  if not Assigned(FileItem) then
    Exit;

  with ListItem do
  begin
    Caption := ExtractFileName(FileItem.Path);
    SubItems[0] := TFileSystemService.FormatFileSize(FileItem.Size);
    SubItems[1] := FileItem.Ext;
    SubItems[2] := DateTimeToStr(FileItem.LastModified);
    SubItems[3] := FileStatusToStr(FileItem.Status);
    SubItems[4] := FileItem.Topic;
    SubItems[5] := FileItem.Keywords;
    SubItems[6] := FileItem.Summary;
  end;
end;

procedure TFileListController.UpdateStatusBar;
begin
  FStatusBar.Panels[0].Text := Format('Files: %d', [FListView.Items.Count]);
  FStatusBar.Panels[1].Text := Format('Files for analyse: %d', [FFilesForAnalyseCount]);
end;

procedure TFileListController.OnDraw(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  FileItem: TFileItem;
begin
  if Stage <> cdPrePaint then
    Exit;
  FileItem := TFileItem(Item.Data);
  if not Assigned(FileItem) then
    Exit;
  if FileItem.Status = fsSkipped then
    Sender.Canvas.Font.Color := clGrayText
  else
    Sender.Canvas.Font.Color := clWindowText;
  DefaultDraw := True;
end;

end.
