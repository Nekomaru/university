unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit2, Spin, Math, ComCtrls;

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

var
  Form1: TForm1;
  CalcThread: TCalcThread;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  Randomize;
  Memo1.Clear;
  Memo1.Lines.Add('Угол;Порядок -> Период');
  for i := 1 to SpinEdit3.Value do begin
    CalcThread := TCalcThread.Create(SpinEdit2.Value * i, Round((Random(10) + 1) * power(10, SpinEdit1.Value)));
  end;
end;

end.
