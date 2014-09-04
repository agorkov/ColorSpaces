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
    procedure ImgRestoreMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BRGBClick(Sender: TObject);
    procedure BCMYKClick(Sender: TObject);
    procedure BHSIClick(Sender: TObject);
    procedure BYIQClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
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
  RowStep = 10;

procedure ColorToRGBClick;
var
  i, j: word;
  o: TColorPixel;
begin
  o := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgOrigin.Canvas.Pixels[i, j]);
      Form1.ImgRed.Canvas.Pixels[i, j] := RGB(round(o.GetRed * 255), round(o.GetRed * 255), round(o.GetRed * 255));
      Form1.ImgGreen.Canvas.Pixels[i, j] := RGB(round(o.GetGreen * 255), round(o.GetGreen * 255), round(o.GetGreen * 255));
      Form1.ImgBlue.Canvas.Pixels[i, j] := RGB(round(o.GetBlue * 255), round(o.GetBlue * 255), round(o.GetBlue * 255));
    end;
  o.Free;
  Form1.Refresh;
end;

procedure RGBToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgRed.Canvas.Pixels[i, j]);
      r.SetRed(o.GetRed);
      o.SetFullColor(Form1.ImgGreen.Canvas.Pixels[i, j]);
      r.SetGreen(o.GetRed);
      o.SetFullColor(Form1.ImgBlue.Canvas.Pixels[i, j]);
      r.SetBlue(o.GetRed);

      Form1.ImgRestore.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  Form1.Refresh;
end;

procedure ColorToCMYKClick;
var
  i, j: word;
  o: TColorPixel;
begin
  o := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgOrigin.Canvas.Pixels[i, j]);
      Form1.ImgCyan.Canvas.Pixels[i, j] := RGB(round(o.GetCyan * 255), round(o.GetCyan * 255), round(o.GetCyan * 255));
      Form1.ImgMagenta.Canvas.Pixels[i, j] := RGB(round(o.GetMagenta * 255), round(o.GetMagenta * 255), round(o.GetMagenta * 255));
      Form1.ImgYellow.Canvas.Pixels[i, j] := RGB(round(o.GetYellow * 255), round(o.GetYellow * 255), round(o.GetYellow * 255));
      Form1.ImgKey.Canvas.Pixels[i, j] := RGB(round(o.GetKeyColor * 255), round(o.GetKeyColor * 255), round(o.GetKeyColor * 255));
    end;
  o.Free;
  Form1.Refresh;
end;

procedure CMYKToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgCyan.Canvas.Pixels[i, j]);
      r.SetCyan(o.GetRed);
      o.SetFullColor(Form1.ImgMagenta.Canvas.Pixels[i, j]);
      r.SetMagenta(o.GetRed);
      o.SetFullColor(Form1.ImgYellow.Canvas.Pixels[i, j]);
      r.SetYellow(o.GetRed);
      o.SetFullColor(Form1.ImgKey.Canvas.Pixels[i, j]);
      r.SetKeyColor(o.GetRed);

      Form1.ImgRestore.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  Form1.Refresh;
end;

procedure ColorToHSIClick;
var
  i, j: word;
  o: TColorPixel;
begin
  o := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgOrigin.Canvas.Pixels[i, j]);
      Form1.ImgHue.Canvas.Pixels[i, j] := RGB(round(255 * o.GetHue / 360), round(255 * o.GetHue / 360), round(255 * o.GetHue / 360));
      Form1.ImgSaturation.Canvas.Pixels[i, j] := RGB(round(o.GetSaturation * 255), round(o.GetSaturation * 255), round(o.GetSaturation * 255));
      Form1.ImgIntensity.Canvas.Pixels[i, j] := RGB(round(o.GetIntensity * 255), round(o.GetIntensity * 255), round(o.GetIntensity * 255));
    end;
  o.Free;
  Form1.Refresh;
end;

procedure HSIToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgHue.Canvas.Pixels[i, j]);
      r.SetHue(o.GetRed * 360);
      o.SetFullColor(Form1.ImgSaturation.Canvas.Pixels[i, j]);
      r.SetSaturation(o.GetRed);
      o.SetFullColor(Form1.ImgIntensity.Canvas.Pixels[i, j]);
      r.SetIntensity(o.GetRed);

      Form1.ImgRestore.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  Form1.Refresh;
end;

