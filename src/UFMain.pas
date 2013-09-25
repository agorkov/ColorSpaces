unit UFMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TForm1 = class(TForm)
    ImgOrigin: TImage;
    PageControl1: TPageControl;
    ImgRed: TImage;
    TSRGB: TTabSheet;
    ImgGreen: TImage;
    ImgBlue: TImage;
    TSCMYK: TTabSheet;
    ImgKey: TImage;
    ImgCyan: TImage;
    ImgMagenta: TImage;
    ImgYellow: TImage;
    TSHSI: TTabSheet;
    ImgHue: TImage;
    ImgSaturation: TImage;
    ImgIntensity: TImage;
    ImgRestore: TImage;
    TSYIQ: TTabSheet;
    ImgI: TImage;
    ImgQ: TImage;
    ImgY: TImage;
    BRGB: TButton;
    GBPixelMatching: TGroupBox;
    ImgDiff: TImage;
    BCMYK: TButton;
    BHSI: TButton;
    BYIQ: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image3: TImage;
    Image4: TImage;
    Edit1: TEdit;
    UpDown1: TUpDown;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ImgRestoreMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BRGBClick(Sender: TObject);
    procedure BCMYKClick(Sender: TObject);
    procedure BHSIClick(Sender: TObject);
    procedure BYIQClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure ImgOriginClick(Sender: TObject);
    procedure ImgRestoreDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Math, UPixelConvert;

const
  RowStep = 20;

procedure ColorToRGBClick;
var
  i, j: word;
  r, g, b: double;
begin
  with Form1 do
  begin
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgOrigin.Canvas.Pixels[i, j], r, g, b);
        ImgRed.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(r, r, r);
        ImgGreen.Canvas.Pixels[i, j] := RGBToColor(g, g, g);
        ImgBlue.Canvas.Pixels[i, j] := RGBToColor(b, b, b);

        if j mod RowStep = 0 then
        begin
          ImgRed.Refresh;
          ImgGreen.Refresh;
          ImgBlue.Refresh;
        end;
      end;
    ImgRed.Picture.SaveToFile('red.bmp');
    ImgGreen.Picture.SaveToFile('green.bmp');
    ImgBlue.Picture.SaveToFile('blue.bmp');
  end;
end;

procedure ColorToYIQClick;
var
  i, j: word;
  r, g, b: double;
  Y, Ii, Q: double;
begin
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      UPixelConvert.TColorToRGB(Form1.ImgOrigin.Canvas.Pixels[i, j], r, g, b);
      UPixelConvert.RGBToYIQ(r, g, b, Y, Ii, Q);
      Ii := (Ii + 0.595) / 1.191;
      Q := (Q + 0.523) / 1.045;
      Ii := UPixelConvert.NormalizationByte(Ii, Form1.UpDown1.Position) / 255;
      Q := UPixelConvert.NormalizationByte(Q, Form1.UpDown1.Position) / 255;
      Form1.ImgY.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(Y, Y, Y);
      Form1.ImgI.Canvas.Pixels[i, j] := RGBToColor(Ii, Ii, Ii);
      Form1.ImgQ.Canvas.Pixels[i, j] := RGBToColor(Q, Q, Q);

      if j mod RowStep = 0 then
      begin
        Form1.ImgY.Refresh;
        Form1.ImgI.Refresh;
        Form1.ImgQ.Refresh;
      end;
    end;
  Form1.ImgY.Picture.SaveToFile('Y.bmp');
  Form1.ImgI.Picture.SaveToFile('I.bmp');
  Form1.ImgQ.Picture.SaveToFile('Q.bmp');
end;

procedure HSIToColorClick;
var
  i, j: word;
  r, g, b: double;
  H, S, V: double;
