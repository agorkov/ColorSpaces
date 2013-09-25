program PColorSpaces;

uses
  Vcl.Forms,
  UFMain in 'UFMain.pas' {Form1},
  UPixelConvert in '..\..\ImgSharedUnits\src\UPixelConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
