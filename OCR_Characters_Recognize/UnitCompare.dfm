object CompareForm: TCompareForm
  Left = 936
  Top = 130
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Weight resemblance'
  ClientHeight = 591
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object List: TStringGrid
    Left = 0
    Top = 0
    Width = 291
    Height = 591
    Align = alClient
    ColCount = 2
    DefaultColWidth = 110
    DefaultRowHeight = 18
    Enabled = False
    FixedCols = 0
    RowCount = 28
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 0
    ColWidths = (
      130
      136)
  end
end
