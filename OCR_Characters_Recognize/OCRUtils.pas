unit OCRUtils;

interface

uses Graphics;

type
  TModel = array [1..100, 1..100] of Boolean;
  { Chaque �l�ment du tableau repr�sente un pixel - True si noir, False si blanc }

function CreateModel(Model: Char): TModel; overload
{ Cr�e un mod�le � partir d'un caract�re }

function CreateModel(Model: TBitmap): TModel; overload
{ Cr�e un mod�le � partir d'un bitmap }

function CompareModels(A, B: TModel): Integer;
{ Compare deux mod�les et indique le nombre de valeurs diff�rentes }

implementation

function CreateModel(Model: Char): TModel; { Cr�e un mod�le depuis un caract�re }
Var
 Bmp: TBitmap;
 I, J: Integer;
 W, H: Integer;
begin
 { On �crit avec une police dans un bitmap et on regarde les couleurs des pixels }
 Bmp := TBitmap.Create;
 Bmp.Width := 100;
 Bmp.Height := 100;
 Bmp.PixelFormat := pf1Bit;
 Bmp.Canvas.Font.Name := 'Arial';
 Bmp.Canvas.Font.Size := 72; { On cr�e le bitmap tampon ... on initialise ... }
 W := Bmp.Canvas.TextWidth(Model);
 H := Bmp.Canvas.TextHeight(Model);
 Bmp.Canvas.TextOut(50 - (W div 2), 50 - (H div 2), Model); { On �crit le caract�re au centre ... }
 for I := 0 to 99 do
  for J := 0 to 99 do { Si bitmap blanc, mod�le False, sinon, mod�le True }
   if Bmp.Canvas.Pixels[I, J] = clWhite then Result[I + 1, J + 1] := False else Result[I + 1, J + 1] := True;

 Bmp.Free;
end;

function CreateModel(Model: TBitmap): TModel; overload { Cr�e un mod�le depuis un bitmap }
Var
 I, J: Integer;
begin
 Model.Width := 100;
 Model.Height := 100;
 Model.PixelFormat := pf1Bit;
 for I := 0 to 99 do
  for J := 0 to 99 do { Si le bitmap est blanc, mod�le False, sinon, mod�le True }
   if Model.Canvas.Pixels[I, J] = clWhite then Result[I + 1, J + 1] := False else Result[I + 1, J + 1] := True;
end;

function CompareModels(A, B: TModel): Integer;
Var
 I, J: Integer;
begin
 Result := 0;
 for I := 1 to 100 do
  for J := 1 to 100 do
   begin
    { Si le mod�le dessin� n'a pas une zone du mod�le enregistr�, on enl�ve 100 points }
    if (A[I, J] = False) and (B[I, J] = True) then Dec(Result, 100);
    { Si le mod�le enregistr� n'a pas une zone du mod�le dessin�, on enl�ve 15 points }
    if (A[I, J] = True) and (B[I, J] = False) then Dec(Result, 15);
    { Si les deux mod�les ont la m�me zone colori�e en noir, on ajoute 100 points }
    if (A[I, J] = True) and (B[I, J] = True) then Inc(Result, 100);
   end;

 { On limite � 0 (pas d'int�r�t fonctionnel mais �a fait plus joli) }
 if Result < 0 then Result := 0;

 { Cet �quilibre de points permet de d�signer avec la plus grande pr�cision le caract�re
   que l'on a �crit. }
end;

end.