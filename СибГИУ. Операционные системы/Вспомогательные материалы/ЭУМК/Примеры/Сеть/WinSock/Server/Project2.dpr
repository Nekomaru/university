program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  WinSock2,
  Unit1 in 'Unit1.pas',
  Unit2 in 'Unit2.pas';

var
  ASocket: TSocket;
  GInitData : TWSADATA;
  addr: TSockAddr;
//  CountClients: Integer = 0;
//  HostEnt, HostEntClient: PHostEnt;
//  Client_Socket: TSocket;
//  Client_addr: TSockAddr;
//  Client_addr_size: Integer;
  Server: TServer;
  str: string;

begin
  Randomize;
  WriteLn('Initialize Server...');

  WriteLn('->Initialize Socket...');
  WSAStartup($0202, GInitData); //похоже можно передать любую константу, кроме нуля
  if WSAGetLastError = 0 then begin
//  if WSAStartup($0202, GInitData) = 0 then begin
    WriteLn('-->', GInitData.szDescription, ' is ', GInitData.szSystemStatus);
  end
  else begin
    WriteLn('-->Error to WSAStartup: ', WSAGetLastError);
    ReadLn;
    exit;
  end;

  WriteLn('->Create Socket...');
  ASocket := Socket(AF_INET, SOCK_STREAM, 0);
  if WSAGetLastError = 0 then begin
    WriteLn('-->Socket ', ASocket, ' is create');
  end
  else begin
    WriteLn('-->Error to Socket create: ', WSAGetLastError);
    WSACleanup;
    ReadLn;
    exit;
  end;

  WriteLn('->Bind Socket with IP-address...');
  addr.sin_family := AF_INET;
  addr.sin_addr.S_addr := 0; // или INADDR_ANY
//  addr.sin_addr := TInAddr(inet_addr(PChar('127.0.0.1')));
//  addr.sin_addr := TInAddr(inet_addr(PChar(ParamStr(1))));
{  HostEnt := gethostbyname(PChar('localhost'));
  addr.sin_addr.S_un_b.s_b1 := Byte(HostEnt^.h_addr^[0]);
  addr.sin_addr.S_un_b.s_b2 := Byte(HostEnt^.h_addr^[1]);
  addr.sin_addr.S_un_b.s_b3 := Byte(HostEnt^.h_addr^[2]);
  addr.sin_addr.S_un_b.s_b4 := Byte(HostEnt^.h_addr^[3]); }
//  addr.sin_port := htons(1025);
  addr.sin_port := htons(StrToInt(ParamStr(2)));
  Bind(ASocket, @addr, sizeof(addr));
  if WSAGetLastError = 0 then begin
    WriteLn('-->Bind Socket with IP-address: ', addr.sin_addr.S_un_b.s_b1, '.', addr.sin_addr.S_un_b.s_b2, '.', addr.sin_addr.S_un_b.s_b3, '.', addr.sin_addr.S_un_b.s_b4, '; Port: ', ntohs(addr.sin_port));
  end
  else begin
    WriteLn('-->Error to bind Socket with IP-address: ', WSAGetLastError);
    closesocket(ASocket);
    WSACleanup;
    ReadLn;
    exit;
  end;

  WriteLn('->Listen Socket...');
  listen(ASocket, SOMAXCONN);  //максимальное для ядра количество подключений
  if WSAGetLastError = 0 then begin
    WriteLn('-->Socket is listen');
  end
  else begin
    WriteLn('-->Error to listen Socket: ', WSAGetLastError);
    closesocket(ASocket);
    WSACleanup;
    ReadLn;
    exit;
  end;

  WriteLn('Server is run.');
  Server := TServer.Create(ASocket);
{  While true do begin
    Client_addr_size := sizeof(Client_Addr);
    Client_Socket := accept(ASocket, Client_Addr, Client_addr_size); //передача третьего параметра производится через отдельную переменную, а не вызывается функция sizeof
    HostEntClient := gethostbyaddr(@Client_addr.sin_addr.S_addr, 4, AF_INET);
    inc(CountClients);  
    WriteLn('Connect client to Server. Count client: ', CountClients, ' Host name: ', HostEntClient.h_name);
    TServerThread.Create(Client_Socket);
  end; }
  repeat
    readln(str);
  until str='q';
  Server.Terminate;
//  readln;
  closesocket(ASocket);
  WSACleanup;
end.
