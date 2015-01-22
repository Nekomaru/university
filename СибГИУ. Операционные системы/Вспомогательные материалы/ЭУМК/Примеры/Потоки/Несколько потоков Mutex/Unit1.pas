unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Math, ComCtrls, IpcThrd;

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
//  hMutex: TMutex;
  hMutex: THandle;

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
//  hMutex := TMutex.Create('test');
  hMutex := CreateMutex(nil, False, nil);
  for i := 1 to SpinEdit3.Value do begin
//    if hMutex.Get(INFINITE) then begin
    if WaitForSingleObject(hMutex, INFINITE) = WAIT_OBJECT_0 then begin
      CalcThread := TCalcThread.Create(SpinEdit2.Value * i, Round((Random(10) + 1) * power(10, SpinEdit1.Value)));
    end;
  end;
end;

constructor TCalcThread.Create(v: Real; C: Integer);
begin
  Value := v;
  Count := c;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TCalcThread.Execute;
begin
//  if hMutex.Get(INFINITE) then begin
    Res := Period(Value, Count);
    Synchronize(Show);
//    hMutex.Release;
   ReleaseMutex(hMutex);
//  end;
end;

procedure TCalcThread.Show;
begin
  Form1.Memo1.Lines.Add(FloatToStr(Value) + ';' + IntToStr(Count) + ' -> ' + FloatToStr(Res));
end;

end.
