unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SyncObjs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TSimpleThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Show;
  end;


var
  Form1: TForm1;
  SimpleThread: TSimpleThread;
  e:TEvent;
  res: TWaitResult;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
  SimpleThread := TSimpleThread.Create(false);
end;

{ TSimpleThread }

procedure TSimpleThread.Execute;
begin
  e := TEvent.Create(nil, true, false, 'test');
  repeat
    e.ResetEvent;
//    res := e.WaitFor(10000);
    res := e.WaitFor(INFINITE);
    Synchronize(Show);
  until Terminated;
  e.Free;
end;

procedure TSimpleThread.Show;
begin
    case res of
    wrSignaled: Form1.Memo1.Lines.Add('Событие произошло');
    wrTimeout: Form1.Memo1.Lines.Add('Событие не произошло');
    wrAbandoned: Form1.Memo1.Lines.Add('Событие Abandoned');
    wrError: Form1.Memo1.Lines.Add('Ошибка');
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  e.SetEvent;
end;

end.