procedure ColorToYIQClick;
var
  i, j: word;
  o, r: TColorPixel;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgOrigin.Canvas.Pixels[i, j]);
      r.SetY(o.GetY);
      r.SetI((o.GetI + 0.595) / 1.191);
      r.SetI(TruncateBits(r.GetI, Form1.UpDown1.Position) / 255);
      r.SetQ((o.GetQ + 0.523) / 1.045);
      r.SetQ(TruncateBits(r.GetQ, Form1.UpDown1.Position) / 255);
      Form1.ImgY.Canvas.Pixels[i, j] := RGB(round(r.GetY * 255), round(r.GetY * 255), round(r.GetY * 255));
      Form1.ImgI.Canvas.Pixels[i, j] := RGB(round(r.GetI * 255), round(r.GetI * 255), round(r.GetI * 255));
      Form1.ImgQ.Canvas.Pixels[i, j] := RGB(round(r.GetQ * 255), round(r.GetQ * 255), round(r.GetQ * 255));
    end;
  Form1.Refresh;
end;

procedure YIQToColorClick;
var
  i, j: word;
  o, r: TColorPixel;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgY.Canvas.Pixels[i, j]);
      r.SetY(o.GetRed);
      o.SetFullColor(Form1.ImgI.Canvas.Pixels[i, j]);
      r.SetI(o.GetRed);
      o.SetFullColor(Form1.ImgQ.Canvas.Pixels[i, j]);
      r.SetQ(o.GetRed);

      r.SetI((byte(round(r.GetI * 255)) and 248) / 255);
      r.SetQ((byte(round(r.GetQ * 255)) and 248) / 255);
      r.SetI(r.GetI * 1.191 - 0.595);
      r.SetQ(r.GetQ * 1.045 - 0.523);

      Form1.ImgRestore.Canvas.Pixels[i, j] := r.GetFullColor;
    end;
  o.Free;
  r.Free;
  Form1.Refresh;
end;

procedure CompareImages;
var
  i, j: word;
  o, r: TColorPixel;
  dist: word;
begin
  o := TColorPixel.Create;
  r := TColorPixel.Create;
  for j := 0 to Form1.ImgOrigin.Height do
    for i := 0 to Form1.ImgOrigin.Width do
    begin
      o.SetFullColor(Form1.ImgOrigin.Canvas.Pixels[i, j]);
      r.SetFullColor(Form1.ImgRestore.Canvas.Pixels[i, j]);
      dist := abs(round(255 * (o.GetRed - r.GetRed))) + abs(round(255 * (o.GetGreen - r.GetGreen))) + abs(round(255 * (o.GetBlue - r.GetBlue)));
      if dist = 0 then
        Form1.ImgDiff.Canvas.Pixels[i, j] := clWhite
      else
        if (dist > 0) and (dist < 50) then
          Form1.ImgDiff.Canvas.Pixels[i, j] := clGreen
        else
          if (dist >= 50) and (dist < 170) then
            Form1.ImgDiff.Canvas.Pixels[i, j] := clYellow
          else
            if dist >= 170 then
              Form1.ImgDiff.Canvas.Pixels[i, j] := clRed

    end;
  o.Free;
  r.Free;
  Form1.Refresh;
end;

procedure PrepareImages;
  procedure ClearImg(i: TImage);
  begin
    i.Canvas.Pen.Color := clGray;
    i.Canvas.Brush.Color := clGray;
    i.Canvas.Rectangle(0, 0, i.Width, i.Height);
    i.Refresh;
  end;

begin
  ClearImg(Form1.ImgRestore);
  ClearImg(Form1.ImgDiff);
  ClearImg(Form1.ImgRed);
  ClearImg(Form1.ImgGreen);
  ClearImg(Form1.ImgBlue);
  ClearImg(Form1.ImgCyan);
  ClearImg(Form1.ImgMagenta);
  ClearImg(Form1.ImgYellow);
  ClearImg(Form1.ImgKey);
  ClearImg(Form1.ImgHue);
  ClearImg(Form1.ImgSaturation);
  ClearImg(Form1.ImgIntensity);
  ClearImg(Form1.ImgY);
  ClearImg(Form1.ImgI);
  ClearImg(Form1.ImgQ);

  Form1.Refresh;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  PrepareImages;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
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

procedure TForm1.BRGBClick(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  PrepareImages;
  ColorToRGBClick;
  RGBToColorClick;
  CompareImages;
end;

procedure TForm1.BCMYKClick(Sender: TObject);
begin
  PageControl1.TabIndex := 1;
  PrepareImages;
  ColorToCMYKClick;
  CMYKToColorClick;
  CompareImages;
end;

procedure TForm1.BHSIClick(Sender: TObject);
begin
  PageControl1.TabIndex := 2;
  PrepareImages;
  ColorToHSIClick;
  HSIToColorClick;
  CompareImages;
end;

procedure TForm1.BYIQClick(Sender: TObject);
begin
  PageControl1.TabIndex := 3;
  PrepareImages;
  ColorToYIQClick;
  YIQToColorClick;
  CompareImages;
end;

end.
