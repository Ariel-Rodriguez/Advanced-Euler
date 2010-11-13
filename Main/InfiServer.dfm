object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cerebro'
  ClientHeight = 528
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 0
    Top = 169
    Width = 117
    Height = 28
    Caption = 'Calculo Global:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Segoe Print'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GlobalProgressBar: TJvGradientProgressBar
    Left = 0
    Top = 492
    Width = 563
    Height = 17
    BarColorFrom = clBlack
    BarColorTo = clLime
    Smooth = True
    Align = alBottom
    ParentColor = True
    ExplicitTop = 471
    ExplicitWidth = 462
  end
  object Label1: TLabel
    Left = 208
    Top = 202
    Width = 146
    Height = 28
    Caption = 'Calculos entrantes'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Segoe Print'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 563
    Height = 169
    Align = alTop
    TabOrder = 6
  end
  object Button1: TButton
    Left = 8
    Top = 123
    Width = 129
    Height = 30
    Caption = 'Activar Cerebro'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object MemoResult: TMemo
    Left = 0
    Top = 236
    Width = 563
    Height = 256
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 8
    Width = 129
    Height = 29
    Caption = 'Crear Cerebro'
    TabOrder = 2
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 509
    Width = 563
    Height = 19
    Panels = <
      item
        Text = 'Cerebro:'
        Width = 50
      end
      item
        Width = 100
      end
      item
        Text = 'Estado:'
        Width = 50
      end
      item
        Width = 250
      end
      item
        Width = 50
      end
      item
        Style = psOwnerDraw
        Width = 50
      end>
  end
  object Button3: TButton
    Left = 416
    Top = 121
    Width = 129
    Height = 34
    Caption = 'Pausa'
    Enabled = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 161
    Top = 0
    Width = 249
    Height = 153
    Enabled = False
    ItemHeight = 13
    Items.Strings = (
      'Neuronas Totales:'
      'Neuronas Activas:'
      'Tareas Pendientes:'
      '---------------------------'
      'Neuronas Conectadas: ')
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 123
    Top = 175
    Width = 440
    Height = 21
    TabOrder = 7
    Text = '0'
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 9901
    ServerType = stNonBlocking
    OnListen = ServerSocket1Listen
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 640
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 16
    object Parametros1: TMenuItem
      Caption = 'Configuraci'#243'n'
      OnClick = Parametros1Click
    end
  end
  object TicTask: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TicTaskTimer
    Left = 720
    Top = 8
  end
  object JvComputerInfoEx1: TJvComputerInfoEx
    Left = 520
    Top = 184
  end
end