begin
  with Form1 do
  begin
    ImgRestore.Canvas.Pen.Color := clWhite;
    ImgRestore.Canvas.Rectangle(0, 0, ImgRestore.Width, ImgRestore.Height);
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgHue.Canvas.Pixels[i, j], H, H, H);
        H := H * 360;
        TColorToRGB(ImgSaturation.Canvas.Pixels[i, j], S, S, S);
        TColorToRGB(ImgIntensity.Canvas.Pixels[i, j], V, V, V);
        UPixelConvert.HSIToRGB(r, g, b, H, S, V);
        ImgRestore.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(r, g, b);

        if j mod RowStep = 0 then
          ImgRestore.Refresh;
      end;
  end;
end;

procedure CompareImages;
var
  i, j: word;
begin
  Form1.ImgDiff.Canvas.Pen.Color := clWhite;
  Form1.ImgDiff.Canvas.Rectangle(0, 0, Form1.ImgDiff.Width, Form1.ImgDiff.Height);
  Form1.ImgDiff.Refresh;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      if Form1.ImgOrigin.Canvas.Pixels[i, j] = Form1.ImgRestore.Canvas.Pixels[i, j] then
        Form1.ImgDiff.Canvas.Pixels[i, j] := clWhite
      else
        Form1.ImgDiff.Canvas.Pixels[i, j] := clRed;
      if j mod RowStep = 0 then
        Form1.ImgDiff.Refresh;
    end;
end;

procedure RGBToColorClick;
var
  i, j: word;
  r, g, b: double;
begin
  with Form1 do
  begin
    ImgRestore.Canvas.Pen.Color := clWhite;
    ImgRestore.Canvas.Rectangle(0, 0, ImgRestore.Width, ImgRestore.Height);
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgRed.Canvas.Pixels[i, j], r, r, r);
        TColorToRGB(ImgGreen.Canvas.Pixels[i, j], g, g, g);
        TColorToRGB(ImgBlue.Canvas.Pixels[i, j], b, b, b);
        ImgRestore.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(r, g, b);
        if j mod RowStep = 0 then
          ImgRestore.Refresh;
      end;
  end;
end;

procedure YIQToColorClick;
var
  i, j: word;
  r, g, b: double;
  Y, Ii, Q: double;
begin
  Form1.ImgRestore.Canvas.Pen.Color := clWhite;
  Form1.ImgRestore.Canvas.Rectangle(0, 0, Form1.ImgRestore.Width, Form1.ImgRestore.Height);
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      UPixelConvert.TColorToRGB(Form1.ImgY.Canvas.Pixels[i, j], Y, Y, Y);
      TColorToRGB(Form1.ImgI.Canvas.Pixels[i, j], Ii, Ii, Ii);
      TColorToRGB(Form1.ImgQ.Canvas.Pixels[i, j], Q, Q, Q);
      Ii := (byte(round(Ii * 255)) and 248) / 255;
      Q := (byte(round(Q * 255)) and 248) / 255;
      Ii := Ii * 1.191 - 0.595;
      Q := Q * 1.045 - 0.523;
      UPixelConvert.YIQToRGB(r, g, b, Y, Ii, Q);
      Form1.ImgRestore.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(r, g, b);

      if j mod RowStep = 0 then
        Form1.ImgRestore.Refresh;
    end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ImgRestore.Canvas.Pen.Color := clWhite;
  ImgRestore.Canvas.Rectangle(0, 0, ImgRestore.Width, ImgRestore.Height);
  ImgDiff.Canvas.Pen.Color := clWhite;
  ImgDiff.Canvas.Rectangle(0, 0, ImgDiff.Width, ImgDiff.Height);

  ImgRed.Canvas.Pen.Color := clWhite;
  ImgRed.Canvas.Rectangle(0, 0, ImgRed.Width, ImgGreen.Height);
  ImgGreen.Canvas.Pen.Color := clWhite;
  ImgGreen.Canvas.Rectangle(0, 0, ImgGreen.Width, ImgGreen.Height);
  ImgBlue.Canvas.Pen.Color := clWhite;
  ImgBlue.Canvas.Rectangle(0, 0, ImgBlue.Width, ImgBlue.Height);

  ImgKey.Canvas.Pen.Color := clWhite;
  ImgKey.Canvas.Rectangle(0, 0, ImgKey.Width, ImgKey.Height);
  ImgCyan.Canvas.Pen.Color := clWhite;
  ImgCyan.Canvas.Rectangle(0, 0, ImgCyan.Width, ImgCyan.Height);
  ImgMagenta.Canvas.Pen.Color := clWhite;
  ImgMagenta.Canvas.Rectangle(0, 0, ImgMagenta.Width, ImgMagenta.Height);
  ImgYellow.Canvas.Pen.Color := clWhite;
  ImgYellow.Canvas.Rectangle(0, 0, ImgYellow.Width, ImgYellow.Height);

  ImgHue.Canvas.Pen.Color := clWhite;
  ImgHue.Canvas.Rectangle(0, 0, ImgHue.Width, ImgHue.Height);
  ImgSaturation.Canvas.Pen.Color := clWhite;
  ImgSaturation.Canvas.Rectangle(0, 0, ImgSaturation.Width, ImgSaturation.Height);
  ImgIntensity.Canvas.Pen.Color := clWhite;
  ImgIntensity.Canvas.Rectangle(0, 0, ImgIntensity.Width, ImgIntensity.Height);

  ImgY.Canvas.Pen.Color := clWhite;
  ImgY.Canvas.Rectangle(0, 0, ImgY.Width, ImgY.Height);
  ImgI.Canvas.Pen.Color := clWhite;
  ImgI.Canvas.Rectangle(0, 0, ImgI.Width, ImgI.Height);
  ImgQ.Canvas.Pen.Color := clWhite;
  ImgQ.Canvas.Rectangle(0, 0, ImgQ.Width, ImgQ.Height);
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

