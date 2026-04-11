unit uFolderScanner;

interface

uses
  System.Classes,
  uFileSystemService;

type
  TOnScanDone = procedure(Sender: TObject; FileList: TStringList) of object;
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
      FileList: TStringList;
    begin
      FileList := TFileSystemService.ScanFolder(APath);
      try
        TThread.Synchronize(nil,
          procedure
          begin
            try
              if Assigned(FOnScanDone) then
                FOnScanDone(Self, FileList)
              else
                FileList.Free;
            finally
              FThread := nil;
            end;
          end
        );
      except
        FileList.Free;
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
