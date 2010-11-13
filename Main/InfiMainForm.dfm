object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Calc^e'
  ClientHeight = 311
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 109
    Width = 15
    Height = 25
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 479
    Width = 12
    Height = 13
    Caption = '...'
  end
  object LabelCentral: TLabel
    Left = 8
    Top = 85
    Width = 80
    Height = 80
    Caption = #8721
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -80
    Font.Name = 'MS PGothic'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LabelInferior: TLabel
    Left = 22
    Top = 163
    Width = 61
    Height = 27
    Caption = 'N = 1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS PGothic'
    Font.Style = []
    ParentFont = False
  end
  object LabelSuperior: TLabel
    Left = 32
    Top = 68
    Width = 16
    Height = 27
    Caption = 'K'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS PGothic'
    Font.Style = []
    ParentFont = False
  end
  object LabelDerecha: TLabel
    Left = 86
    Top = 107
    Width = 17
    Height = 27
    Caption = 'N'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS PGothic'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 0
    Top = 0
    Width = 922
    Height = 13
    Align = alTop
    Alignment = taRightJustify
    Caption = 'Calculos Auxiliares                      '
    ExplicitLeft = 768
    ExplicitWidth = 154
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 294
    Width = 922
    Height = 17
    Align = alBottom
    Max = 1000
    Step = 1
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 173
    Top = 34
    Width = 500
    Height = 239
    Align = alCustom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar2: TProgressBar
    Left = 912
    Top = 13
    Width = 10
    Height = 281
    Align = alRight
    Max = 1000
    Orientation = pbVertical
    Step = 1
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 704
    Top = 13
    Width = 208
    Height = 281
    Align = alRight
    Enabled = False
    TabOrder = 3
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 80
  end
  object MainMenu1: TMainMenu
    Left = 40
    object Menu1: TMenuItem
      Caption = 'Menu'
      object Subiraftp1: TMenuItem
        Caption = 'Subir a ftp'
        OnClick = Subiraftp1Click
      end
      object Salir1: TMenuItem
        Caption = 'Salir'
        OnClick = Salir1Click
      end
    end
    object Acciones1: TMenuItem
      Caption = 'Operaciones'
      object Sumardoscifras1: TMenuItem
        Caption = 'A + B (Suma)'
        OnClick = Sumardoscifras1Click
      end
      object Restardoscifras1: TMenuItem
        Caption = 'A - B (Resta)'
        OnClick = Restardoscifras1Click
      end
      object multiplicardoscifras1: TMenuItem
        Caption = 'A x B (Producto)'
        OnClick = multiplicardoscifras1Click
      end
      object DividirdosCifras1: TMenuItem
        Caption = 'A / B (Cociente)'
        OnClick = DividirdosCifras1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Potencia1: TMenuItem
        Caption = 'A ^ B (Potencia)'
        OnClick = Potencia1Click
      end
    end
    object Algoritmos1: TMenuItem
      Caption = 'Algoritmos'
      object FactorialdeK1: TMenuItem
        Caption = 'Factorial de K'
        OnClick = FactorialdeK1Click
      end
      object CalcularEuler: TMenuItem
        Caption = 'Calcular '#39'e'#39' (N'#250'mero de Euler)'
        OnClick = CalcularEulerClick
      end
    end
    object Rendimiento1: TMenuItem
      Caption = 'Rendimiento'
      object N1CPU1: TMenuItem
        Caption = '1 Proceso'
        Checked = True
        Default = True
        RadioItem = True
        OnClick = N1CPU1Click
      end
      object N2CPU1: TMenuItem
        Caption = '4 Procesos'
        RadioItem = True
        OnClick = N2CPU1Click
      end
      object NCPU1: TMenuItem
        Caption = 'N*X PC'#39's (N procesos * maquinas)'
        RadioItem = True
        OnClick = NCPU1Click
      end
    end
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    AutoLogin = True
    Username = 'ariel'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 8
  end
end
