unit FacThread;


Interface

uses
  Classes,ExtendedType,StdCtrls,ComCtrls;

type
  TFactThread = class(TThread)
  private
    KTerminos,
    NSeries    : Cardinal;
  protected
    Function Factorial :VeryLongByte;
    procedure Execute; override;
  public
    Finish : boolean;
    resultado : VeryLongByte;
    property Hasta : Cardinal read NSeries write KTerminos;
    property SubSeries : Cardinal read NSeries write NSeries;
   end;


   TFacListThread = ^TNodeThread;

   TNodeThread = Record
    Thread : TFactThread;
    Fore,Next : TFacListThread;
   End;


Procedure NewFactThread (var List: TFacListThread;KFactorial,SubSeries:Cardinal;Bar: TProgressBar;Text : TMemo);

Function FinishedProcessFactList (List : TFacListThread):Boolean;

Procedure DestroyProcessFactList(var List : TFacListThread);

Function ResultFactList (ListThreads:TFacListThread):VeryLongByte;


implementation

uses SysUtils, Dialogs;


var
      ProgressBar    : TProgressBar;
      Memo         : TMemo;



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

Procedure AddThread (var List :TFacListThread ;Thread:TFactThread);
var
  T : TFacListThread;
Begin
  if List = NIL then
    Begin
      New (List);
      List^.Next := List;
      List^.Thread := Thread;
      List^.Fore := List;
    End
  Else
    Begin
      New (T);
      T^.Thread := Thread;
      T^.Next := List;
      T^.Fore := List^.Fore;
      List^.Fore^.Next := T;
      List^.Fore := T;
    End;


End;

Procedure NewFactThread (var List: TFacListThread;KFactorial,SubSeries:Cardinal;Bar: TProgressBar;Text : TMemo);
var
 NThread: TFactThread;

Begin
  NThread := TFactThread.Create(True);
  NThread.FreeOnTerminate := False;
  ProgressBar := Bar;
  Memo := Text;
  if SubSeries < 1 then
    NThread.NSeries := 1
  else
    NThread.NSeries := SubSeries;
  NThread.KTerminos :=  KFactorial;
  AddThread (List,NThread);
  NThread.Resume;
End;


Function FinishedProcessFactList (List : TFacListThread):Boolean;
var
  r : boolean;
  cur : TFacListThread;
Begin
   r := false;
   if List <> NIL then
   Begin
    r := List^.Thread.Finish;
    cur := List^.Next;
    while (List <> Cur) and R  do
    Begin
      r := r and Cur^.Thread.Finish;
      Cur := Cur^.Next;
    End;
   End;
   Result := r;
End;


Procedure DestroyProcessFactList(var List : TFacListThread);
var
  cur,
  basura : TFacListThread;
Begin
  if List<>NIL then
  Begin
    cur := List;
    while Cur^.Next <> List do
      Begin
        Basura := Cur;
        Cur := Cur^.Next;
        Basura.Thread.resultado.Destruir;
        Basura.Thread.Destroy;
        Dispose (Basura);
      End;
   List^.Thread.resultado.Destruir;
   List := NIL;
  End;
End;



Function ResultFactList (ListThreads:TFacListThread):VeryLongByte;
var
  CurT : TFacListThread;
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

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

Procedure Productoria(var acumulador:VeryLongByte;Contador,hasta:Cardinal);
var
  Producto : VeryLongByte;
Begin
  while Contador <= Hasta do
  Begin
    Producto.CrearCifra(UIntToStr(Contador));
    acumulador := acumulador * Producto;
    Producto.Destruir;
    Contador := Contador + 1;
  End;
End;

// maximo = total a dividir en sub-productorias
// factor seria el valor dcomo "tope" del contador para cada una de las sub-productorias
// acumulador = se genera un resultado de las sub-productorias que no entran

Procedure DividirEnProductorias (var Acumulador:VeryLongByte;var Factor: Cardinal;var Maximo : Cardinal;Factorial : Cardinal);
var
  Resto : Cardinal;
Begin
  Factor := Factorial;
  if Factorial < Maximo then
    Maximo := 1
  else
  if Factorial mod Maximo = 0 then
     Begin
       Factor := Factor div Maximo;
     End
     else
      Begin
       resto := Factorial mod Maximo;
       Factor := (Factorial - resto) div Maximo;
       Productoria (Acumulador,Factorial-Resto+1,Factorial);
      End;
End;


Function TFactThread.Factorial: VeryLongByte;
var
  Sum : VeryLongByte;
  T,N,K,loop : Cardinal;
  T1 : TTimeStamp;
Begin
  Sum.CrearCifra('1');
  DividirEnProductorias (Sum,T,NSeries,KTerminos);
  ProgressBar.Position := 0;
  ProgressBar.Max := NSeries;
  Memo.Clear;
  Memo.Lines.Add(UIntToStr(KTerminos)+'! Iniciado. Calculando en 10 ciclos.');
  Memo.Lines.Add('');
  T1:= DateTimeToTimeStamp(Now);

 for Loop := 1 to NSeries do
 Begin
    K := T * loop;
    Productoria (Sum,N,K);
    Memo.Lines.Add(inttostr( DateTimeToTimeStamp(Now).Time -T1.Time)+' ms --> Loop '+inttostr(loop)+' terminado.');
    ProgressBar.StepBy(1);
    ProgressBar.Repaint;
    N := K + 1;
 End;
 Result := Sum;
end;

procedure TFactThread.Execute;
begin
  Finish := false;
  Resultado.CrearCifra('0');
  Resultado := Factorial;
  Resultado.SCifra := Resultado.ToAnsiString;
  Finish := true;
end;

end.
