unit Parameters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeCanvas, Menus;

type

  TInfoParameters = Record
      Seleccion : Byte;
      Precision,
      N,
      Desde,Hasta : Cardinal;
      MaxNeuronas : Word;
  End;

  TForm3 = class(TForm)
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    Label2: TLabel;
    ComboFlat2: TComboFlat;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    Editar1: TMenuItem;
    procedure Editar1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboFlat2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  InfoParameters : TInfoParameters;

implementation

{$R *.dfm}

const
    enteros : Set of char = ['0'..'9'];



procedure TForm3.Button1Click(Sender: TObject);
begin
  InfoParameters.Seleccion := ComboFlat2.ItemIndex;
  case InfoParameters.Seleccion of
  0:
    Begin
    InfoParameters.Precision := StrToInt64(ListBox2.Items.Strings[  ListBox1.Items.IndexOf('Precision')]);
    InfoParameters.Hasta := StrToInt64(ListBox2.Items.Strings[  ListBox1.Items.IndexOf('Total de Series')]);
    End;
  1:
    InfoParameters.N := StrToInt64(ListBox2.Items.Strings[  ListBox1.Items.IndexOf('Factorial')]);
  4:
    Begin
      InfoParameters.Precision := 100;
      InfoParameters.Hasta := 0;
    End;
  end;
  InfoParameters.MaxNeuronas := StrToIntDef(ComboFlat1.Items.Strings[ComboFlat1.ItemIndex],High(word));
  Form3.Hide;
end;

procedure TForm3.ComboFlat2Change(Sender: TObject);
begin
 ListBox1.Clear;
 ListBox2.Clear;
 ListBox2.Enabled := true;
case ComboFlat2.ItemIndex of
  0:
    Begin
      ListBox1.Items.Add('Precision');
      ListBox1.Items.Add('Total de Series');
      if InfoParameters.Seleccion = 0 then
        Begin
          ListBox2.Items.Add(UIntToStr(InfoParameters.Precision));
          ListBox2.Items.Add(UIntToStr(InfoParameters.Hasta));
        End
      Else
        Begin
          ListBox2.Items.Add('100');
          ListBox2.Items.Add('80');
        End;
    End;
  1:
    Begin
      ListBox1.Items.Add('Factorial');
      if InfoParameters.Seleccion = 1 then
        Begin
          ListBox2.Items.Add(UIntToStr(InfoParameters.N));
        End
      Else
        Begin
          ListBox2.Items.Add('9000');
        End;
    End;
  4:
    Begin
      ListBox1.Items.Add('Benchmark Mode!');
      ListBox2.Items.Add('1 minuto de duración.');
      ListBox2.Enabled := false;
    End;

  end;

end;

procedure TForm3.Editar1Click(Sender: TObject);
var
  aux : AnsiString;
  c : word;
begin
  aux := InputBox('Editar '+ListBox1.Items.Strings[ListBox2.ItemIndex],'Valor:','');
  if Aux <> '' then
    Begin
    ListBox2.Items.Strings[ListBox2.ItemIndex] := '';
    c := Length(Aux);
    if C > 0 then
      for C := 1 to Length(Aux) do
        if Aux[c] in enteros then
          ListBox2.Items.Strings[ListBox2.ItemIndex] := ListBox2.Items.Strings[ListBox2.ItemIndex] + Aux[c];

    if ListBox2.Items.Strings[ListBox2.ItemIndex]='' then
      ListBox2.Items.Strings[ListBox2.ItemIndex] := '0';
    End;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  InfoParameters.Seleccion := 0;
  InfoParameters.Precision := 100;
  InfoParameters.Desde := 1;
  InfoParameters.Hasta := 80;
  InfoParameters.MaxNeuronas := 1000;
end;

end.
