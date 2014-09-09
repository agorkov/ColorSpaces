unit UFMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TFMain = class(TForm)
    ImgOrigin: TImage;
    PCColorSpaces: TPageControl;
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
    ImgRestored: TImage;
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
    LPosition: TLabel;
    LROrigin: TLabel;
    LGOrigin: TLabel;
    LBOrigin: TLabel;
    LRRestored: TLabel;
    LGRestored: TLabel;
    LBRestored: TLabel;
    ImgOriginTest: TImage;
    ImgRestoredTest: TImage;
    RGVertical: TRadioGroup;
    RGHorizontal: TRadioGroup;
    OPD: TOpenPictureDialog;
    procedure ImgRestoredMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BRGBClick(Sender: TObject);
    procedure BCMYKClick(Sender: TObject);
    procedure BHSIClick(Sender: TObject);
    procedure BYIQClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure ImgOriginClick(Sender: TObject);
    procedure RGVerticalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses
  Math, UPixelConvert;

const
  RowStep = 10;

procedure ColorToRGBClick;
var
  i, j: word;
  o: TColorPixel;
  BM, BMRed, BMGreen, BMBlue: TBitmap;
begin
  BM := TBitmap.Create;
  BM.Assign(FMain.ImgOrigin.Picture);
  BMRed := TBitmap.Create;
  BMRed.Height := BM.Height;
  BMRed.Width := BM.Width;
  BMGreen := TBitmap.Create;
  BMGreen.Height := BM.Height;
  BMGreen.Width := BM.Width;
  BMBlue := TBitmap.Create;
  BMBlue.Height := BM.Height;
  BMBlue.Width := BM.Width;
  o := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BM.Canvas.Pixels[i, j]);
      BMRed.Canvas.Pixels[i, j] := RGB(round(o.GetRed * 255),
        round(o.GetRed * 255), round(o.GetRed * 255));
      BMGreen.Canvas.Pixels[i, j] := RGB(round(o.GetGreen * 255),
        round(o.GetGreen * 255), round(o.GetGreen * 255));
      BMBlue.Canvas.Pixels[i, j] := RGB(round(o.GetBlue * 255),
        round(o.GetBlue * 255), round(o.GetBlue * 255));
    end;
  FMain.ImgRed.Picture.Assign(BMRed);
  FMain.ImgGreen.Picture.Assign(BMGreen);
  FMain.ImgBlue.Picture.Assign(BMBlue);
  BM.Free;
  BMRed.Free;
  BMGreen.Free;
  BMBlue.Free;
  o.Free;
  FMain.Refresh;
end;

procedure RGBToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
  BM, BMRed, BMGreen, BMBlue: TBitmap;
begin
  BMRed := TBitmap.Create;
  BMRed.Assign(FMain.ImgRed.Picture);
  BMGreen := TBitmap.Create;
  BMGreen.Assign(FMain.ImgGreen.Picture);
  BMBlue := TBitmap.Create;
  BMBlue.Assign(FMain.ImgBlue.Picture);
  BM := TBitmap.Create;
  BM.Height := BMRed.Height;
  BM.Width := BMRed.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BMRed.Canvas.Pixels[i, j]);
      r.SetRed(o.GetRed);
      o.SetFullColor(BMGreen.Canvas.Pixels[i, j]);
      r.SetGreen(o.GetRed);
      o.SetFullColor(BMBlue.Canvas.Pixels[i, j]);
      r.SetBlue(o.GetRed);
      BM.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  FMain.ImgRestored.Picture.Assign(BM);
  BM.Free;
  BMRed.Free;
  BMGreen.Free;
  BMBlue.Free;
  FMain.Refresh;
end;

procedure ColorToCMYKClick;
var
  i, j: word;
  o: TColorPixel;
  BM, BMCyan, BMMagenta, BMYellow, BMKeyColor: TBitmap;
