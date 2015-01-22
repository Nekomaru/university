unit Unit2;

interface

uses
  Classes;

type
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

implementation

uses Unit1, SysUtils;

function Period(value: real; count: Integer): real; external 'ND.dll' name 'Period';

{ TCalcThread }

constructor TCalcThread.Create(v: Real; C: Integer);
begin
  Value := v;
  Count := c;
  inherited Create(False);
end;

procedure TCalcThread.Execute;
begin
  Res := Period(Value, Count);
  Synchronize(Show);
end;

procedure TCalcThread.Show;
begin
  Form1.Memo1.Lines.Add(FloatToStr(Value) + ';' + IntToStr(Count) + ' -> ' + FloatToStr(Res));
end;

end.
