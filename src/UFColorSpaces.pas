unit UFColorSpaces;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TFColorSpaces = class(TForm)
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
    CBCompareImages: TCheckBox;
    procedure ImgRestoredMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BRGBClick(Sender: TObject);
    procedure BCMYKClick(Sender: TObject);
    procedure BHSIClick(Sender: TObject);
    procedure BYIQClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure ImgOriginClick(Sender: TObject);
    procedure RGVerticalClick(Sender: TObject);
    procedure CBCompareImagesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FColorSpaces: TFColorSpaces;

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
  BMO.Assign(FColorSpaces.ImgOrigin.Picture);
  BMR := TBitmap.Create;
  BMR.Assign(FColorSpaces.ImgRestored.Picture);
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
      dist := abs(round(255 * (o.GetRed - r.GetRed))) + abs(round(255 * (o.GetGreen - r.GetGreen))) + abs(round(255 * (o.GetBlue - r.GetBlue)));
      if dist = 0 then
        BMD.Canvas.Pixels[i, j] := clWhite
      else
        if (dist > 0) and (dist < 50) then
          BMD.Canvas.Pixels[i, j] := clGreen
        else
          if (dist >= 50) and (dist < 170) then
            BMD.Canvas.Pixels[i, j] := clYellow
          else
            if dist >= 170 then
              BMD.Canvas.Pixels[i, j] := clRed
    end;
  o.Free;
  r.Free;
  FColorSpaces.ImgDiff.Picture.Assign(BMD);
  BMO.Free;
  BMR.Free;
  BMD.Free;
  FColorSpaces.Refresh;
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
  ClearImg(FColorSpaces.ImgRestored);
  ClearImg(FColorSpaces.ImgDiff);
  if FColorSpaces.PCColorSpaces.Pages[0].Tag = 0 then
  begin
    ClearImg(FColorSpaces.ImgRed);
    ClearImg(FColorSpaces.ImgGreen);
    ClearImg(FColorSpaces.ImgBlue);
  end;
  if FColorSpaces.PCColorSpaces.Pages[1].Tag = 0 then
  begin
    ClearImg(FColorSpaces.ImgCyan);
    ClearImg(FColorSpaces.ImgMagenta);
    ClearImg(FColorSpaces.ImgYellow);
    ClearImg(FColorSpaces.ImgKey);
  end;
  if FColorSpaces.PCColorSpaces.Pages[2].Tag = 0 then
  begin
    ClearImg(FColorSpaces.ImgHue);
    ClearImg(FColorSpaces.ImgSaturation);
    ClearImg(FColorSpaces.ImgIntensity);
  end;
  if FColorSpaces.PCColorSpaces.Pages[3].Tag = 0 then
  begin
    ClearImg(FColorSpaces.ImgY);
    ClearImg(FColorSpaces.ImgI);
    ClearImg(FColorSpaces.ImgQ);
  end;
  FColorSpaces.Refresh;
end;

procedure TFColorSpaces.FormActivate(Sender: TObject);
begin
  Randomize;
  RGVertical.ItemIndex := random(3);
  RGHorizontal.ItemIndex := random(3);
  RGVerticalClick(nil);
  PrepareImages;
end;

procedure TFColorSpaces.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

procedure TFColorSpaces.ImgOriginClick(Sender: TObject);
begin
  if OPD.Execute then
  begin
    ImgOrigin.Picture.Assign(UFileConvert.LoadFile(OPD.FileName));
    ImgRestored.Tag := 0;
    PCColorSpaces.Pages[0].Tag := 0;
    PCColorSpaces.Pages[1].Tag := 0;
    PCColorSpaces.Pages[2].Tag := 0;
    PCColorSpaces.Pages[3].Tag := 0;
    PrepareImages;
  end;
end;

procedure TFColorSpaces.ImgRestoredMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
    LPosition.Caption := 'row= ' + inttostr(px + 1) + ' col= ' + inttostr(py + 1);
    LROrigin.Caption := 'r=' + inttostr(round(CIO.Pixels[px, py].GetRed * 255));
    LGOrigin.Caption := 'g=' + inttostr(round(CIO.Pixels[px, py].GetGreen * 255));
    LBOrigin.Caption := 'b=' + inttostr(round(CIO.Pixels[px, py].GetBlue * 255));
    ImgOriginTest.Canvas.Pen.Color := CIO.Pixels[px, py].GetFullColor;
    ImgOriginTest.Canvas.Brush.Color := CIO.Pixels[px, py].GetFullColor;
    ImgOriginTest.Canvas.Brush.Style := bsSolid;
    ImgOriginTest.Canvas.Rectangle(0, 0, ImgOriginTest.Width, ImgOriginTest.Height);
    LRRestored.Caption := 'r=' + inttostr(round(CIR.Pixels[px, py].GetRed * 255));
    LGRestored.Caption := 'g=' + inttostr(round(CIR.Pixels[px, py].GetGreen * 255));
    LBRestored.Caption := 'b=' + inttostr(round(CIR.Pixels[px, py].GetBlue * 255));
    ImgRestoredTest.Canvas.Pen.Color := CIR.Pixels[px, py].GetFullColor;
    ImgRestoredTest.Canvas.Brush.Color := CIR.Pixels[px, py].GetFullColor;
    ImgRestoredTest.Canvas.Brush.Style := bsSolid;
    ImgRestoredTest.Canvas.Rectangle(0, 0, ImgRestoredTest.Width, ImgRestoredTest.Height);
    CIO.FreeColorImage;
    CIR.FreeColorImage;
  end;
