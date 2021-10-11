object MainForm: TMainForm
  Left = 221
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'OCR Characters Recognize'
  ClientHeight = 133
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = Menu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object OCRPanel: TPanel
    Left = 0
    Top = 0
    Width = 133
    Height = 133
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BorderStyle = bsSingle
    TabOrder = 0
    object Img: TImage
      Left = 2
      Top = 2
      Width = 125
      Height = 125
      Align = alClient
      OnMouseMove = ImgMouseMove
    end
  end
  object ButtonPanel: TPanel
    Left = 133
    Top = 0
    Width = 363
    Height = 133
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object TextLbl: TLabel
      Left = 10
      Top = 79
      Width = 99
      Height = 16
      Caption = 'Recognized text:'
    end
    object StatusLbl: TLabel
      Left = 136
      Top = 16
      Width = 81
      Height = 16
      Caption = 'State: Ready!'
    end
    object TextEdit: TEdit
      Left = 10
      Top = 98
      Width = 343
      Height = 24
      ReadOnly = True
      TabOrder = 0
    end
    object Button1: TButton
      Left = 8
      Top = 40
      Width = 145
      Height = 25
      Caption = 'Recognize!'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 160
      Top = 40
      Width = 89
      Height = 25
      Caption = 'Clear text'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 256
      Top = 40
      Width = 97
      Height = 25
      Caption = 'Clear image'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Gauge: TProgressBar
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Smooth = True
      TabOrder = 4
    end
  end
  object Menu: TMainMenu
    Left = 432
    Top = 8
    object AppHeader: TMenuItem
      Caption = 'OCR'
      object OptionsMenu: TMenuItem
        Caption = 'Options'
        object CenterCharMenu: TMenuItem
          Caption = 'Centrage du caractere'
          Checked = True
          OnClick = CenterCharMenuClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object QuitMenu: TMenuItem
        Caption = 'Quitter'
        OnClick = QuitMenuClick
      end
    end
    object ModelsHeader: TMenuItem
      Caption = 'Modeles'
      object ShowModelMenu: TMenuItem
        Caption = 'Voir un modele'
        OnClick = ShowModelMenuClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object WeightMenu: TMenuItem
        Caption = 'Voir les poids de similitude'
        OnClick = WeightMenuClick
      end
    end
  end
end
