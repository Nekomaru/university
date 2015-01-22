unit Unit2;

interface

uses
  Classes, Unit1, WinSock2;

type
  TServer = class(TThread)
    constructor Create(ASocket: TSocket);
  private
    HostEntClient: PHostEnt;
    Client_Socket: TSocket;
    Client_addr: TSockAddr;
    Client_addr_size: Integer;
    ServerSocket: TSocket;
  protected
    procedure Execute; override;
  end;

var
    CountClients: Integer = 0;


implementation

{ TServer }

constructor TServer.Create(ASocket: TSocket);
begin
  ServerSocket := ASocket;
  FreeOnTerminate := True;
  CountClients := 0;
  inherited Create(False);
end;

procedure TServer.Execute;
begin
  While true do begin
    if Terminated then begin
      closesocket(ServerSocket);
      exit;
    end;
    Client_addr_size := sizeof(Client_Addr);
    Client_Socket := accept(ServerSocket, Client_Addr, Client_addr_size); //передача третьего параметра производится через отдельную переменную, а не вызывается функция sizeof
    if Client_Socket = SOCKET_ERROR then begin
      closesocket(ServerSocket);
      exit;
    end;
    HostEntClient := gethostbyaddr(@Client_addr.sin_addr.S_addr, 4, AF_INET);
    inc(CountClients);
    WriteLn('Connect client "', HostEntClient.h_name,'" to Server. Count client: ', CountClients);
    TServerThread.Create(Client_Socket, HostEntClient.h_name);
  end;
end;

end.
 