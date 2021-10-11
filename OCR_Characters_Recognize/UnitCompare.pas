unit UnitCompare;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TCompareForm = class(TForm)
    List: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  CompareForm: TCompareForm;

implementation

uses Main;

{$R *.dfm}

procedure TCompareForm.FormCreate(Sender: TObject);
begin
 Left := (Screen.Width div 2) + 288;
 Top := 100;
 DoubleBuffered := True;
 List.Cells[0, 0] := 'Compare module';
 List.Cells[1, 0] := 'Resemblance points';
end;

end.
