unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure MyIdle(Sender: TObject; var Done: Boolean);
    procedure MyMassage(var Msg: TMsg; var Handled: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  i: Integer;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.MyIdle(Sender: TObject; var Done: Boolean);
begin
  inc(i);
  Form1.Caption := IntToStr(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := MyIdle;
  Application.OnMessage := MyMassage;
end;

procedure TForm1.MyMassage(var Msg: TMsg; var Handled: Boolean);
begin
  Beep;
end;

end.
