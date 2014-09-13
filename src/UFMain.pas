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
  Math, UPixelConvert, UFileConvert, UColorImages, UGrayscaleImages;

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
  BMO.FreeImage;
  BMR.FreeImage;
  BMD.FreeImage;
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
  begin
    ImgOrigin.Picture.Assign(UFileConvert.LoadFile(OPD.FileName));
    ImgRestored.Tag := 0;
    PrepareImages;
  end;
end;

procedure TFMain.ImgRestoredMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  px, py: word;
  CIO, CIR: TCColorImage;
begin
  if ImgRestored.Tag = 1 then
  begin
    CIO := TCColorImage.CreateAndLoadFromBitmap(ImgOrigin.Picture.Bitmap);
    CIR := TCColorImage.CreateAndLoadFromBitmap(ImgRestored.Picture.Bitmap);
    py := round(X * CIO.GetWidth / ImgOrigin.Width);
    px := round(Y * CIO.GetHeight / ImgOrigin.Height);
    if px >= CIO.GetWidth then
      px := px - 1;
    if py >= CIO.GetHeight then
      py := py - 1;
    LPosition.Caption := 'row= ' + inttostr(px + 1) + ' col= ' +
      inttostr(py + 1);
    LROrigin.Caption := 'r=' + inttostr(round(CIO.Pixels[px, py].GetRed * 255));
    LGOrigin.Caption := 'g=' +
      inttostr(round(CIO.Pixels[px, py].GetGreen * 255));
    LBOrigin.Caption := 'b=' +
      inttostr(round(CIO.Pixels[px, py].GetBlue * 255));
    ImgOriginTest.Canvas.Pen.Color := CIO.Pixels[px, py].GetFullColor;
    ImgOriginTest.Canvas.Brush.Color := CIO.Pixels[px, py].GetFullColor;
    ImgOriginTest.Canvas.Brush.Style := bsSolid;
    ImgOriginTest.Canvas.Rectangle(0, 0, ImgOriginTest.Width,
      ImgOriginTest.Height);
    LRRestored.Caption := 'r=' +
      inttostr(round(CIR.Pixels[px, py].GetRed * 255));
    LGRestored.Caption := 'g=' +
      inttostr(round(CIR.Pixels[px, py].GetGreen * 255));
    LBRestored.Caption := 'b=' +
      inttostr(round(CIR.Pixels[px, py].GetBlue * 255));
    ImgRestoredTest.Canvas.Pen.Color := CIR.Pixels[px, py].GetFullColor;
    ImgRestoredTest.Canvas.Brush.Color := CIR.Pixels[px, py].GetFullColor;
    ImgRestoredTest.Canvas.Brush.Style := bsSolid;
    ImgRestoredTest.Canvas.Rectangle(0, 0, ImgRestoredTest.Width,
      ImgRestoredTest.Height);
    CIO.FreeImage;
    CIR.FreeImage;
  end;
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
  procedure ColorToRGB;
  var
    CI: TCColorImage;
    GS: TCGrayscaleImage;
    BM: TBitmap;
  begin
    CI := TCColorImage.CreateAndLoadFromBitmap(ImgOrigin.Picture.Bitmap);

    GS := CI.GetChanel(ccRed);
    BM := GS.SaveToBitMap;
    FMain.ImgRed.Picture.Assign(BM);
    BM.Free;
    GS.FreeImage;

    GS := CI.GetChanel(ccGreen);
    BM := GS.SaveToBitMap;
    FMain.ImgGreen.Picture.Assign(BM);
    BM.Free;
    GS.FreeImage;

    GS := CI.GetChanel(ccBlue);
    BM := GS.SaveToBitMap;
    FMain.ImgBlue.Picture.Assign(BM);
    BM.Free;
    GS.FreeImage;

    CI.FreeImage;
  end;
  procedure RGBToColor;
  var
    CI: TCColorImage;
    GS: TCGrayscaleImage;
  begin
    CI := TCColorImage.Create;
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgRed.Picture.Bitmap);
    CI.SetChannel(ccRed, GS);
    GS.LoadFromBitMap(ImgGreen.Picture.Bitmap);
    CI.SetChannel(ccGreen, GS);
    GS.LoadFromBitMap(ImgBlue.Picture.Bitmap);
    CI.SetChannel(ccBlue, GS);
    FMain.ImgRestored.Picture.Assign(CI.SaveToBitMap);
    GS.FreeImage;
    CI.FreeImage;
  end;

