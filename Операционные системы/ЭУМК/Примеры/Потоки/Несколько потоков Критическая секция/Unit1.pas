unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Math, ComCtrls, SyncObjs;

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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Output(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TCalcThread = class(TThread)
    Value: Real;
//    Res: Real;
    Count: Integer;
    constructor Create(v: Real; C: Integer);
  private
    { Private declarations }
  protected
    procedure Show;
    procedure Execute; override;
  end;
  TAnswer = record
    Value: Real;
    Res: Real;
    Count: Integer;
  end;
  function Period(value: real; count: Integer): real; stdcall;

var
  Form1: TForm1;
  CalcThread: TCalcThread;
  Section: TCriticalSection;
  Number: Integer = 0;
  Answer: array [1..100] of TAnswer;
  CountTerminate: Integer = 0;

implementation

function Period(value: real; count: Integer): real; external 'ND.dll' name 'Period';

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  Randomize;
  Section := TCriticalSection.Create;
  Number := 0;
  CountTerminate := 0;
  Memo1.Clear;
  Memo1.Lines.Add('Угол;Порядок -> Период');
  for i := 1 to SpinEdit3.Value do begin
    CalcThread := TCalcThread.Create(SpinEdit2.Value * i, Round((Random(10) + 1) * power(10, SpinEdit1.Value)));
//    sleep(100);
  end;
end;

{ TCalcThread }

constructor TCalcThread.Create(v: Real; C: Integer);
begin
  Value := v;
  Count := c;
  OnTerminate := Form1.Output;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TCalcThread.Execute;
begin
  Section.Enter;
  try
    inc(Number);
//    Res := Period(Value, Count);
    Answer[Number].Value := Value;
    Answer[Number].Count := Count;
    Answer[Number].Res := Period(Value, Count);
//    Synchronize(Show);
  finally
  Section.Leave;
  end;
end;

procedure TCalcThread.Show;
begin
//  Form1.Memo1.Lines.Add(FloatToStr(Value) + ';' + IntToStr(Count) + ' -> ' + FloatToStr(Res));
//  Form1.Memo1.Lines.Add(FloatToStr(Answer[Number].Value) + ';' + IntToStr(Answer[Number].Count) + ' -> ' + FloatToStr(Answer[Number].Res));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Section.Free;
end;

procedure TForm1.Output(Sender: TObject);
var
  i: Integer;
begin
  inc(CountTerminate);
  if CountTerminate = SpinEdit3.Value then begin
    for i := 1 to SpinEdit3.Value do begin
      Form1.Memo1.Lines.Add(FloatToStr(Answer[i].Value) + ';' + IntToStr(Answer[i].Count) + ' -> ' + FloatToStr(Answer[i].Res));
    end;
  end;
end;

end.