begin
  BM := TBitmap.Create;
  BM.Assign(FMain.ImgOrigin.Picture);
  BMCyan := TBitmap.Create;
  BMCyan.Height := BM.Height;
  BMCyan.Width := BM.Width;
  BMMagenta := TBitmap.Create;
  BMMagenta.Height := BM.Height;
  BMMagenta.Width := BM.Width;
  BMYellow := TBitmap.Create;
  BMYellow.Height := BM.Height;
  BMYellow.Width := BM.Width;
  BMKeyColor := TBitmap.Create;
  BMKeyColor.Height := BM.Height;
  BMKeyColor.Width := BM.Width;
  o := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BM.Canvas.Pixels[i, j]);
      BMCyan.Canvas.Pixels[i, j] := RGB(round(o.GetCyan * 255),
        round(o.GetCyan * 255), round(o.GetCyan * 255));
      BMMagenta.Canvas.Pixels[i, j] := RGB(round(o.GetMagenta * 255),
        round(o.GetMagenta * 255), round(o.GetMagenta * 255));
      BMYellow.Canvas.Pixels[i, j] := RGB(round(o.GetYellow * 255),
        round(o.GetYellow * 255), round(o.GetYellow * 255));
      BMKeyColor.Canvas.Pixels[i, j] := RGB(round(o.GetKeyColor * 255),
        round(o.GetKeyColor * 255), round(o.GetKeyColor * 255));
    end;
  FMain.ImgCyan.Picture.Assign(BMCyan);
  FMain.ImgMagenta.Picture.Assign(BMMagenta);
  FMain.ImgYellow.Picture.Assign(BMYellow);
  FMain.ImgKey.Picture.Assign(BMKeyColor);
  BM.Free;
  BMCyan.Free;
  BMMagenta.Free;
  BMYellow.Free;
  BMKeyColor.Free;
  o.Free;
  FMain.Refresh;
end;

procedure CMYKToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
  BM, BMCyan, BMMagenta, BMYellow, BMKeyColor: TBitmap;
begin
  BMCyan := TBitmap.Create;
  BMCyan.Assign(FMain.ImgCyan.Picture);
  BMMagenta := TBitmap.Create;
  BMMagenta.Assign(FMain.ImgMagenta.Picture);
  BMYellow := TBitmap.Create;
  BMYellow.Assign(FMain.ImgYellow.Picture);
  BMKeyColor := TBitmap.Create;
  BMKeyColor.Assign(FMain.ImgKey.Picture);
  BM := TBitmap.Create;
  BM.Height := BMCyan.Height;
  BM.Width := BMCyan.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BMCyan.Canvas.Pixels[i, j]);
      r.SetCyan(o.GetRed);
      o.SetFullColor(BMMagenta.Canvas.Pixels[i, j]);
      r.SetMagenta(o.GetRed);
      o.SetFullColor(BMYellow.Canvas.Pixels[i, j]);
      r.SetYellow(o.GetRed);
      o.SetFullColor(BMKeyColor.Canvas.Pixels[i, j]);
      r.SetKeyColor(o.GetRed);

      BM.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  FMain.ImgRestored.Picture.Assign(BM);
  BM.Free;
  BMCyan.Free;
  BMMagenta.Free;
  BMYellow.Free;
  BMKeyColor.Free;
  FMain.Refresh;
end;

procedure ColorToHSIClick;
var
  i, j: word;
  o: TColorPixel;
  BM, BMHue, BMSaturation, BMIntensity: TBitmap;
begin
  BM := TBitmap.Create;
  BM.Assign(FMain.ImgOrigin.Picture);
  BMHue := TBitmap.Create;
  BMHue.Height := BM.Height;
  BMHue.Width := BM.Width;
  BMSaturation := TBitmap.Create;
  BMSaturation.Height := BM.Height;
  BMSaturation.Width := BM.Width;
  BMIntensity := TBitmap.Create;
  BMIntensity.Height := BM.Height;
  BMIntensity.Width := BM.Width;
  o := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BM.Canvas.Pixels[i, j]);
      BMHue.Canvas.Pixels[i, j] := RGB(round(255 * o.GetHue / 360),
        round(255 * o.GetHue / 360), round(255 * o.GetHue / 360));
      BMSaturation.Canvas.Pixels[i, j] := RGB(round(o.GetSaturation * 255),
        round(o.GetSaturation * 255), round(o.GetSaturation * 255));
      BMIntensity.Canvas.Pixels[i, j] := RGB(round(o.GetIntensity * 255),
        round(o.GetIntensity * 255), round(o.GetIntensity * 255));
    end;
  o.Free;
  FMain.ImgHue.Picture.Assign(BMHue);
  FMain.ImgSaturation.Picture.Assign(BMSaturation);
  FMain.ImgIntensity.Picture.Assign(BMIntensity);
  BM.Free;
  BMHue.Free;
  BMSaturation.Free;
  BMIntensity.Free;
  FMain.Refresh;