begin
  PCColorSpaces.TabIndex := 0;
  PrepareImages;
  ColorToRGB;
  RGBToColor;
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
  ImgRestored.Tag := 1;
end;

procedure TFMain.BCMYKClick(Sender: TObject);
  procedure ColorToCMYK;
  var
    CI: TCColorImage;
  begin
    CI := TCColorImage.CreateAndLoadFromBitmap(ImgOrigin.Picture.Bitmap);
    FMain.ImgCyan.Picture.Assign(CI.GetChanel(ccCyan).SaveToBitMap);
    FMain.ImgMagenta.Picture.Assign(CI.GetChanel(ccMagenta).SaveToBitMap);
    FMain.ImgYellow.Picture.Assign(CI.GetChanel(ccYellow).SaveToBitMap);
    FMain.ImgKey.Picture.Assign(CI.GetChanel(ccKeyColor).SaveToBitMap);
  end;
  procedure CMYKToColor;
  var
    CI: TCColorImage;
    GS: TCGrayscaleImage;
  begin
    CI := TCColorImage.Create;
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgCyan.Picture.Bitmap);
    CI.SetChannel(ccCyan, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgMagenta.Picture.Bitmap);
    CI.SetChannel(ccMagenta, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgYellow.Picture.Bitmap);
    CI.SetChannel(ccYellow, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgKey.Picture.Bitmap);
    CI.SetChannel(ccKeyColor, GS);
    FMain.ImgRestored.Picture.Assign(CI.SaveToBitMap);
    GS.FreeImage;
    CI.FreeImage;
  end;

begin
  PCColorSpaces.TabIndex := 1;
  PrepareImages;
  ColorToCMYK;
  CMYKToColor;
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
  ImgRestored.Tag := 1;
end;

procedure TFMain.BHSIClick(Sender: TObject);
  procedure ColorToHSI;
  var
    CI: TCColorImage;
  begin
    CI := TCColorImage.CreateAndLoadFromBitmap(ImgOrigin.Picture.Bitmap);
    FMain.ImgHue.Picture.Assign(CI.GetChanel(ccHue).SaveToBitMap);
    FMain.ImgSaturation.Picture.Assign(CI.GetChanel(ccSaturation).SaveToBitMap);
    FMain.ImgIntensity.Picture.Assign(CI.GetChanel(ccIntensity).SaveToBitMap);
    CI.FreeImage;
  end;
  procedure HSIToColor;
  var
    CI: TCColorImage;
    GS: TCGrayscaleImage;
  begin
    CI := TCColorImage.Create;
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgHue.Picture.Bitmap);
    CI.SetChannel(ccHue, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap
      (ImgSaturation.Picture.Bitmap);
    CI.SetChannel(ccSaturation, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgIntensity.Picture.Bitmap);
    CI.SetChannel(ccIntensity, GS);
    FMain.ImgRestored.Picture.Assign(CI.SaveToBitMap);
    GS.FreeImage;
    CI.FreeImage;
  end;

begin
  PCColorSpaces.TabIndex := 2;
  PrepareImages;
  ColorToHSI;
  HSIToColor;
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
  ImgRestored.Tag := 1;
end;

procedure TFMain.BYIQClick(Sender: TObject);
  procedure ColorToYIQ;
  var
    CI: TCColorImage;
  begin
    CI := TCColorImage.CreateAndLoadFromBitmap(ImgOrigin.Picture.Bitmap);
    FMain.ImgY.Picture.Assign(CI.GetChanel(ccY).SaveToBitMap);
    FMain.ImgI.Picture.Assign(CI.GetChanel(ccI).SaveToBitMap);
    FMain.ImgQ.Picture.Assign(CI.GetChanel(ccQ).SaveToBitMap);
  end;
  procedure YIQToColor;
  var
    CI: TCColorImage;
    GS: TCGrayscaleImage;
  begin
    CI := TCColorImage.Create;
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgY.Picture.Bitmap);
    CI.SetChannel(ccY, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgI.Picture.Bitmap);
    CI.SetChannel(ccI, GS);
    GS := TCGrayscaleImage.CreateAndLoadFromBitmap(ImgQ.Picture.Bitmap);
    CI.SetChannel(ccQ, GS);
    FMain.ImgRestored.Picture.Assign(CI.SaveToBitMap);
    GS.FreeImage;
    CI.FreeImage;
  end;

begin
  PCColorSpaces.TabIndex := 3;
  PrepareImages;
  ColorToYIQ;
  YIQToColor;
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
  ImgRestored.Tag := 1;
end;

end.