end;

procedure TFColorSpaces.RGVerticalClick(Sender: TObject);
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
      0: r := j;
      1: g := j;
      2: b := j;
      end;
      case RGHorizontal.ItemIndex of
      0: r := i;
      1: g := i;
      2: b := i;
      end;
      BM.Canvas.Pixels[i, j] := RGB(r, g, b);
    end;
  ImgOrigin.Picture.Assign(BM);
  BM.Free;
  ImgRestored.Tag := 0;
  PCColorSpaces.Pages[0].Tag := 0;
  PCColorSpaces.Pages[1].Tag := 0;
  PCColorSpaces.Pages[2].Tag := 0;
  PCColorSpaces.Pages[3].Tag := 0;
  PrepareImages;
end;

procedure ColorToRGB;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.CreateAndLoadFromBitmap(FColorSpaces.ImgOrigin.Picture.Bitmap);

  GS := CI.GetChanel(ccRed);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgRed.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  GS := CI.GetChanel(ccGreen);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgGreen.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  GS := CI.GetChanel(ccBlue);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgBlue.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  CI.FreeColorImage;
end;

procedure RGBToColor;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.Create;
  GS := TCGrayscaleImage.Create;

  GS.LoadFromBitMap(FColorSpaces.ImgRed.Picture.Bitmap);
  CI.SetChannel(ccRed, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgGreen.Picture.Bitmap);
  CI.SetChannel(ccGreen, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgBlue.Picture.Bitmap);
  CI.SetChannel(ccBlue, GS);
  BM := CI.SaveToBitMap;
  FColorSpaces.ImgRestored.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;
  CI.FreeColorImage;
end;

procedure ColorToCMYK;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.CreateAndLoadFromBitmap(FColorSpaces.ImgOrigin.Picture.Bitmap);

  GS := CI.GetChanel(ccCyan);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgCyan.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  GS := CI.GetChanel(ccMagenta);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgMagenta.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  GS := CI.GetChanel(ccYellow);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgYellow.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  GS := CI.GetChanel(ccKeyColor);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgKey.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;

  CI.FreeColorImage;
end;

procedure CMYKToColor;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.Create;

  GS := TCGrayscaleImage.CreateAndLoadFromBitmap(FColorSpaces.ImgCyan.Picture.Bitmap);
  CI.SetChannel(ccCyan, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgMagenta.Picture.Bitmap);
  CI.SetChannel(ccMagenta, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgYellow.Picture.Bitmap);
  CI.SetChannel(ccYellow, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgKey.Picture.Bitmap);
  CI.SetChannel(ccKeyColor, GS);
  BM := CI.SaveToBitMap;
  FColorSpaces.ImgRestored.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;
  CI.FreeColorImage;
end;

procedure ColorToHSI;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.CreateAndLoadFromBitmap(FColorSpaces.ImgOrigin.Picture.Bitmap);

  GS := CI.GetChanel(ccHue);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgHue.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  GS := CI.GetChanel(ccSaturation);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgSaturation.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  GS := CI.GetChanel(ccIntensity);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgIntensity.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  CI.FreeColorImage;
end;

procedure HSIToColor;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.Create;
  GS := TCGrayscaleImage.CreateAndLoadFromBitmap(FColorSpaces.ImgHue.Picture.Bitmap);
  CI.SetChannel(ccHue, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgSaturation.Picture.Bitmap);
  CI.SetChannel(ccSaturation, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgIntensity.Picture.Bitmap);
  CI.SetChannel(ccIntensity, GS);
  BM := CI.SaveToBitMap;
  FColorSpaces.ImgRestored.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;
  CI.FreeColorImage;
end;

procedure ColorToYIQ;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.CreateAndLoadFromBitmap(FColorSpaces.ImgOrigin.Picture.Bitmap);

  GS := CI.GetChanel(ccY);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgY.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  GS := CI.GetChanel(ccI);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgI.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  GS := CI.GetChanel(ccQ);
  BM := GS.SaveToBitMap;
  FColorSpaces.ImgQ.Picture.Assign(BM);
  GS.FreeGrayscaleImage;
  BM.Free;

  CI.FreeColorImage;
end;

procedure YIQToColor;
var
  CI: TCColorImage;
  GS: TCGrayscaleImage;
  BM: TBitmap;
