unit uFileReader;

interface

uses
  System.Classes,
  uFileExtractor;

type
  TOnReadDone = procedure(Sender: TObject; FileContent: string) of object;

  TFileReader = class
  private
    FThread: TThread;
    FOnReadDone: TOnReadDone;
  public
    property OnReadDone: TOnReadDone read FOnReadDone write FOnReadDone;
    procedure Start(const APath: string);
  end;

implementation

procedure TFileReader.Start(const APath: string);
begin
  if Assigned(FThread) then
    Exit;

  FThread := TThread.CreateAnonymousThread(
    procedure
    var
      FileContent: string;
      FileExtractor: TFileExtractor;
    begin
      try
        FileExtractor := TFileExtractor.Create(APath);
        try
          FileContent := FileExtractor.GetFileContent;
        finally
          FileExtractor.Free;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            if Assigned(FOnReadDone) then
              FOnReadDone(Self, FileContent);
          end);

      finally
        FThread := nil;
      end;
    end
  );

  FThread.FreeOnTerminate := True;
  FThread.Start;
end;

end.
