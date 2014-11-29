program PColorSpaces;

uses
  Vcl.Forms,
  UFColorSpaces in 'UFColorSpaces.pas' {FColorSpaces},
  UBinaryImages in '..\..\ImgSharedUnits\src\UBinaryImages.pas',
  UBitMapFunctions in '..\..\ImgSharedUnits\src\UBitMapFunctions.pas',
  UColorImages in '..\..\ImgSharedUnits\src\UColorImages.pas',
  UGrayscaleImages in '..\..\ImgSharedUnits\src\UGrayscaleImages.pas',
  UPixelConvert in '..\..\ImgSharedUnits\src\UPixelConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFColorSpaces, FColorSpaces);
  Application.Run;

end.