end;

procedure HSIToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
  BM, BMHue, BMSaturation, BMIntensity: TBitmap;
begin
  BMHue := TBitmap.Create;
  BMHue.Assign(FMain.ImgHue.Picture);
  BMSaturation := TBitmap.Create;
  BMSaturation.Assign(FMain.ImgSaturation.Picture);
  BMIntensity := TBitmap.Create;
  BMIntensity.Assign(FMain.ImgIntensity.Picture);
  BM := TBitmap.Create;
  BM.Height := BMHue.Height;
  BM.Width := BMHue.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BMHue.Canvas.Pixels[i, j]);
      r.SetHue(o.GetRed * 360);
      o.SetFullColor(BMSaturation.Canvas.Pixels[i, j]);
      r.SetSaturation(o.GetRed);
      o.SetFullColor(BMIntensity.Canvas.Pixels[i, j]);
      r.SetIntensity(o.GetRed);
      BM.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  FMain.ImgRestored.Picture.Assign(BM);
  BM.Free;
  BMHue.Free;
  BMSaturation.Free;
  BMIntensity.Free;
  FMain.Refresh;
end;

procedure ColorToYIQClick;
var
  i, j: word;
  o, r: TColorPixel;
  BM, BMY, BMI, BMQ: TBitmap;
begin
  BM := TBitmap.Create;
  BM.Assign(FMain.ImgOrigin.Picture);
  BMY := TBitmap.Create;
  BMY.Height := BM.Height;
  BMY.Width := BM.Width;
  BMI := TBitmap.Create;
  BMI.Height := BM.Height;
  BMI.Width := BM.Width;
  BMQ := TBitmap.Create;
  BMQ.Height := BM.Height;
  BMQ.Width := BM.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BM.Canvas.Pixels[i, j]);
      r.SetY(o.GetY);
      r.SetI((o.GetI + 0.595) / 1.191);
      // r.SetI(TruncateBits(r.GetI, FMain.UpDown1.Position) / 255);
      r.SetQ((o.GetQ + 0.523) / 1.045);
      // r.SetQ(TruncateBits(r.GetQ, FMain.UpDown1.Position) / 255);
      BMY.Canvas.Pixels[i, j] := RGB(round(r.GetY * 255), round(r.GetY * 255),
        round(r.GetY * 255));
      BMI.Canvas.Pixels[i, j] := RGB(round(r.GetI * 255), round(r.GetI * 255),
        round(r.GetI * 255));
      BMQ.Canvas.Pixels[i, j] := RGB(round(r.GetQ * 255), round(r.GetQ * 255),
        round(r.GetQ * 255));
    end;
  FMain.ImgY.Picture.Assign(BMY);
  FMain.ImgI.Picture.Assign(BMI);
  FMain.ImgQ.Picture.Assign(BMQ);
  BM.Free;
  BMY.Free;
  BMI.Free;
  BMQ.Free;
  FMain.Refresh;
end;

procedure YIQToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
  BM, BMY, BMI, BMQ: TBitmap;
begin
  BMY := TBitmap.Create;
  BMY.Assign(FMain.ImgY.Picture);
  BMI := TBitmap.Create;
  BMI.Assign(FMain.ImgI.Picture);
  BMQ := TBitmap.Create;
  BMQ.Assign(FMain.ImgQ.Picture);
  BM := TBitmap.Create;
  BM.Height := BMY.Height;
  BM.Width := BMY.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      o.SetFullColor(BMY.Canvas.Pixels[i, j]);
      r.SetY(o.GetRed);
      o.SetFullColor(BMI.Canvas.Pixels[i, j]);
      r.SetI(o.GetRed);
      o.SetFullColor(BMQ.Canvas.Pixels[i, j]);
      r.SetQ(o.GetRed);
      r.SetI((byte(round(r.GetI * 255)) and 248) / 255);
      r.SetQ((byte(round(r.GetQ * 255)) and 248) / 255);
      r.SetI(r.GetI * 1.191 - 0.595);
      r.SetQ(r.GetQ * 1.045 - 0.523);
      BM.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  FMain.ImgRestored.Picture.Assign(BM);
  BM.Free;
  BMY.Free;
  BMI.Free;
  BMQ.Free;
  FMain.Refresh;
