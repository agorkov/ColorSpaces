program PColorSpaces;

uses
  Vcl.Forms,
  UFColorSpaces in 'UFColorSpaces.pas' {FColorSpaces},
  UColorImages in '..\..\ImgSharedUnits\src\UColorImages.pas',
  UFileConvert in '..\..\ImgSharedUnits\src\UFileConvert.pas',
  UGrayscaleImages in '..\..\ImgSharedUnits\src\UGrayscaleImages.pas',
  UPixelConvert in '..\..\ImgSharedUnits\src\UPixelConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFColorSpaces, FColorSpaces);
  Application.Run;

end.
