unit uFolderScanner;

interface

uses
  System.Classes, System.Generics.Collections,
  uFileItem, uFileSystemService;

type
  TOnScanDone = procedure(Sender: TObject; FileItemList: TObjectList<TFileItem>) of object;
  TFolderScanner = class
  private
    FThread: TThread;
    FOnScanDone: TOnScanDone;
  public
    property OnScanDone: TOnScanDone read FOnScanDone write FOnScanDone;
    procedure Start(const APath: string);
  end;

implementation

procedure TFolderScanner.Start(const APath: string);
begin
  if Assigned(FThread) then
    Exit;
  FThread := TThread.CreateAnonymousThread(
    procedure
    var
      FileItemList: TObjectList<TFileItem>;
    begin
      FileItemList := TFileSystemService.ScanFolder(APath);
      try
        TThread.Synchronize(nil,
          procedure
          begin
            try
              if Assigned(FOnScanDone) then
                FOnScanDone(Self, FileItemList)
              else
                FileItemList.Free;
            finally
              FThread := nil;
            end;
          end
        );
      except
        FileItemList.Free;
        TThread.Synchronize(nil,
          procedure
          begin
            FThread := nil;
          end
        );
        raise;
      end;
    end
  );
  FThread.FreeOnTerminate := True;
  FThread.Start;
end;

end.
