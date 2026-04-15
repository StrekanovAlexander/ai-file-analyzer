unit uConsts;

interface

type
  TFileStatus = (
    fsPending,
    fsProcessing,
    fsDone,
    fsError,
    fsSkipped
  );

  TAnalysisState = (asRunning, asStopped, asDone);

const
  SUPPORTED_EXTS: array[0..4] of string = ('.docx', '.pdf', '.odt', '.txt', '.json');

implementation

end.
