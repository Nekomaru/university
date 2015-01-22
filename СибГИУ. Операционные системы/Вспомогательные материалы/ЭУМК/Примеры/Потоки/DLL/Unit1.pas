unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function Period(value: real; count: Integer): real; stdcall;
var
  Form1: TForm1;

implementation

function Period(value: real; count: Integer): real; external 'ND.dll' name 'Period';
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label1.Caption := 'Answer = ' + FloatToStr(Period(10, StrToInt(Edit1.Text)));
end;

end.
