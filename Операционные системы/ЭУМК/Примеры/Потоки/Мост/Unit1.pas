unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SyncObjs, Menus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Shape1: TShape;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TCarThread = class(TThread)
    Orientation: Boolean;   // true-слева направо
    Speed: Integer;         // скорость в мсек
    Owner: TComponent;      // где отображать
    Weight: Integer;        // вес груза
    constructor Create(O: TComponent; i: Integer);
  private
    flagUp, flagDown: Boolean;
    Shape: TShape;          // внешний вид
    ALabel: TLabel;         // вес груза
  protected
    procedure Execute; override;
  end;

const
  MaxWeight: Integer = 100;
  MaxCar: Byte = 10;

var
  Form1: TForm1;
  hSem: THandle = 0;
  ACar: array [1..10] of TCarThread;
  CommonWeight: Integer;

implementation

{$R *.dfm}

{ TCarThread }

constructor TCarThread.Create(O: TComponent; i: Integer);
begin
  Orientation := Boolean(Random(2));
  Weight := (Random(10) + 1) * 10;
  Speed := (Random(10) + 1) * 100;
  Owner := O;
  Shape := TShape.Create(Owner);
  Shape.Parent := TWinControl(Owner);
  Shape.Height := 50;
  Shape.Width := 100;
  Shape.Brush.Color := TColor(Random(High(Integer)));
  if Orientation then begin
    Shape.Left := 0;
    Shape.Top := 115;
  end
  else begin
    Shape.Left := 600;
    Shape.Top := 55;
  end;
  ALabel := TLabel.Create(Owner);
  ALabel.Parent := TWinControl(Owner);
  ALabel.Caption := IntToStr(Weight);
  ALabel.Height := - ALabel.Font.Height;
  ALabel.Width := 20;
  if Orientation then begin
    ALabel.Left := 0;
    ALabel.Top := 115;
  end
  else begin
    ALabel.Left := 600;
    ALabel.Top := 55;
  end;
  FreeOnTerminate := True;
  flagDown := True;
  inherited Create(False);
end;

procedure TCarThread.Execute;
var
  WaitReturn: Cardinal;
begin
  if Orientation then begin
    while Shape.Left < 600 do begin
      if Terminated then exit;
      if (Shape.Left >= 100) and (Shape.Left <= 500) then begin
        if not flagUp then begin
          WaitReturn := WaitForSingleObject(hSem, INFINITE);
          if WaitReturn = WAIT_OBJECT_0 then begin
            if CommonWeight + Weight <= MaxWeight then begin
              CommonWeight := CommonWeight + Weight;
              flagUp := True;
              flagDown := False;
            end
            else begin
              ReleaseSemaphore(hSem, 1, nil);
              continue;
            end;
          end
          else begin
            ShowMessage('Ошибка при работе с семафором.');
            exit;
          end;
        end;
      end
      else begin
        if not flagDown then begin
          flagDown := True;
          ReleaseSemaphore(hSem, 1, nil);
          CommonWeight := CommonWeight - Weight;
        end;
      end;
      Shape.Left := Shape.Left + 10;
      ALabel.Left := Shape.Left;
      TForm1(Owner).Label2.Caption := IntToStr(CommonWeight);
      TWinControl(Owner).Repaint;
      Sleep(Speed);
    end;
  end
  else begin
    while Shape.Left > 0 do begin
      if Terminated then exit;
      if (Shape.Left >= 100) and (Shape.Left <= 500) then begin
        if not flagUp then begin
          WaitReturn := WaitForSingleObject(hSem, INFINITE);
          if WaitReturn = WAIT_OBJECT_0 then begin
            if CommonWeight + Weight <= MaxWeight then begin
              CommonWeight := CommonWeight + Weight;
              flagUp := True;
              flagDown := False;
            end
            else begin
              ReleaseSemaphore(hSem, 1, nil);
              continue;
            end;
          end
          else begin
            ShowMessage('Ошибка при работе с семафором.');
            exit;
          end;
        end;
      end
      else begin
        if not flagDown then begin
          flagDown := True;
          ReleaseSemaphore(hSem, 1, nil);
          CommonWeight := CommonWeight - Weight;
        end;
      end;
      Shape.Left := Shape.Left - 10;
      ALabel.Left := Shape.Left;
      TForm1(Owner).Label2.Caption := IntToStr(CommonWeight);
      TWinControl(Owner).Repaint;
      Sleep(Speed);
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to MaxCar do begin
    ACar[i] := TCarThread.Create(self, i);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  CommonWeight := 0;
  Label2.Caption := IntToStr(CommonWeight);
  hSem := CreateSemaphore(nil, MaxCar, MaxCar, nil);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseHandle(hSem);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to MaxCar do begin
    ACar[i].Terminate;
  end;
end;

end.
