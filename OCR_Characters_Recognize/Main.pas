{
 Pensez bien que les caractères sont enregistrés en Arial. Donc faites des caractères
  Arial. Reprenez-vous-y à plusieurs fois si vous n'y arrivez pas au début (faites un
  S, c'est le plus facile !
}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, OCRUtils;

type
  TModels = array [65..90] of TModel;
  { TModels est une liste des modèles des caractères qui sont utilisés ici }

  TMainForm = class(TForm)
    Menu: TMainMenu;
    AppHeader: TMenuItem;
    QuitMenu: TMenuItem;
    OCRPanel: TPanel;
    Img: TImage;
    ButtonPanel: TPanel;
    Button1: TButton;
    TextEdit: TEdit;
    TextLbl: TLabel;
    Button2: TButton;
    StatusLbl: TLabel;
    Button3: TButton;
    N1: TMenuItem;
    OptionsMenu: TMenuItem;
    ModelsHeader: TMenuItem;
    ShowModelMenu: TMenuItem;
    N2: TMenuItem;
    WeightMenu: TMenuItem;
    CenterCharMenu: TMenuItem;
    Gauge: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure QuitMenuClick(Sender: TObject);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShowModelMenuClick(Sender: TObject);
    procedure WeightMenuClick(Sender: TObject);
    procedure CenterCharMenuClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function CreateModels: TModels;
    { Crée une liste de modèles }
    procedure CenterChar;
    { Va centrer l'image du caractère }
    procedure BlendModel(Model: Char);
    { Dessine le modèle par-dessus le dessin pour bien montrer les points qui collent }
  end;

var
  MainForm: TMainForm;
  Models: TModels;
  Something: Boolean;

{ Note : seuls les caractères majuscules de A à Z sont pris en compte }
{ Mais l'on pourrait facilement extrapoler aux minuscules et aux nombres }
{ Mais pour la démonstration, autant faire simple ! }

{ Notez que cette démonstration inclut néanmoins un mécanisme de recentrage du caractère dessiné }
{ Notez également que l'on travaille en noir et blanc, donc chaque pixel prend 1 bit en mémoire }

implementation

uses UnitCompare;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
 DoubleBuffered := True;
 ButtonPanel.DoubleBuffered := True; { On évite les scintillements ... }
 OCRPanel.DoubleBuffered := True;
 Img.Canvas.Brush.Color := clBlack;
 Img.Canvas.Font.Name := 'Arial'; { On met la bonne police }
 Img.Canvas.Font.Size := 72;
 Models := CreateModels; { On crée tous les modèles enregistrés }
 Button3Click(self); { On efface l'image ! }
end;

procedure TMainForm.QuitMenuClick(Sender: TObject);
begin
 Close;
end;

function TMainForm.CreateModels: TModels;
Var
 I: Integer;
begin
 { Pour chaque caractère, on crée son modèle }
 for I := 65 to 90 do
  begin
   Result[I] := CreateModel(chr(I)); { Voilà ... }
   Application.ProcessMessages;
  end;
 StatusLbl.Caption := 'State: Ready!';
end;

procedure TMainForm.CenterChar;
Var
 MinX, MaxX, MinY, MaxY: Integer;
 I, J, W, H: Integer;
 Bmp: TBitmap;
begin
 if not CenterCharMenu.Checked then Exit;
 { Si on ne veut pas centrer, bye-bye ... }

 MaxX := 0;
 MaxY := 0; { On initialise }
 MinX := 100;
 MinY := 100;
 for I := 0 to 99 do
   for J := 0 to 99 do
    if Img.Canvas.Pixels[I, J] <> clWhite then
     begin { On va chercher à définir le rectangle du caractère dessiné }
      if I < MinX then MinX := I;
      if J < MinY then MinY := J;
      if I > MaxX then MaxX := I;
      if J > MaxY then MaxY := J;
     end;

 W := MaxX - MinX;  { On en déduit la hauteur et la largeur du caractère dessiné }
 H := MaxY - MinY;

 Bmp := TBitmap.Create;
 Bmp.Width := W + 1;
 Bmp.Height := H + 1; { On crée notre bitmap, on copie le caractère dessiné dedans ... }
 BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Img.Canvas.Handle, MinX, MinY, SRCCOPY);
 Button3Click(self); { On efface l'image }
 Img.Canvas.Draw(50 - (W + 2) div 2, 50 - (H + 4) div 2, Bmp);
 { On copie le bitmap dans l'image, au centre }
 Something := True; { Il y a quelque chose dans l'image }
 Bmp.Free; { On libère ! }
end;

procedure TMainForm.BlendModel(Model: Char);
Var
 Bmp: TBitmap;
 I, J: Integer;
 W, H: Integer;
begin
 Bmp := TBitmap.Create;
 Bmp.Width := 100;      { On crée un bitmap temporaire ... }
 Bmp.Height := 100;
 Bmp.Canvas.Brush.Style := bsClear;
 Bmp.Canvas.Font.Name := 'Arial';
 Bmp.Canvas.Font.Size := 72; { On prend les paramètres de police que les modèles }
 Bmp.Canvas.Font.Color := clRed;
 W := Bmp.Canvas.TextWidth(Model);
 H := Bmp.Canvas.TextHeight(Model); { On va faire en sorte de centrer le texte dans le bitmap }
 Bmp.Canvas.TextOut(50 - (W div 2), 50 - (H div 2), Model);
 for I := 0 to 99 do
  for J := 0 to 99 do { On va faire fondre le bitmap avec notre image }
   if Bmp.Canvas.Pixels[I, J] <> clWhite then
    case Img.Canvas.Pixels[I, J] of
     clWhite: Img.Canvas.Pixels[I, J] := clRed;
     clBlack: Img.Canvas.Pixels[I, J] := clGreen;
    end;

 { Si DESSIN = noir ET BITMAP = noir, alors on met en vert.
   SI DESSIN = blanc ET BITMAP = noir, alors on met en rouge.
   SI BITMAP = blanc, alors on ne change rien.
 }

 Bmp.Free;  { N'oublions pas de libérer ... }
end;

procedure TMainForm.Button1Click(Sender: TObject);
Var
 Model: TModel;
 I, J: Integer;
 C: String;
 Bmp: TBitmap;
 Similar: array [65..90] of Integer;
 Best, BestIndex: Integer;
begin
 for I := 1 to 26 do { On remplit tous les champs par défaut ... }
  begin
   CompareForm.List.Cells[0, I] := 'Character: ' + chr(I + 64);
   CompareForm.List.Cells[1, I] := '0';
  end;

 { Idem ... }
 CompareForm.List.Cells[0, 27] := 'Espace';
 CompareForm.List.Cells[1, 27] := '[default]';

 if Something then CenterChar { Si on a quelque chose dans l'image, on centre déjà l'image }
  else
   begin { Sinon, on sait tout de suite que c'est un espace ! }
    StatusLbl.Caption := 'State: Character: Espace.';
    TextEdit.Text := TextEdit.Text + ' ';
    CompareForm.List.Row := 27;
    Exit;
   end;

 Gauge.Max := 26;
 StatusLbl.Caption := 'State: Creation characters module ...';
 Application.ProcessMessages;
 sleep(1);
 Bmp := TBitmap.Create; { On crée un bitmap dans lequel on va copier notre image }
 Bmp.Width := 100;
 Bmp.Height := 100;
 Bmp.PixelFormat := pf1Bit;
 for I := 0 to 99 do
  for J := 0 to 99 do
   Bmp.Canvas.Pixels[I, J] := Img.Canvas.Pixels[I, J];

 Model := CreateModel(Bmp);  { On crée le modèle de l'image qu'on a dessinée }
 Bmp.Free;
 Gauge.Position := 1;
 StatusLbl.Caption := 'State: Logical compare modules ... ';
 Application.ProcessMessages;
 sleep(1);
 for I := 65 to 90 do  { Pour chaque modèle enregistré ... }
  begin
   Gauge.Position := I - 65;
   Application.ProcessMessages;
   Similar[I] := CompareModels(Model, Models[I]); { On récupère le poids de similitude entre les deux modèles }
   CompareForm.List.Cells[1, I - 64] := IntToStr(Similar[I]);
   { On l'affiche dans la fiche séparée }
  end;

 Best := 0; { On initialise les champs }
 BestIndex := -1;

 StatusLbl.Caption := 'State: Selection the best module ...';
 Application.ProcessMessages;
 sleep(1);

 for I := 65 to 90 do { On va chercher le plus grand poids, et récupérer son index au passage }
  if Similar[I] > Best then { Si plus grand ... }
   begin
    Best := Similar[I]; { Il prend sa place ! }
    BestIndex := I;
   end;

 if Best > 0 then { Si on a trouvé un caractère ... }
  begin
   CompareForm.List.Row := BestIndex - 64;
   C := '"' + chr(BestIndex) + '"'; { On formate le tout, on affiche ... }
   StatusLbl.Caption := 'State: Character recognized: ' + C + '.';
   TextEdit.Text := TextEdit.Text + chr(BestIndex); { On ajoute le caractère au texte }
   BlendModel(chr(BestIndex));
   { On affiche le modèle enregistré par-dessus le modèle dessiné }
  end
 else { Si aucun caractère trouvé ... }
  StatusLbl.Caption := 'State: Character not recognized.';

 Gauge.Position := 0; { On remet la jauge à 0 }
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
 { On remplit l'image de blanc, et on dit qu'il n'y a rien dedans (Something) }
 Img.Canvas.Brush.Color := clWhite;
 Img.Canvas.FillRect(Img.ClientRect);
 Something := False;
 Img.Canvas.Brush.Color := clBlack;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
 TextEdit.Text := ''; { On efface le texte }
end;

procedure TMainForm.ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if ssLeft in Shift then { Si l'on est en train d'appuyer sur le bouton gauche ... }
  begin
   Img.Canvas.Ellipse(X - 5, Y - 5, X + 5, Y + 5);
   Something := True; { Sert à indiquer qu'il y a quelque chose dans l'image }
  end;
end;

procedure TMainForm.ShowModelMenuClick(Sender: TObject);
Var
 S: String;
  W, H: Integer;
begin
 if InputQuery('Voir un modèle', 'Entrez le caractère dont vous voulez voir le modèle (caractères majuscules seulement) :', S) then
  begin
   S := Copy(S, 1, 1);
   if (S[1] in ['A'..'Z']) then
    begin
     { On dessine le caractère dans l'image après l'avoir nettoyée (l'image) }
     Button3Click(self);
     W := Img.Canvas.TextWidth(S);
     H := Img.Canvas.TextHeight(S);
     Img.Canvas.Brush.Style := bsClear;
     Img.Canvas.TextOut(50 - (W div 2), 50 - (H div 2), S);
     Something := True;
     Img.Canvas.Brush.Style := bsSolid;
    end;
  end;
end;

procedure TMainForm.WeightMenuClick(Sender: TObject);
begin
 { On affiche la fenêtre des poids si elle n'est pas déjà affichée, et on la place correctement }
 if CompareForm.Visible then Exit;
 CompareForm.Top := 100;
 CompareForm.Left := Left + Width + 50;
 CompareForm.Show;
 MainForm.FocusControl(nil);
end;

procedure TMainForm.CenterCharMenuClick(Sender: TObject);
begin
 CenterCharMenu.Checked := not CenterCharMenu.Checked;
end;

end.
