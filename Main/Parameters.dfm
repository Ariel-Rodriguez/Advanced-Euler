object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Parametros'
  ClientHeight = 243
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 157
    Height = 13
    Caption = 'Seleccione lo que desea calcular:'
  end
  object Label2: TLabel
    Left = 8
    Top = 193
    Width = 94
    Height = 13
    Caption = 'Maximas Neuronas:'
  end
  object ComboFlat1: TComboFlat
    Left = 8
    Top = 214
    Width = 129
    ItemIndex = 22
    TabOrder = 0
    Text = '1000'
    Items.Strings = (
      'Default'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '12'
      '15'
      '20'
      '25'
      '30'
      '50'
      '60'
      '70'
      '80'
      '100'
      '150'
      '300'
      '500'
      '1000'
      'N')
  end
  object ComboFlat2: TComboFlat
    Left = 8
    Top = 32
    Width = 232
    ItemIndex = 0
    TabOrder = 1
    Text = 'N'#250'mero de Euler'
    OnChange = ComboFlat2Change
    Items.Strings = (
      'N'#250'mero de Euler'
      'N!'
      'Problema de Basilea'
      'C'#225'lculo por Montecarlo'
      'Benchmark (N'#250'mero de Euler)')
  end
  object ListBox1: TListBox
    Left = 8
    Top = 72
    Width = 113
    Height = 113
    BevelEdges = [beLeft, beTop, beBottom]
    BevelKind = bkFlat
    Enabled = False
    ItemHeight = 13
    Items.Strings = (
      'Precision'
      'Total de Series')
    TabOrder = 2
  end
  object ListBox2: TListBox
    Left = 119
    Top = 72
    Width = 121
    Height = 113
    BevelEdges = [beTop, beRight, beBottom]
    BevelKind = bkFlat
    ItemHeight = 13
    Items.Strings = (
      '100'
      '80')
    PopupMenu = PopupMenu1
    TabOrder = 3
  end
  object Button1: TButton
    Left = 174
    Top = 210
    Width = 75
    Height = 25
    Caption = 'Aplicar'
    TabOrder = 4
    OnClick = Button1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 112
    object Editar1: TMenuItem
      Caption = 'Editar'
      OnClick = Editar1Click
    end
  end
end
