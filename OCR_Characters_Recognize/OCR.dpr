program OCR;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  OCRUtils in 'OCRUtils.pas',
  UnitCompare in 'UnitCompare.pas' {CompareForm};

{$R *.res}
{$R WindowsXP.res}

begin
  Application.Initialize;
  Application.Title := 'OCR';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCompareForm, CompareForm);
  Application.Run;
end.