end;

procedure CompareImages;
var
  i, j: word;
  o, r: TColorPixel;
  dist: word;
  BMO, BMR, BMD: TBitmap;
begin
  BMO := TBitmap.Create;
  BMO.Assign(FMain.ImgOrigin.Picture);
  BMR := TBitmap.Create;
  BMR.Assign(FMain.ImgRestored.Picture);
  BMD := TBitmap.Create;
  BMD.Height := BMR.Height;
  BMD.Width := BMR.Width;
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to BMO.Height do
    for i := 0 to BMO.Width do
    begin
      o.SetFullColor(BMO.Canvas.Pixels[i, j]);
      r.SetFullColor(BMR.Canvas.Pixels[i, j]);
      dist := abs(round(255 * (o.GetRed - r.GetRed))) +
        abs(round(255 * (o.GetGreen - r.GetGreen))) +
        abs(round(255 * (o.GetBlue - r.GetBlue)));
      if dist = 0 then
        BMD.Canvas.Pixels[i, j] := clWhite
      else if (dist > 0) and (dist < 50) then
        BMD.Canvas.Pixels[i, j] := clGreen
      else if (dist >= 50) and (dist < 170) then
        BMD.Canvas.Pixels[i, j] := clYellow
      else if dist >= 170 then
        BMD.Canvas.Pixels[i, j] := clRed
    end;
  o.Free;
  r.Free;
  FMain.ImgDiff.Picture.Assign(BMD);
  BMO.Free;
  BMR.Free;
  BMD.Free;
  FMain.Refresh;
end;

procedure PrepareImages;
  procedure ClearImg(i: TImage);
  var
    BM: TBitmap;
  begin
    BM := TBitmap.Create;
    BM.Height := 255;
    BM.Width := 255;
    BM.Canvas.Pen.Color := clGray;
    BM.Canvas.Brush.Color := clGray;
    BM.Canvas.Rectangle(0, 0, 255, 255);
    BM.Canvas.Pixels[1, 1] := clGray;
    i.Picture.Assign(BM);
    BM.Free;
    i.Refresh;
  end;

begin
  ClearImg(FMain.ImgRestored);
  ClearImg(FMain.ImgDiff);
  ClearImg(FMain.ImgRed);
  ClearImg(FMain.ImgGreen);
  ClearImg(FMain.ImgBlue);
  ClearImg(FMain.ImgCyan);
  ClearImg(FMain.ImgMagenta);
  ClearImg(FMain.ImgYellow);
  ClearImg(FMain.ImgKey);
  ClearImg(FMain.ImgHue);
  ClearImg(FMain.ImgSaturation);
  ClearImg(FMain.ImgIntensity);
  ClearImg(FMain.ImgY);
  ClearImg(FMain.ImgI);
  ClearImg(FMain.ImgQ);
  FMain.Refresh;
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  Randomize;
  RGVertical.ItemIndex := random(3);
  RGHorizontal.ItemIndex := random(3);
  RGVerticalClick(nil);
  PrepareImages;
end;

procedure TFMain.FormCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

procedure TFMain.ImgOriginClick(Sender: TObject);
begin
  if OPD.Execute then
    ImgOrigin.Picture.LoadFromFile(OPD.FileName);
end;

procedure TFMain.ImgRestoredMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  r, g, b: byte;
begin
  LPosition.Caption := 'x= ' + inttostr(X) + ' y= ' + inttostr(Y);
  r := ImgOrigin.Canvas.Pixels[X, Y];
  g := ImgOrigin.Canvas.Pixels[X, Y] shr 8;
  b := ImgOrigin.Canvas.Pixels[X, Y] shr 16;
  LROrigin.Caption := 'r=' + inttostr(r);
  LGOrigin.Caption := 'g=' + inttostr(g);
  LBOrigin.Caption := 'b=' + inttostr(b);
  ImgOriginTest.Canvas.Pen.Color := RGB(r, g, b);
  ImgOriginTest.Canvas.Brush.Color := RGB(r, g, b);
  ImgOriginTest.Canvas.Brush.Style := bsSolid;
  ImgOriginTest.Canvas.Rectangle(0, 0, ImgOriginTest.Width,
    ImgOriginTest.Height);
  r := ImgRestored.Canvas.Pixels[X, Y];
  g := ImgRestored.Canvas.Pixels[X, Y] shr 8;
  b := ImgRestored.Canvas.Pixels[X, Y] shr 16;
  LRRestored.Caption := 'r=' + inttostr(r);
  LGRestored.Caption := 'g=' + inttostr(g);
  LBRestored.Caption := 'b=' + inttostr(b);
  ImgRestoredTest.Canvas.Pen.Color := RGB(r, g, b);
  ImgRestoredTest.Canvas.Brush.Color := RGB(r, g, b);
  ImgRestoredTest.Canvas.Brush.Style := bsSolid;
  ImgRestoredTest.Canvas.Rectangle(0, 0, ImgRestoredTest.Width,
    ImgRestoredTest.Height);
