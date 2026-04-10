unit uFileListController;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  Vcl.ComCtrls,
  uConsts,
  uFileSystemService;

type
  TFilePointer = class
  public
    Path: string;
    Ext: string;
    Size: Int64;
    LastModified: TDateTime;
    Status: TFileStatus;
    constructor Create(const APath: string);
  end;

  TFileListController = class
  private
    FListView: TListView;
    procedure Clear;
    function StatusToStr(Status: TFileStatus): string;
  public
    constructor Create(AListView: TListView);
    destructor Destroy; override;
    procedure Bind(const FileList: TStrings);
  end;

implementation

{ TFilePointer }
constructor TFilePointer.Create(const APath: string);
begin
  inherited Create;
  Path := APath;
  Ext := ExtractFileExt(APath);
  Size := TFile.GetSize(APath);
  LastModified := TFile.GetLastWriteTime(APath);
  if (Ext = '.txt') or (Ext = '.pdf') or (Ext = '.docx') or (Ext = '.odt') then
    Status := fsPending
  else
    Status := fsSkipped;
end;

{ TFileListController }
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
var
  Item: TListItem;
  FilePath: string;
  FilePointer: TFilePointer;
begin
  if not Assigned(FListView) then
    Exit;
  Clear;
  FListView.Items.BeginUpdate;
  try
    for var I := 0 to FileList.Count - 1 do
    begin
      FilePath := FileList[I];
      FilePointer := TFilePointer.Create(FilePath);
      Item := FListView.Items.Add;
      Item.Caption := ExtractFileName(FilePath);
      Item.SubItems.Add(TFileSystemService.FormatFileSize(FilePointer.Size));
      Item.SubItems.Add(FilePointer.Ext);
      Item.SubItems.Add(DateTimeToStr(FilePointer.LastModified));
      Item.SubItems.Add(StatusToStr(FilePointer.Status));
      Item.Data := FilePointer;
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

end.
