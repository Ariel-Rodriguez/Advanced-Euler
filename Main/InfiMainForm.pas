unit InfiMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ExtendedType, pngimage, Menus,

  FacThread,Primethread, Algoritmia, InfiServer, Filectrl, IdBaseComponent,
  IdZLibCompressorBase, IdCompressorZLib, JvBaseDlg, JvCalc, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP;

type
  TForm1 = class(TForm)
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    Acciones1: TMenuItem;
    Sumardoscifras1: TMenuItem;
    Restardoscifras1: TMenuItem;
    multiplicardoscifras1: TMenuItem;
    DividirdosCifras1: TMenuItem;
    Salir1: TMenuItem;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    LabelCentral: TLabel;
    LabelInferior: TLabel;
    LabelSuperior: TLabel;
    LabelDerecha: TLabel;
    Algoritmos1: TMenuItem;
    FactorialdeK1: TMenuItem;
    Rendimiento1: TMenuItem;
    N1CPU1: TMenuItem;
    N2CPU1: TMenuItem;
    NCPU1: TMenuItem;
    CalcularEuler: TMenuItem;
    N1: TMenuItem;
    Potencia1: TMenuItem;
    ProgressBar2: TProgressBar;
    Memo2: TMemo;
    Label3: TLabel;
    IdFTP1: TIdFTP;
    Subiraftp1: TMenuItem;
    procedure Sumardoscifras1Click(Sender: TObject);
    procedure Restardoscifras1Click(Sender: TObject);
    procedure multiplicardoscifras1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FactorialdeK1Click(Sender: TObject);
    procedure N1CPU1Click(Sender: TObject);
    procedure DividirdosCifras1Click(Sender: TObject);
    procedure Potencia1Click(Sender: TObject);
    procedure CalcularEulerClick(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure N2CPU1Click(Sender: TObject);
    procedure NCPU1Click(Sender: TObject);
    procedure Subiraftp1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
     FacListThread : TFacListThread;
     ListaProcesos : TlistThread;
     t1,t2 : TTimeStamp;
  end;


var
  Form1: TForm1;


implementation



{$R *.dfm}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

Procedure AgregarEnMemo (var Memo:TMemo;cifra:AnsiString);
var
  C : Cardinal;
  aux : string;
Begin
  aux := '';
  c:=1;
  Memo.Clear;
   While cifra[C]<>'' do
   begin
      Aux := Aux + Cifra[c];
      if C mod 10 = 0 then
        Aux := Aux + '   ';
      if C mod 50 = 0 then
        Begin
          memo.Lines.Add (Aux);
          Aux := '';
        End;
      if C mod 500 = 0 then
        Begin
          memo.Lines.Add ('');
          memo.Lines.Add ('');
          Aux := '';
        End;
      inc(c);
   end;
    memo.Lines.Add (Aux);
    Form1.Label2.Caption := uINTtOsTR(c-1);
End;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

Function LeerDosCifras (var A:VeryLongByte;var B:VeryLongByte;Titulo,Prg1,Prg2:String):Boolean;
var
  inp : Ansistring;
Begin
  Inp := InputBox (Titulo,Prg1,'');
  if length (inp)>0 then
  Begin
    A.CrearCifra(inp);
    Inp := InputBox(Titulo,Prg2,'');
    if length (inp)>0 then
      Begin
        B.CrearCifra(Inp);
        Result := True;
      End
      Else
        Begin
          A.Destruir;
          Result := false;
        End;
  End
  else
    Result := false;
End;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TForm1.CalcularEulerClick(Sender: TObject);
var
  C : cardinal;
  error : byte;
  inp : ansistring;
begin
  inp := InputBox('Calcular Factorial e','Ingrese el valor de K:',inp);
  if length(inp)>0 then
  Begin
    LabelCentral.Caption := '∑';
    LabelInferior.Caption := 'N=1';
    LabelSuperior.Caption := Inp;
    LabelDerecha.Caption := '1 / N!';
  T1:= DateTimeToTimeStamp(Now);
  c := StrToInt64(inp);
  if (C<20)  then
  c := 20;

  if N1CPU1.Checked then

    NewThread(ListaProcesos,1,C,C,ProgressBar1,ProgressBar2,Memo1,Memo2)

  Else
    Begin
      NewThread(ListaProcesos,1,(C div 4),C,ProgressBar1,ProgressBar2,Memo1,Memo2);
      sleep (100);
      NewThread(ListaProcesos,(C div 4)+1,(C div 2),C,ProgressBar1,ProgressBar2,Memo1,Memo2);
      sleep (100);
      NewThread(ListaProcesos, C div 2+1,(C div 4)*3,C,ProgressBar1,ProgressBar2,Memo1,Memo2);
      sleep (100);
      NewThread(ListaProcesos,(C div 4)*3+1,C ,C ,ProgressBar1,ProgressBar2,Memo1,Memo2);
    End;
   Timer1.Enabled := True;
  End;
end;

procedure TForm1.DividirdosCifras1Click(Sender: TObject);
var
  A,B,R : VeryLongByte;
Begin
 if LeerDosCifras (A,B,'Dividir','Ingrese el valor de A:','Ingrese el valor de B:') then
 Begin
  R.CrearCifra('0');
  R := A/B;
  Agregarenmemo(memo1, R.ToAnsiString);
  R.Destruir;
  B.Destruir;
  A.Destruir;
 End;
end;

procedure TForm1.FactorialdeK1Click(Sender: TObject);
var
  A : VeryLongByte;
  inp : ansistring;
begin
  inp := InputBox('Calcular Factorial de K','Ingrese el valor de K:',inp);
  if length(inp)>0 then
  Begin
    LabelCentral.Caption := 'π';
    LabelInferior.Caption := 'N=1';
    LabelSuperior.Caption := Inp;
    LabelDerecha.Caption := 'N';
    Form1.Repaint;
    Memo1.Clear;
    T1:= DateTimeToTimeStamp(Now);
    Timer1.Enabled := true;

    NewFactThread(FacListThread,StrToInt64Def(inp,1),100,ProgressBar1,Memo1);
  End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListaProcesos := NIL;
end;

procedure TForm1.multiplicardoscifras1Click(Sender: TObject);
var
  A,B,R : VeryLongByte;
Begin
 if LeerDosCifras (A,B,'Producto','Ingrese el valor de A:','Ingrese el valor de B:') then
 Begin
  R.CrearCifra('0');
  R := A*B;
  Agregarenmemo(memo1, R.ToAnsiString);
  R.Destruir;
  B.Destruir;
  A.Destruir;
 End;
end;


procedure TForm1.N1CPU1Click(Sender: TObject);
begin
  N1CPU1.Checked := True;
  N2CPU1.Checked := False;
  NCPU1.Checked := False;
end;

procedure TForm1.N2CPU1Click(Sender: TObject);
begin
  N1CPU1.Checked := False;
  N2CPU1.Checked := True;
  NCPU1.Checked := False;
end;

procedure TForm1.NCPU1Click(Sender: TObject);
Const
  SelDirHelp = 0000;
var
  Dir : String;
begin
    N1CPU1.Checked := False;
    N2CPU1.Checked := False;
    NCPU1.Checked := True;
    Form2.Show;
end;

procedure TForm1.Potencia1Click(Sender: TObject);
var
  A,B,R : VeryLongByte;
Begin
 if LeerDosCifras (A,B,'Potencia','Ingrese el valor de A (Base):','Ingrese el valor de B (Exponente):') then
 Begin
  R.CrearCifra('0');
  R := PotenciaDeNumero(A,B);
  Agregarenmemo(memo1, R.ToAnsiString);
  R.Destruir;
  B.Destruir;
  A.Destruir;
 End;
end;

procedure TForm1.Restardoscifras1Click(Sender: TObject);
var
  A,B,R : VeryLongByte;
Begin
 if LeerDosCifras (A,B,'Restar','Ingrese el valor de A:','Ingrese el valor de B:') then
 Begin
  R.CrearCifra('0');
  R := A-B;
  Agregarenmemo(memo1, R.ToAnsiString);
  R.Destruir;
  B.Destruir;
  A.Destruir;
 End;
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Subiraftp1Click(Sender: TObject);
begin
  IdFTP1.Host := InputBox('Conectar con servidor','IP:','');
  IdFTP1.Username := 'ariel';
  IdFTP1.Connect;
  if IdFTP1.Connected then
  Begin
    Showmessage ('Conectado a:'+IdFTP1.Host);
  End;
end;

procedure TForm1.Sumardoscifras1Click(Sender: TObject);
var
  A,B,R : VeryLongByte;
Begin
 if LeerDosCifras (A,B,'Sumar','Ingrese el valor de A:','Ingrese el valor de B:') then
 Begin
  R.CrearCifra('0');
  R := A+B;
  Agregarenmemo(memo1, R.ToAnsiString);
  R.Destruir;
  B.Destruir;
  A.Destruir;
 End;
end;


Function ResultadoEmpaquetado (ListThreads:TListThread):VeryLongByte;
var
  CurT : TListThread;
  Aux,R : VeryLongByte;
  error : Cardinal;
Begin
 Error := 0;
 R.CrearCifra('0');
 if ListThreads^.Next <> ListThreads  then
  Begin
    Aux.CrearCifra(ListThreads^.Thread.resultado.ToAnsiString);
    Aux.AgregarCeroADerecha(ListThreads^.Fore^.Thread.resultado.Longitud - ListThreads^.Thread.resultado.Longitud);
    R.CrearCifra(Aux.ToAnsiString);
    CurT := ListThreads^.Next;
    Error := 1;
    While CurT <> ListThreads^.Fore do
    Begin
      Aux.CrearCifra(CurT^.Thread.resultado.ToAnsiString);
      Aux.AgregarCeroADerecha(ListThreads^.Fore^.Thread.resultado.Longitud - CurT^.Thread.resultado.Longitud);
      R := R + Aux;
      CurT := CurT^.Next;
      Inc(Error);
    End;
    R := R + ListThreads^.Fore^.thread.resultado;
    Aux.CrearCifra(Uinttostr(Error));
    Aux.AgregarCeroADerecha(R.Longitud - Aux.Longitud);
    R := R - Aux;
    Result := R;
 End
Else
 Result := ListThreads^.Thread.resultado;
End;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (FinishedProcessFactList(FacListThread)) OR (FinishedProcessList(ListaProcesos)) then
    Begin
      Timer1.Enabled := false;
      Form1.t2 := DateTimeToTimeStamp(Now);
      Form1.t2.Time := ABS(t2.Time - t1.Time);
      if FinishedProcessFactList(FacListThread) then
        Begin
          Agregarenmemo(Memo1, ResultFactList(FacListThread).ToAnsiString);
          DestroyProcessFactList(FacListThread);
        End
      Else
      if FinishedProcessList(ListaProcesos) then
        Begin
          Agregarenmemo(Memo1, ResultadoEmpaquetado(ListaProcesos).ToAnsiString);
          DestroyProcessList(ListaProcesos);
        End;
      if T2.Time < 1000 then
        Showmessage ('Calculado en: '+UintToStr(T2.Time)+' ms')
      else
         Showmessage ('Calculado en: '+TimeToStr(TimeStampToDateTime(T2))+'.'+IntToStr (t2.Time mod 1000));
      ProgressBar1.Position := 0;
    End;
end;



end.
