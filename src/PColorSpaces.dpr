program PColorSpaces;

uses
  Vcl.Forms, UFColorSpaces in 'UFColorSpaces.pas' {FColorSpaces} , UPixelConvert in 'D:\ImgSharedUnits\src\UPixelConvert.pas', UFileConvert in 'D:\ImgSharedUnits\src\UFileConvert.pas', UColorImages in 'D:\ImgSharedUnits\src\UColorImages.pas', UGrayscaleImages in 'D:\ImgSharedUnits\src\UGrayscaleImages.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFColorSpaces, FColorSpaces);
  Application.Run;

end.
