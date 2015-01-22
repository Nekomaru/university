unit Unit1;

interface

uses
    SysUtils, Classes, WinSock2;

type
  TServerThread = class(TThread)
    constructor Create(ASocket: TSocket; AClientName: String);
  private
    ClientSocket: TSocket;
    ClientName: String;
    Mind: Integer;
    function Check(AValue: Integer): Integer;
  protected
    procedure Execute; override;
  end;

implementation

uses Unit2;

{ TServerThread }

function TServerThread.Check(AValue: Integer): Integer;
begin
  if AValue < Mind then begin
    Result := -1;
    exit;
  end;
  if AValue > Mind then begin
    Result := 1;
    exit;
  end;
  if AValue = Mind then begin
    Result := 0;
    exit;
  end;
end;

constructor TServerThread.Create(ASocket: TSocket; AClientName: String);
begin
  ClientSocket := ASocket;
  ClientName := AClientName;
  FreeOnTerminate := True;
  Mind := Random(100) + 1;
  WriteLn('For client ', ClientName, 'mind digit: ', Mind);
  inherited Create(False);
end;

procedure TServerThread.Execute;
var
  Buf: String[6];
  Byte_recv: Integer;
  Answer, ResultCheck: Integer;
begin
  Buf := 'Hello!';
  send(ClientSocket, Buf, 7, 0);
  while true do begin
    Byte_recv := recv(ClientSocket, Answer, sizeof(Integer), 0);
    Sleep(1000);
    if Byte_recv = SOCKET_ERROR then begin
      dec(CountClients);
      WriteLn('Disconnect client "', ClientName, '" to Server. Count client: ', CountClients);
      closesocket(ClientSocket);
      exit;
    end
    else begin
      WriteLn('From Client "', ClientName, '" recieve: ', Answer);
    end;
    ResultCheck := Check(Answer);
    send(ClientSocket, ResultCheck, sizeof(Integer), 0);
    if Terminated then begin
      closesocket(ClientSocket);
      exit;
    end;
  end;
end;

end.
 