end;

procedure TFMain.RGVerticalClick(Sender: TObject);
var
  i, j: word;
  r, g, b: byte;
  BM: TBitmap;
begin
  BM := TBitmap.Create;
  BM.Height := 255;
  BM.Width := 255;
  r := 0;
  g := 0;
  b := 0;
  for j := 0 to BM.Height do
    for i := 0 to BM.Width do
    begin
      case RGVertical.ItemIndex of
        0:
          r := j;
        1:
          g := j;
        2:
          b := j;
      end;
      case RGHorizontal.ItemIndex of
        0:
          r := i;
        1:
          g := i;
        2:
          b := i;
      end;
      BM.Canvas.Pixels[i, j] := RGB(r, g, b);
    end;
  ImgOrigin.Picture.Assign(BM);
  BM.Free;
end;

procedure TFMain.BRGBClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 0;
  PrepareImages;
  ColorToRGBClick;
  RGBToColorClick;
  CompareImages;
  if not DirectoryExists('RGB') then
    MkDir('RGB');
  ChDir('RGB');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  ImgRestored.Picture.SaveToFile('2_restored.bmp');
  ImgDiff.Picture.SaveToFile('3_difference.bmp');
  ImgRed.Picture.SaveToFile('cc1_Red.bmp');
  ImgGreen.Picture.SaveToFile('cc2_Green.bmp');
  ImgBlue.Picture.SaveToFile('cc3_Blue.bmp');
  ChDir('..');
end;

procedure TFMain.BCMYKClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 1;
  PrepareImages;
  ColorToCMYKClick;
  CMYKToColorClick;
  CompareImages;
  if not DirectoryExists('CMYK') then
    MkDir('CMYK');
  ChDir('CMYK');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  ImgRestored.Picture.SaveToFile('2_restored.bmp');
  ImgDiff.Picture.SaveToFile('3_difference.bmp');
  ImgCyan.Picture.SaveToFile('cc1_Cyan.bmp');
  ImgMagenta.Picture.SaveToFile('cc2_Magenta.bmp');
  ImgYellow.Picture.SaveToFile('cc3_Yellow.bmp');
  ImgKey.Picture.SaveToFile('cc4_KeyColor.bmp');
  ChDir('..');
end;

procedure TFMain.BHSIClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 2;
  PrepareImages;
  ColorToHSIClick;
  HSIToColorClick;
  CompareImages;
  if not DirectoryExists('HSI') then
    MkDir('HSI');
  ChDir('HSI');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  ImgRestored.Picture.SaveToFile('2_restored.bmp');
  ImgDiff.Picture.SaveToFile('3_difference.bmp');
  ImgHue.Picture.SaveToFile('cc1_Hue.bmp');
  ImgSaturation.Picture.SaveToFile('cc2_Saturation.bmp');
  ImgIntensity.Picture.SaveToFile('cc3_Intensity.bmp');
  ChDir('..');
end;

procedure TFMain.BYIQClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 3;
  PrepareImages;
  ColorToYIQClick;
  YIQToColorClick;
  CompareImages;
  if not DirectoryExists('YIQ') then
    MkDir('YIQ');
  ChDir('YIQ');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  ImgRestored.Picture.SaveToFile('2_restored.bmp');
  ImgDiff.Picture.SaveToFile('3_difference.bmp');
  ImgY.Picture.SaveToFile('cc1_Y.bmp');
  ImgI.Picture.SaveToFile('cc2_I.bmp');
  ImgQ.Picture.SaveToFile('cc3_Q.bmp');
  ChDir('..');
end;

end.