procedure TForm1.ImgOriginClick(Sender: TObject);
  function Resize(BM: TBitMap; H, W: word): TBitMap;
  var
    r: TBitMap;
  begin
    r := TBitMap.Create;
    r.Height := H;
    r.Width := W;
    r.Canvas.StretchDraw(Rect(0, 0, r.Width, r.Height), BM);
    Resize := r;
  end;

var
  BM: TBitMap;
begin
  if OpenPictureDialog1.Execute then
  begin
    BM := TBitMap.Create;
    BM.LoadFromFile(OpenPictureDialog1.FileName);
    BM := Resize(BM, ImgOrigin.Height, ImgOrigin.Width);
    ImgOrigin.Picture.Bitmap.Assign(BM);
    BM.Free;
  end;
end;

procedure TForm1.ImgRestoreDblClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
    ImgRestore.Picture.SaveToFile(SavePictureDialog1.FileName);
end;

procedure TForm1.ImgRestoreMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  r, g, b: byte;
begin
  Label1.Caption := 'x= ' + inttostr(X) + ' y= ' + inttostr(Y);
  r := ImgOrigin.Canvas.Pixels[X, Y];
  g := ImgOrigin.Canvas.Pixels[X, Y] shr 8;
  b := ImgOrigin.Canvas.Pixels[X, Y] shr 16;
  Label2.Caption := 'r=' + inttostr(r);
  Label3.Caption := 'g=' + inttostr(g);
  Label4.Caption := 'b=' + inttostr(b);
  Image3.Canvas.Pen.Color := RGB(r, g, b);
  Image3.Canvas.Brush.Color := RGB(r, g, b);
  Image3.Canvas.Brush.Style := bsSolid;
  Image3.Canvas.Rectangle(0, 0, Image3.Width, Image3.Height);
  r := ImgRestore.Canvas.Pixels[X, Y];
  g := ImgRestore.Canvas.Pixels[X, Y] shr 8;
  b := ImgRestore.Canvas.Pixels[X, Y] shr 16;
  Label5.Caption := 'r=' + inttostr(r);
  Label6.Caption := 'g=' + inttostr(g);
  Label7.Caption := 'b=' + inttostr(b);
  Image4.Canvas.Pen.Color := RGB(r, g, b);
  Image4.Canvas.Brush.Color := RGB(r, g, b);
  Image4.Canvas.Brush.Style := bsSolid;
  Image4.Canvas.Rectangle(0, 0, Image4.Width, Image4.Height);