begin
  CI := TCColorImage.Create;
  GS := TCGrayscaleImage.CreateAndLoadFromBitmap(FColorSpaces.ImgY.Picture.Bitmap);
  CI.SetChannel(ccY, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgI.Picture.Bitmap);
  CI.SetChannel(ccI, GS);
  GS.LoadFromBitMap(FColorSpaces.ImgQ.Picture.Bitmap);
  CI.SetChannel(ccQ, GS);
  BM := CI.SaveToBitMap;
  FColorSpaces.ImgRestored.Picture.Assign(BM);
  BM.Free;
  GS.FreeGrayscaleImage;
  CI.FreeColorImage;
end;

procedure TFColorSpaces.BRGBClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 0;
  PrepareImages;
  if PCColorSpaces.Pages[0].Tag = 0 then
  begin
    PCColorSpaces.Pages[0].Tag := 1;
    ColorToRGB;
  end;
  if not DirectoryExists('RGB') then
    MkDir('RGB');
  ChDir('RGB');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  if CBCompareImages.Checked then
  begin
    RGBToColor;
    CompareImages;
    ImgRestored.Picture.SaveToFile('2_restored.bmp');
    ImgDiff.Picture.SaveToFile('3_difference.bmp');
    ImgRestored.Tag := 1;
  end;
  ImgRed.Picture.SaveToFile('cc1_Red.bmp');
  ImgGreen.Picture.SaveToFile('cc2_Green.bmp');
  ImgBlue.Picture.SaveToFile('cc3_Blue.bmp');
  ChDir('..');
end;

procedure TFColorSpaces.BCMYKClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 1;
  PrepareImages;
  if PCColorSpaces.Pages[1].Tag = 0 then
  begin
    PCColorSpaces.Pages[1].Tag := 1;
    ColorToCMYK;
  end;
  if not DirectoryExists('CMYK') then
    MkDir('CMYK');
  ChDir('CMYK');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  if CBCompareImages.Checked then
  begin
    CMYKToColor;
    CompareImages;
    ImgRestored.Picture.SaveToFile('2_restored.bmp');
    ImgDiff.Picture.SaveToFile('3_difference.bmp');
    ImgRestored.Tag := 1;
  end;
  ImgCyan.Picture.SaveToFile('cc1_Cyan.bmp');
  ImgMagenta.Picture.SaveToFile('cc2_Magenta.bmp');
  ImgYellow.Picture.SaveToFile('cc3_Yellow.bmp');
  ImgKey.Picture.SaveToFile('cc4_KeyColor.bmp');
  ChDir('..');
end;

procedure TFColorSpaces.BHSIClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 2;
  PrepareImages;
  if PCColorSpaces.Pages[2].Tag = 0 then
  begin
    PCColorSpaces.Pages[2].Tag := 1;
    ColorToHSI;
  end;
  if not DirectoryExists('HSI') then
    MkDir('HSI');
  ChDir('HSI');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  if CBCompareImages.Checked then
  begin
    HSIToColor;
    CompareImages;
    ImgRestored.Picture.SaveToFile('2_restored.bmp');
    ImgDiff.Picture.SaveToFile('3_difference.bmp');
    ImgRestored.Tag := 1;
  end;
  ImgHue.Picture.SaveToFile('cc1_Hue.bmp');
  ImgSaturation.Picture.SaveToFile('cc2_Saturation.bmp');
  ImgIntensity.Picture.SaveToFile('cc3_Intensity.bmp');
  ChDir('..');
end;

procedure TFColorSpaces.BYIQClick(Sender: TObject);
begin
  PCColorSpaces.TabIndex := 3;
  PrepareImages;
  if PCColorSpaces.Pages[3].Tag = 0 then
  begin
    PCColorSpaces.Pages[3].Tag := 1;
    ColorToYIQ;
  end;
  if not DirectoryExists('YIQ') then
    MkDir('YIQ');
  ChDir('YIQ');
  ImgOrigin.Picture.SaveToFile('1_origin.bmp');
  if CBCompareImages.Checked then
  begin
    YIQToColor;
    CompareImages;
    ImgRestored.Picture.SaveToFile('2_restored.bmp');
    ImgDiff.Picture.SaveToFile('3_difference.bmp');
    ImgRestored.Tag := 1;
  end;
  ImgY.Picture.SaveToFile('cc1_Y.bmp');
  ImgI.Picture.SaveToFile('cc2_I.bmp');
  ImgQ.Picture.SaveToFile('cc3_Q.bmp');
  ChDir('..');
end;

procedure TFColorSpaces.CBCompareImagesClick(Sender: TObject);
begin
  if not CBCompareImages.Checked then
  begin
    PrepareImages;
    ImgRestored.Tag := 0;
  end;
  if CBCompareImages.Checked then
  begin
    if PCColorSpaces.Pages[PCColorSpaces.TabIndex].Tag = 1 then
    begin
      case PCColorSpaces.TabIndex of
      0: RGBToColor;
      1: CMYKToColor;
      2: HSIToColor;
      3: YIQToColor;
      end;
      CompareImages;
      ImgRestored.Picture.SaveToFile('2_restored.bmp');
      ImgDiff.Picture.SaveToFile('3_difference.bmp');
      ImgRestored.Tag := 1;
    end;
  end;
end;

end.
