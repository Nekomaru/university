unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit2, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SimpleThread: TSimpleThread;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SimpleThread := TSimpleThread.Create(False);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Label1.Caption := 'Результат = ' + IntToStr(SimpleThread.Resultat);
  SimpleThread.Terminate;
end;

end.