end;

procedure ColorToCMYKClick;
var
  i, j: word;
  r, g, b: double;
  C, M, Y, K: double;
begin
  with Form1 do
  begin
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgOrigin.Canvas.Pixels[i, j], r, g, b);
        UPixelConvert.RGBToCMYK(r, g, b, C, M, Y, K);
        ImgKey.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(K, K, K);
        ImgCyan.Canvas.Pixels[i, j] := RGBToColor(C, C, C);
        ImgMagenta.Canvas.Pixels[i, j] := RGBToColor(M, M, M);
        ImgYellow.Canvas.Pixels[i, j] := RGBToColor(Y, Y, Y);
        if j mod RowStep = 0 then
        begin
          ImgKey.Refresh;
          ImgCyan.Refresh;
          ImgMagenta.Refresh;
          ImgYellow.Refresh;
        end;
      end;
    ImgKey.Picture.SaveToFile('key.bmp');
    ImgCyan.Picture.SaveToFile('cyan.bmp');
    ImgMagenta.Picture.SaveToFile('magenta.bmp');
    ImgYellow.Picture.SaveToFile('yellow.bmp');
  end;
end;

procedure ColorToHSIClick;
var
  i, j: word;
  r, g, b: double;
  H, S, V: double;
begin
  with Form1 do
  begin
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgOrigin.Canvas.Pixels[i, j], r, g, b);
        UPixelConvert.RGBToHSI(r, g, b, H, S, V);
        ImgHue.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(H / 360, H / 360, H / 360);
        ImgSaturation.Canvas.Pixels[i, j] := RGBToColor(S, S, S);
        ImgIntensity.Canvas.Pixels[i, j] := RGBToColor(V, V, V);

        if j mod RowStep = 0 then
        begin
          ImgHue.Refresh;
          ImgSaturation.Refresh;
          ImgIntensity.Refresh;
        end;
      end;
    ImgHue.Picture.SaveToFile('hue.bmp');
    ImgSaturation.Picture.SaveToFile('saturation.bmp');
    ImgIntensity.Picture.SaveToFile('intensity.bmp');
  end;
end;

procedure CMYKToColorClick;
var
  i, j: word;
  r, g, b: double;
  C, M, Y, K: double;
begin
  with Form1 do
  begin
    ImgRestore.Canvas.Pen.Color := clWhite;
    ImgRestore.Canvas.Rectangle(0, 0, ImgRestore.Width, ImgRestore.Height);
    for j := 0 to ImgOrigin.Height do
      for i := 0 to ImgOrigin.Width do
      begin
        UPixelConvert.TColorToRGB(ImgKey.Canvas.Pixels[i, j], K, K, K);
        TColorToRGB(ImgCyan.Canvas.Pixels[i, j], C, C, C);
        TColorToRGB(ImgMagenta.Canvas.Pixels[i, j], M, M, M);
        TColorToRGB(ImgYellow.Canvas.Pixels[i, j], Y, Y, Y);
        UPixelConvert.CMYKToRGB(r, g, b, C, M, Y, K);
        ImgRestore.Canvas.Pixels[i, j] := UPixelConvert.RGBToColor(r, g, b);

        if j mod RowStep = 0 then
          ImgRestore.Refresh;
      end;
  end;
end;

procedure TForm1.BRGBClick(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  ColorToRGBClick;
  RGBToColorClick;
  CompareImages;
end;

procedure TForm1.BCMYKClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;
  ColorToCMYKClick;
  CMYKToColorClick;
  CompareImages;
end;

procedure TForm1.BHSIClick(Sender: TObject);
begin
  PageControl1.TabIndex := 2;
  ColorToHSIClick;
  HSIToColorClick;
  CompareImages;
end;

procedure TForm1.BYIQClick(Sender: TObject);
begin
  PageControl1.TabIndex := 3;
  ColorToYIQClick;
  YIQToColorClick;
  CompareImages;
end;

end.
