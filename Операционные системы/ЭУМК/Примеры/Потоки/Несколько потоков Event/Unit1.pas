unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit2, Spin, Math, ComCtrls, SyncObjs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit2: TSpinEdit;
    Label4: TLabel;
    SpinEdit3: TSpinEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TCalcThread = class(TThread)
    Value, Res: Real;
    Count: Integer;
    constructor Create(v: Real; C: Integer);
  private
    { Private declarations }
  protected
    procedure Show;
    procedure Execute; override;
  end;
  function Period(value: real; count: Integer): real; stdcall;

var
  Form1: TForm1;
  CalcThread: TCalcThread;
  Event: TEvent;
  res: TWaitResult;

implementation

function Period(value: real; count: Integer): real; external 'ND.dll' name 'Period';

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  Randomize;
  Memo1.Clear;
  Memo1.Lines.Add('Угол;Порядок -> Период');
  Event := TEvent.Create(nil, True, True, 'event');
  for i := 1 to SpinEdit3.Value do begin
//    Event.SetEvent;
    Event.ReSetEvent;
    CalcThread := TCalcThread.Create(SpinEdit2.Value * i, Round((Random(10) + 1) * power(10, SpinEdit1.Value)));
//    Event.ReSetEvent;
    res := Event.WaitFor(10000);
//    res := Event.WaitFor(INFINITE);
    case res of
    wrSignaled: Memo1.Lines.Add('Событие произошло');
    wrTimeout: Memo1.Lines.Add('Событие не произошло');
    wrAbandoned: Memo1.Lines.Add('Событие Abandoned');
    wrError: Memo1.Lines.Add('Ошибка');
    end;
//    Memo1.Lines.Add(IntToStr(Integer(res)));
//    ShowMessage(IntToStr(Integer(res)));
  end;
  Event.Free;
end;

constructor TCalcThread.Create(v: Real; C: Integer);
begin
  Value := v;
  Count := c;
  inherited Create(False);
end;

procedure TCalcThread.Execute;
begin
  FreeOnTerminate := True;
//  Unit1.res := Event.WaitFor(10000);
  Res := Period(Value, Count);
  Synchronize(Show);
//  Event.ReSetEvent;
  Event.SetEvent;
end;

procedure TCalcThread.Show;
begin
  Form1.Memo1.Lines.Add(FloatToStr(Value) + ';' + IntToStr(Count) + ' -> ' + FloatToStr(Res));
end;

end.
