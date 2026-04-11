unit uRecords;

interface

type
  TAnalysisRecord = record
    Summary: string;
    Topic: string;
    Keywords: TArray<string>;
  end;

  TExtFilterRecord = record
    Exts: TArray<string>;
    ShowOthers: Boolean;
  end;

implementation

end.
