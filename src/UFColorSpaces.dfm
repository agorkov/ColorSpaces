object FColorSpaces: TFColorSpaces
  Left = 0
  Top = 0
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1094#1074#1077#1090#1086#1074#1099#1093' '#1087#1088#1086#1089#1090#1088#1072#1085#1089#1090#1074
  ClientHeight = 565
  ClientWidth = 1071
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    9999999999999999999999999999999999999999999999999999999999999900
    0000000000000000000000000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000000000000000000000000000999999
    9999999999999999999999999999999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCanResize = FormCanResize
  PixelsPerInch = 96
  TextHeight = 13
  object ImgOrigin: TImage
    Left = 15
    Top = 8
    Width = 255
    Height = 255
    Center = True
    Proportional = True
    Stretch = True
    OnClick = ImgOriginClick
    OnMouseMove = ImgRestoredMouseMove
  end
  object ImgRestored: TImage
    Left = 372
    Top = 8
    Width = 255
    Height = 255
    Center = True
    Proportional = True
    Stretch = True
    OnMouseMove = ImgRestoredMouseMove
  end
  object ImgDiff: TImage
    Left = 633
    Top = 8
    Width = 255
    Height = 255
    Center = True
    Proportional = True
    Stretch = True
    OnMouseMove = ImgRestoredMouseMove
  end
  object PCColorSpaces: TPageControl
    Left = 18
    Top = 269
    Width = 1046
    Height = 292
    ActivePage = TSRGB
    TabOrder = 0
    object TSRGB: TTabSheet
      Caption = 'RGB'
      object ImgRed: TImage
        Left = 68
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgGreen: TImage
        Left = 391
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgBlue: TImage
        Left = 714
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
    end
    object TSCMYK: TTabSheet
      Caption = 'CMYK'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ImgKey: TImage
        Left = 777
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgCyan: TImage
        Left = 3
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgMagenta: TImage
        Left = 261
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgYellow: TImage
        Left = 519
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
    end
    object TSHSI: TTabSheet
      Caption = 'HSI'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ImgHue: TImage
        Left = 68
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgSaturation: TImage
        Left = 391
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgIntensity: TImage
        Left = 714
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
    end
    object TSYIQ: TTabSheet
      Caption = 'YIQ'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ImgI: TImage
        Left = 391
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgQ: TImage
        Left = 714
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
      object ImgY: TImage
        Left = 68
        Top = 3
        Width = 255
        Height = 255
        Center = True
        Proportional = True
        Stretch = True
      end
    end
  end
  object BRGB: TButton
    Left = 276
    Top = 8
    Width = 90
    Height = 21
    Caption = 'RGB'
    TabOrder = 1
    OnClick = BRGBClick
  end
  object GBPixelMatching: TGroupBox
    Left = 894
    Top = 8
    Width = 169
    Height = 255
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1080#1082#1089#1077#1083#1077#1081':'
    TabOrder = 2
    object LPosition: TLabel
      Left = 3
      Top = 24
      Width = 3
      Height = 13
    end
    object LROrigin: TLabel
      Left = 3
      Top = 43
      Width = 3
      Height = 13
    end
    object LGOrigin: TLabel
      Left = 3
      Top = 62
      Width = 3
      Height = 13
    end
    object LBOrigin: TLabel
      Left = 3
      Top = 81
      Width = 3
      Height = 13
    end
    object LRRestored: TLabel
      Left = 112
      Top = 43
      Width = 3
      Height = 13
    end
    object LGRestored: TLabel
      Left = 112
      Top = 62
      Width = 3
      Height = 13
    end
    object LBRestored: TLabel
      Left = 112
      Top = 81
      Width = 3
      Height = 13
    end
    object ImgOriginTest: TImage
      Left = 3
      Top = 148
      Width = 71
      Height = 93
    end
    object ImgRestoredTest: TImage
      Left = 95
      Top = 148
      Width = 71
      Height = 93
    end
  end
  object BCMYK: TButton
    Left = 276
    Top = 35
    Width = 90
    Height = 21
    Caption = 'CMYK'
    TabOrder = 3
    OnClick = BCMYKClick
  end
  object BHSI: TButton
    Left = 276
    Top = 62
    Width = 90
    Height = 21
    Caption = 'HSI'
    TabOrder = 4
    OnClick = BHSIClick
  end
  object BYIQ: TButton
    Left = 276
    Top = 89
    Width = 90
    Height = 21
    Caption = 'YIQ'
    TabOrder = 5
    OnClick = BYIQClick
  end
  object RGVertical: TRadioGroup
    Left = 276
    Top = 128
    Width = 90
    Height = 33
    Caption = #1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080':'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'R'
      'G'
      'B')
    TabOrder = 6
    OnClick = RGVerticalClick
  end
  object RGHorizontal: TRadioGroup
    Left = 276
    Top = 167
    Width = 90
    Height = 33
    Caption = #1055#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080':'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'R'
      'G'
      'B')
    TabOrder = 7
    OnClick = RGVerticalClick
  end
  object CBCompareImages: TCheckBox
    Left = 276
    Top = 206
    Width = 90
    Height = 27
    Caption = #1057#1088#1072#1074#1085#1080#1074#1072#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
    TabOrder = 8
    WordWrap = True
    OnClick = CBCompareImagesClick
  end
  object OPD: TOpenPictureDialog
    Filter = 
      'All|*.jpg;*.jpeg;*.bmp|JPEG Image File (*.jpg)|*.jpg|JPEG Image ' +
      'File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    Left = 24
    Top = 16
  end
end
