unit uFileListController;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.ComCtrls;

type
  TFilePointer = class
  public
    Path: string;
    constructor Create(const APath: string);
  end;

  TFileListController = class
  private
    FListView: TListView;
    procedure Clear;
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
begin
  if not Assigned(FListView) then
    Exit;
  Clear;
  FListView.Items.BeginUpdate;
  try
    for var I := 0 to FileList.Count - 1 do
    begin
      FilePath := FileList[I];
      Item := FListView.Items.Add;
      Item.Caption := ExtractFileName(FilePath);
      Item.SubItems.Add('');
      Item.SubItems.Add(ExtractFileExt(FilePath));
      Item.Data := TFilePointer.Create(FilePath);
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;

end.
