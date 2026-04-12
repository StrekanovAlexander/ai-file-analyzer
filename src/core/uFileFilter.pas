unit uFileFilter;

interface

uses
  System.SysUtils, System.Generics.Collections,
  uFileItem;

type TFileFilter = class
  private
    FExtList: TList<string>;
    function Contains(Ext: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property ExtList: TList<string> read FExtList;
    procedure Add(Ext: string);
    procedure Remove(Ext: string);
    function Accept(FileItem: TFileItem): Boolean;
end;

implementation

constructor TFileFilter.Create;
begin
  inherited Create;
  FExtList := TList<string>.Create;
end;

destructor TFileFilter.Destroy;
begin
  FExtList.Free;
  inherited;
end;

procedure TFileFilter.Add(Ext: string);
begin
  if not Contains(Ext) then
    FExtList.Add(Ext);
end;

procedure TFileFilter.Remove(Ext: string);
var
  I: Integer;
begin
  if Contains(Ext) then
  begin
    I := FExtList.IndexOf(Ext);
    FExtList.Delete(I);
  end;
end;

function TFileFilter.Accept(FileItem: TFileItem): Boolean;
begin
  if FExtList.Count = 0 then
    Exit(True);
  Result := Contains(FileItem.Ext);
end;

function TFileFilter.Contains(Ext: string): Boolean;
begin
  Result := FExtList.IndexOf(Ext) <> -1;
end;

end.
