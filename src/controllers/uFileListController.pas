unit uFileListController;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.ComCtrls,
  uConsts,
  uFileItem,
  uFileSystemService;

type TFileListController = class
  private
    FListView: TListView;
    procedure Clear;
    function StatusToStr(Status: TFileStatus): string;
    procedure UpdateListItem(ListItem: TListItem);
    function GetIconIndex(const Ext: string): Integer;
  public
    constructor Create(AListView: TListView);
    destructor Destroy; override;
    procedure Bind(const FileList: TStrings);
  end;

implementation

constructor TFileListController.Create(AListView: TListView);
begin
  inherited Create;
  FListView := AListView;
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
  FListView.Items.BeginUpdate;
  try
    for var I := 0 to FileList.Count - 1 do
    begin
      FilePath := FileList[I];
      FileItem := TFileItem.Create(FilePath);
      ListItem := FListView.Items.Add;
      ListItem.Data := FileItem;
      ListItem.ImageIndex := GetIconIndex(FileItem.Ext);
      for var J := 0 to SUBITEMS_COUNT do
        ListItem.SubItems.Add('');
      UpdateListItem(ListItem);
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;

function TFileListController.StatusToStr(Status: TFileStatus): string;
begin
  case Status of
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
    SubItems[3] := StatusToStr(FileItem.Status);
    SubItems[4] := FileItem.Topic;
    SubItems[5] := FileItem.Keywords;
    SubItems[6] := FileItem.Summary;
  end;
end;

function TFileListController.GetIconIndex(const Ext: string): Integer;
begin
  if Ext = '.docx' then
    Result := 0
  else if Ext = '.pdf' then
    Result := 1
  else if Ext = '.odt' then
    Result := 2
  else if Ext = '.txt' then
    Result := 3
  else
    Result := 4;
end;

end.
