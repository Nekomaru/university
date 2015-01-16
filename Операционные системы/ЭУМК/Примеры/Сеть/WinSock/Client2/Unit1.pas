unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, WinSock2;

const
  WM_SOCKET = WM_USER + 100;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AppMessage(var Msg:Tmsg; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ASocket: TSocket;
  GInitData : TWSADATA;
  addr: TSockAddr;

implementation

{$R *.dfm}

procedure TForm1.AppMessage(var Msg: Tmsg; var Handled: Boolean);
var
  i, Byte_recv: Integer;
begin
  if Msg.message = WM_SOCKET then begin
    if Msg.lParam=FD_READ then begin
      Handled := True;
      Byte_recv := recv(ASocket, i, sizeof(Integer), 0);
      if Byte_recv = SOCKET_ERROR then begin
        ShowMessage('Сервер отключен');
        Label5.Caption := '';
        closesocket(ASocket);
        WSACleanup;
        Button1.Caption := 'Подключиться';
        GroupBox2.Enabled := False;
        exit;
      end;
      if i = 0 then begin
        Label5.Caption := 'Число угадано';
        closesocket(ASocket);
        WSACleanup;
        Button1.Caption := 'Подключиться';
        GroupBox2.Enabled := False;
        exit;
      end;
      if i = -1 then begin
        Label5.Caption := 'Ваше число меньше загаданного';
        exit;
      end;
      if i = 1 then begin
        Label5.Caption := 'Ваше число больше загаданного';
        exit;
      end;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string[6];
begin
  if Button1.Caption = 'Подключиться' then begin
    WSAStartup($0202, GInitData);
    ASocket := Socket(AF_INET, SOCK_STREAM, 0);
    addr.sin_family := AF_INET;
//    addr.sin_addr.S_addr := 0; // или INADDR_ANY
    addr.sin_addr := TInAddr(inet_addr(PChar(Edit1.Text)));
    addr.sin_port := htons(StrToInt(Edit2.Text));
    connect(ASocket, @addr, sizeof(addr));
    if WSAGetLastError = 0 then begin
      Button1.Caption := 'Разорвать';
      GroupBox2.Enabled := True;
      recv(ASocket, s, 7, 0);
      ShowMessage(s);
      WSAAsyncSelect(ASocket, Application.Handle, WM_SOCKET, FD_READ); //реакция на получение данных, позволяет незавешивать компьютер пока ждем ответ
    end
    else begin
      ShowMessage('Ошибка');
    end;
  end
  else begin
    closesocket(ASocket);
    WSACleanup;
    Button1.Caption := 'Подключиться';
    GroupBox2.Enabled := False;
  end;
end;
procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  Label5.Caption := '';
  i := StrToInt(Edit3.Text);
  send(ASocket, i, sizeof(Integer), 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
end;

end.
