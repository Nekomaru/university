unit Unit2;

interface

uses
  Classes;

type
  TSimpleThread = class(TThread)
    Resultat: Integer;
    ii: Integer;
    private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TSimpleTread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TSimpleTread }

procedure TSimpleThread.Execute;
var
  i: Integer;
begin
  FreeOnTerminate := True;
  Resultat := 0;   ii := 0;
  for i := 1 to 200000000 do begin
    if Terminated then Break;
     inc(ii);
     Resultat := Resultat + Round(Abs(Sin(Sqrt(i))));
  end;
end;

end.
