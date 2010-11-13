unit InfiServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls,

  Parameters,Algoritmia, extendedtype, Sockets, ScktComp, ComCtrls, ClientManager, TaskManager,
  Grids, TeCanvas, Menus, JvProgressBar, JvComponentBase, JvComputerInfoEx;

type

  TForm2 = class(TForm)
    Button1: TButton;
    Label6: TLabel;
    MemoResult: TMemo;
    Button2: TButton;
    ServerSocket1: TServerSocket;
    StatusBar1: TStatusBar;
    Button3: TButton;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    Parametros1: TMenuItem;
    GlobalProgressBar: TJvGradientProgressBar;
    Panel1: TPanel;
    TicTask: TTimer;
    JvComputerInfoEx1: TJvComputerInfoEx;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ServerSocket1Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button2Click(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure TicTaskTimer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure Parametros1Click(Sender: TObject);
  private
    { Private declarations }
     IdDisconnected : word;
     ClientList : TListClients;
  public
    { Public declarations }
    AllPaused : Boolean;
    CheckIndex : Word;
    TestMessage : AnsiString;
    BufferMessages : TStrings;
    DataClient : TDataClientRec;
    GlobalResult : VeryLongByte;
    Procedure ManageReceiveData(Data : TDataClientRec);
  //  Function BuscarNeuronaDesconectada : Word;
    Procedure ResynchroniseClient(Data:TDataClientRec);
    Function SendSignalResynchronise (Index:integer):Boolean;
    Procedure RepairPackets (Packets : TStrings);
    procedure UpdateStatusListBox;
  end;

var
  Form2: TForm2;

implementation

Const
  MaxEuler = 100;


{$R *.dfm}

procedure TForm2.UpdateStatusListBox;
Var
  Neuronas : TStrings;
Begin
  ListBox1.Clear;
  GenerateClientsNameList (Neuronas);
  Neuronas.BeginUpdate;
  ListBox1.Items.Strings[0] := 'Neuronas Totales: '+IntToStr(Neuronas.Count);
  ListBox1.Items.Strings[1] := 'Neuronas Activas: '+IntToStr(clientsonload);
  ListBox1.Items.Strings[2] := 'Tareas Pendientes: '+IntToStr(TaskManager_TotalSubTask);
  ListBox1.Items.Strings[3] := '---------------------------';
  ListBox1.Items.Strings[4] := 'Neuronas Conectadas:';
  ListBox1.Items.AddStrings(Neuronas);
  If (TaskManager_TotalSubTask>0) then
  Begin
    if (Neuronas.Count = 0)  then
      StatusBar1.Panels[3].Text := 'No puedo pensar sin neuronas :('
    else
      StatusBar1.Panels[3].Text := 'Pensando...  '+ IntToStr( clientsonload *100 div Neuronas.count)+'% de uso.';
  End
 Else
  if not ServerSocket1.Active then
      StatusBar1.Panels[3].Text := 'Activa el cerebro y conectale neuronas ;)'
    Else
      StatusBar1.Panels[3].Text := 'Nada que hacer.';
  Neuronas.Destroy;
End;

  {
Function TForm2.BuscarNeuronaDesconectada : Word;

     Procedure ReconnectAllClients;
     Var
        Data : TDataClientRec;
        Cur : TListClients;
        s : word;
      Begin
        Data.Status := False;
        Cur := ClientList;
        for s := 0 to ClientList^.Fore.Data.Socket - 1 do
          ServerSocket1.Socket.Connections [s].SendText(PackDataClient(Data));
      End;
var
  CantSockets : word;
Begin
  ReconnectAllClients;
  while CantUnconect > 0 do
  Begin
     if TestMessage <>'' then
      Begin
        UnpackStringClient(TestMessage)
      End;
  End;
End;
 }
Function TForm2.SendSignalResynchronise (Index:integer):Boolean;
var
  CheckSignal : TDataClientRec;

begin
   ShowMessage (inttostr(index)+'<'+inttostr(ServerSocket1.Socket.ActiveConnections));
   if Index < ServerSocket1.Socket.ActiveConnections then
      Begin
       // ShowMessage( 'enviando a '+inttostr(index)+' pausando');
        CheckSignal.Status := false;
        CheckSignal.Value.CrearCifra('0');
        ServerSocket1.Socket.Connections[Index].SendText(PackDataClient(CheckSignal));
        CheckSignal.Value.Destruir;
        Result := True;
      End
    else
      Result := False;
End;


Procedure TForm2.ResynchroniseClient(Data:TDataClientRec);
Begin
   Data.Status := True;
   Data.MaxTo := 0;
   Data.From := 0;
   Data.Value.CrearCifra('0');
   Data := GetClientData(AddClient(Data));
   ServerSocket1.Socket.Connections[Data.Socket].SendText( PackDataClient(Data) );
end;

Procedure TForm2.RepairPackets (Packets : TStrings);
Var
  C : word;
  p : TDataClientRec;
Begin
  C := 0;
  while C < Packets.Count do
  Begin
    p := UnpackStringClient(Packets.Strings[c]);
  //  p.Socket := GetClientData (p.Id).Socket;
    ManageReceiveData(P);
    Inc (c);
  End;
  Packets.Clear;
End;


 {
Procedure TForm2.RepairTaskList;
var
  Cur : TListClients;
  data : TDataClientRec;
begin
  while Aux^.Next <> ErrorClientList do
  Begin
   data := GetClientData (Aux^.Data.Id);
   if Data.Id = 0 then  // fue el desconectado
      TaskManager_RestartTaskInfo(Aux^.Data.Id);// la tarea no esta mas asignada al desconectado
   Aux := Aux^.Next;
  End;
  Cur := ClientList;
  ClientList := ErrorClientList;
  FreeClientList;
  ClientList := Cur;
end;
  }

Procedure TForm2.ManageReceiveData(Data : TDataClientRec);
Begin
  AllPaused := True;
  if  (Data.Status = false) and (Data.Value.ToAnsiString = '+0') then
  Begin
     Data.Status := True;
     Data.Active := False;
     Data.MaxTo := 0;
     Data.From := 0;
     Data.Value.CrearCifra('0');
     Data := GetClientData(AddClient(Data));
     ServerSocket1.Socket.Connections[Data.Socket].SendText( PackDataClient( Data ) );
  End
  else
  if Data.Status = false then
    Begin
      ShowMessage(data.Name+' desconectado');
      CheckIndex := 1;
      FreeClientList;
      SetClientList(ClientList);
      ServerSocket1.Socket.Disconnect(Data.Socket);

   //   While SendSignalResynchronise(CheckIndex-1) do
     //      inc(CheckIndex);

      TaskManager_RestartTaskInfo(Data.Id);// la tarea no esta mas asignada al desconectado
      CheckIndex := 0;
     End
  Else
    Begin
      TaskManager_CompleteTaskInfo(Data.Id);
      Data.Value.SCifra := Data.Value.ToAnsiString;
      if Data.Value.SCifra[2]= '1' then
          MemoResult.Lines.Add( '0,'+Copy(Data.Value.SCifra,3,Length(Data.Value.SCifra)))
      else
          MemoResult.Lines.Add( '2,'+Copy(Data.Value.SCifra,3,Length(Data.Value.SCifra)));
      GlobalResult := GlobalResult + Data.Value;
      Edit1.Text := GlobalResult.ToAnsiString;
      Edit1.Text := ('2,'+Copy(Edit1.TExt,4,Length(Edit1.text)));
      Data.Value.CrearCifra(UIntToStr(InfoParameters.Precision));
      Data.From := 0;
      Data.MaxTo := 0;
      Data.Active := false;
      ModifyClient(Data.Id,Data);
      ServerSocket1.Socket.Connections[Data.Socket].SendText( PackDataClient( Data ) );
      GlobalProgressBar.StepBy(1);
    End;
  UpdateStatusListBox;
  AllPaused :=  Button3.Caption = 'Continuar';
End;


procedure TForm2.Parametros1Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  TaskManager_GenerateTask(1,InfoParameters.Hasta,InfoParameters.MaxNeuronas);
  GlobalProgressBar.Position := 0;
  GlobalProgressBar.Max := StrToInt ( inttoStr(TaskManager_TotalSubTask));
  StatusBar1.Panels[3].Text := 'Se han generado tareas';
  UpdateStatusListBox;
  Button1.Enabled := False;
  Button3.Enabled := True;
  TicTask.Enabled := True;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if Button2.Caption = 'Crear Cerebro' then
    Begin
      MainMenu1.Items.Items[0].Enabled := False;
      SetClientList(ClientList);
      ServerSocket1.Port := 9900;
      Button1.Enabled := True;
      Button3.Enabled := False;
      ServerSocket1.Active := true;
      StatusBar1.Panels[3].Text := 'No puedo pensar sin neuronas :(';
      Button2.Caption := 'Destruir Cerebro';
    End
  Else
    Begin
      MainMenu1.Items.Items[0].Enabled := True;
      TicTask.Enabled := False;
      ServerSocket1.Active := False;
      TaskManager_Destroy;
      FreeClientList;
      BufferMessages.Clear;
      TaskManager_Destroy;
      GlobalResult.CrearCifra('0');
      Button1.Enabled := False;
      StatusBar1.Panels[3].Text := '';
      Button3.Enabled := False;
      Button2.Caption := 'Crear Cerebro';
      StatusBar1.Panels[3].Text := 'Activa el cerebro y conectale neuronas ;)';
      GlobalProgressBar.Position := 0;
      MemoResult.Clear;
    End;
  UpdateStatusListBox;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if  not AllPaused then
    Begin
      AllPaused := true;
      Button3.Caption := 'Continuar';
      StatusBar1.Panels[3].Text := 'Descansando';
    End
  Else
  Begin
      AllPaused := false;
      Button3.Caption := 'Pausar';
      StatusBar1.Panels[3].Text := '';
      RepairPackets(BufferMessages);
   End;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  AllPaused := False;
  CheckIndex := 0;
  BufferMessages := TStringList.Create;
  ServerSocket1.Active := false;
  ClientList := NIL;
  GlobalResult.CrearCifra('0');
  StatusBar1.Panels[3].Text := 'Crea,Activa el cerebro y conectale neuronas ;)'
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  ServerSocket1.Active := False;
end;

procedure TForm2.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   UpdateStatusListBox;
end;

procedure TForm2.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  CheckSignal : TDataClientRec;
begin

//  Errorcode := 0;
  {
  if CheckIndex = 0 then
  Begin
    AllPaused := True;
    ErrorClientList := ClientList;
   // ClientList := NIL;
    ShowMessage (ErrorClientList^.Data.Name);
 //   FreeClientList;
    If SendSignalResynchronise(CheckIndex) then
      inc(CheckIndex)
    else
    Begin
      TaskManager_RestartTaskInfo(ClientList^.Data.Id);
      AllPaused := False
    End;
 End;
  }

end;

procedure TForm2.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
  var
    aux:ansistring;
begin
aux := Socket.ReceiveText;
//ShowMessage(aux);
if Socket.Connected then
  if  (AllPaused) then
    Begin
     //  TestMessage := Socket.ReceiveText;
    {   if (CheckIndex > 0) and (UnpackStringClient(TestMessage).Status = false) then
       // si es una respuesta auxiliar para desconectar
       Begin
        ShowMessage( 'resincronizar');
        // ResynchroniseClient(UnpackStringClient(TestMessage));
         While SendSignalResynchronise(CheckIndex-1) do
           inc(CheckIndex);

         TaskManager_RestartTaskInfo(IdDisconnected);// la tarea no esta mas asignada al desconectado
         CheckIndex := 0;
         AllPaused := Button3.Caption = 'Continuar';
       End
       Else
      }  BufferMessages.Add(aux);
          Showmessage('servidor saturado... carga de buffer +N');
    End
  Else
    ManageReceiveData (UnpackStringClient(aux));
end;

procedure TForm2.ServerSocket1Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
  StatusBar1.Panels[1].Text := Socket.LocalHost;
end;

procedure TForm2.TicTaskTimer(Sender: TObject);
var
  InfoTask : TInfoTask;
  Client  : TListClients;
begin
 if Not AllPaused then
 Begin
  Client := GetFreeClient;
  InfoTask := TaskManager_GetTask;
  if InfoTask.Id > 0 then
      Begin
        if Client <> NIL then
          Begin
            Client^.Data.Active := True;
            Client^.Data.From := InfoTask.VN;
            Client^.Data.MaxTo := InfoTask.VK;
            Client^.Data.Value.CrearCifra(UintToStr(InfoParameters.Precision));
            TaskManager_SetUserTask (InfoTask.Id,Client^.Data.Id);  // le asigno un usuario a la tarea
            StatusBar1.Panels[3].Text := 'Envio de solicitud: '+uinttostr(InfoTask.VK);
            ServerSocket1.Socket.Connections[Client^.Data.Socket].SendText( PackDataClient( Client^.Data ) );
            StatusBar1.Panels[3].Text := 'Pensando';
          End;
    End
  else
    Begin
      if (ClientsOnLoad = 0) and (BufferMessages.Count = 0) then
        Begin
          StatusBar1.Panels[3].Text := 'Todas las tareas fueron finalizadas.';
          MemoResult.Lines.Add('----------------');
          GlobalResult.SCifra := GlobalResult.ToAnsiString;
          MemoResult.Lines.Add('2,'+Copy(GlobalResult.SCifra,4,Length(GlobalResult.SCifra)));
          TicTask.Enabled := False;
        End;
    End;

     UpdateStatusListBox;
 End;
end;

end.
