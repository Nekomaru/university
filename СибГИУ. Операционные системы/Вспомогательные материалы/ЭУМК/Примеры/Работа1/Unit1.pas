unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Unit2, Buttons;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Panel3: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ListBox1: TListBox;
    Label3: TLabel;
    ListBox2: TListBox;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Timer1: TTimer;
    Label7: TLabel;
    Timer2: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WriteToLog(Text: String);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function ContextProcessByID(ID: Integer): PContext;
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  TabSheet : array [0..9] of TTabSheet;
  ListBox: array [0..9] of TListBox;
  ALabel: array [0..3, 0..9] of TLabel;
  Process: array [0..9] of TProcess;        //������ ���������
  Processor: TProcessor;                    //������ ����������
  IODevice: TProcessor;                     //������ ���������� �����/������
  Readys: PDescriptorStack;                 //������ �� ������� �������
  Waits: PDescriptorStack;                  //������ �� ������� ���������
  StateReadys, StateWaits: TStateStack;     //��������� ��������

implementation

{$R *.dfm}

//�������� ��������:
//ID - ����������������� ����� ��������
//Name - �������� ��������
//Memory - ���������� ������/, ����������� ��������
function CreateProccess(ID: Integer; Name: String; Memory: Integer): TProcess;
begin
  with Result.Descriptor do begin
    PID := ID;
    Kvant := 2;
    State := spNone;
    Prioritet := ppNormal;
  end;
  New(Result.Context);
  Result.Context^.PID := ID;
  Result.Context^.CommandLine := 0;
  Result.Context^.CountRun := 0;
  Result.Context^.Command := cMEMORY;
  Result.Context^.CurrentRun := 0;
  Result.Context^.Name := Name;
  Result.Context^.Memory := Memory;
end;

//������ � ���
procedure TForm1.WriteToLog(Text: String);
begin
  Memo1.Lines.Add(Text);
end;

//��������� ������ ������� ��������
procedure TForm1.Button1Click(Sender: TObject);
begin
  if PageControl1.PageCount = 10 then begin
    ShowMessage('������ ��������� ������!');
    exit;
  end;
  if OpenDialog1.Execute then begin
    //������� ������� ��� ����� �������
    TabSheet[PageControl1.PageCount] := TTabSheet.Create(Self);
    TabSheet[PageControl1.PageCount].Caption := '�������' + IntToStr(PageControl1.PageCount + 1);
    TabSheet[PageControl1.PageCount].PageControl := PageControl1;
    ListBox[PageControl1.PageCount-1] := TListBox.Create(Self);
    ListBox[PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[0,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[0,PageControl1.PageCount-1].Caption := '����� = ';
    ALabel[0,PageControl1.PageCount-1].Top := 5;
    ALabel[0,PageControl1.PageCount-1].Left := 5;
    ALabel[0,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[1,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[1,PageControl1.PageCount-1].Caption := '��������� = ';
    ALabel[1,PageControl1.PageCount-1].Top := 20;
    ALabel[1,PageControl1.PageCount-1].Left := 5;
    ALabel[1,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[2,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[2,PageControl1.PageCount-1].Caption := '��������� = ';
    ALabel[2,PageControl1.PageCount-1].Top := 35;
    ALabel[2,PageControl1.PageCount-1].Left := 5;
    ALabel[2,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[3,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[3,PageControl1.PageCount-1].Caption := '������� ������� = ';
    ALabel[3,PageControl1.PageCount-1].Top := 50;
    ALabel[3,PageControl1.PageCount-1].Left := 5;
    ALabel[3,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    PageControl1.ActivePageIndex := PageControl1.PageCount-1;
    PageControl1.ActivePage.Align := alClient;
    ListBox[PageControl1.PageCount-1].Align  := alBottom;
    ListBox[PageControl1.PageCount-1].Height := trunc(PageControl1.ActivePage.Height-70);
    ListBox[PageControl1.PageCount-1].Items.LoadFromFile(OpenDialog1.FileName);
    ListBox[PageControl1.PageCount-1].ItemIndex := -1;
    //�������� ��������
    Process[PageControl1.PageCount-1] := CreateProccess(PageControl1.PageCount-1,
                                                        TabSheet[PageControl1.PageCount-1].Caption,
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[0]));
    ALabel[0,PageControl1.PageCount-1].Caption := '����� = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant);
    ALabel[1,PageControl1.PageCount-1].Caption := '��������� = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State);
    ALabel[2,PageControl1.PageCount-1].Caption := '��������� = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet);;
    ALabel[3,PageControl1.PageCount-1].Caption := '������� ������� = ' + CommandToStr(Process[PageControl1.PageCount-1].Context^.Command);
    WriteToLog('������� ����� ������� � ������ ' + Process[PageControl1.PageCount-1].Context^.Name +
               ' (����� = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant) +
               '; ��������� = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State) +
               '; ��������� = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet) + ')');
    Panel3.Enabled := True;
    //�������� ������� � ���� �������
    In_Stack(Readys, @Process[PageControl1.ActivePageIndex].Descriptor);
    StateReadys := ssFully;
    ListBox1.Items.Add(Process[PageControl1.ActivePageIndex].Context^.Name);
    WriteToLog('������� ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' ������� � ������� �������');
    //�������� ������������� ���������� � ��������� �����/������
    if not Timer1.Enabled then Timer1.Enabled := True;
    if not Timer2.Enabled then Timer2.Enabled := True;
  end;
end;

//�������� ��� ��������� �����
procedure TForm1.FormActivate(Sender: TObject);
begin
  WriteToLog('��������� ������������� ���������� ������������ ��������� ��������');
  GetMem(Processor.Run, SizeOf(TDescriptor));
  Processor.State := spEmpty;
  Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
  Label6.Caption := '������� = ';
  WriteToLog('������ ���������� ������������');
  GetMem(Readys, SizeOf(TDescriptorStack));
  StateReadys := ssEmpty;
  WriteToLog('������� ������� ������������');
  GetMem(Waits, SizeOf(TDescriptorStack));
  StateWaits := ssEmpty;
  WriteToLog('������� ��������� ������������');
  GetMem(IODevice.Run, SizeOf(TDescriptor));
  IODevice.State := spEmpty;
  WriteToLog('������ ���������� �����/������ ������������');
end;

//���������� ������ ������������� �������, ���� ��� ��������
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if CheckKvantDown(Process[PageControl1.ActivePageIndex].Descriptor.Kvant - 1) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Kvant := Process[PageControl1.ActivePageIndex].Descriptor.Kvant - 1;
    ALabel[0,PageControl1.ActivePageIndex].Caption := '����� = ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant);
    WriteToLog('�������� ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' �������� ����� ������������� ������� �� ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant));
  end
  else begin
    ShowMessage('���������� ������ ������������� ������� ����������!');
  end;
end;

//���������� ������ ������������� �������, ���� ��� ��������
procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if CheckKvantUp(Process[PageControl1.ActivePageIndex].Descriptor.Kvant + 1) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Kvant := Process[PageControl1.ActivePageIndex].Descriptor.Kvant + 1;
    ALabel[0,PageControl1.ActivePageIndex].Caption := '����� = ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant);
    WriteToLog('�������� ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' �������� ����� ������������� ������� �� ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant));
  end
  else begin
    ShowMessage('���������� ������ ������������� ������� ����������!');
  end;
end;

//���������� ���������� �������, ���� ��� ��������
procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  if CheckPriorDown(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Prioritet := TPrioritetProcess(Byte(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) - 1);
    ALabel[2,PageControl1.ActivePageIndex].Caption := '��������� = ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet);
    WriteToLog('�������� ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' �������� ��������� �� ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet));
  end
  else begin
    ShowMessage('���������� ���������� ����������!');
  end;
end;

//���������� ���������� �������, ���� ��� ��������
procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  if CheckPriorUp(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Prioritet := TPrioritetProcess(Byte(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) + 1);
    ALabel[2,PageControl1.ActivePageIndex].Caption := '��������� = ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet);
    WriteToLog('�������� ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' �������� ��������� �� ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet));
  end
  else begin
    ShowMessage('���������� ���������� ����������!');
  end;
end;

//������������� ����������
procedure TForm1.Timer1Timer(Sender: TObject);
var
  CurrentContext: PContext;
begin
  //���� ��������� ��������, �������� ��� ��������� �� ������� �������
  if Processor.State = spEmpty then begin
    if StateReadys = ssEmpty then exit;
    //������� ��������� ������� �� ������� �������
    Out_Stack(Readys, Processor.Run);
    Processor.State := spBusy;
    Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
    CurrentContext := ContextProcessByID(Processor.Run^.PID);
    Label6.Caption := '������� = ' + CurrentContext^.Name;
    ListBox1.Items.Delete(0);
    Processor.Run.State := spRun;
    ALabel[1,Processor.Run^.PID].Caption := '��������� = ' + StateToStr(Processor.Run^.State);
    ALabel[3,Processor.Run^.PID].Caption := '������� ������� = ' + CommandToStr(CurrentContext^.Command);
    WriteToLog('������� ' + CurrentContext^.Name + ' ��������� � ��������� ����������');
    if ListBox1.Items.Count = 0 then StateReadys := ssEmpty;
    //���� ���������� ������� ���������
    if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
      //��������� �� ��������� �������
      CurrentContext^.CommandLine := CurrentContext^.CommandLine + 1;
      CurrentContext^.Command := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentContext^.CommandLine]);
      CurrentContext^.CountRun := ParseInt(ListBox[Processor.Run^.PID].Items[CurrentContext^.CommandLine]);
      CurrentContext^.CurrentRun := 0;
      Label7.Caption := '����������� ' + IntToStr(CurrentContext^.CurrentRun) + ' �� ' + IntToStr(CurrentContext^.CountRun);
      ALabel[1,Processor.Run^.PID].Caption := '��������� = ' + StateToStr(Processor.Run^.State);
      ALabel[3,Processor.Run^.PID].Caption := '������� ������� = ' + CommandToStr(CurrentContext^.Command);
      //���� ������� ���������, �� ���������� ��������,
      if CurrentContext^.Command = cPROCESSOR then begin
      end;
      //���� ������� ����/�����, �� ���������� ������� � ������� ���������
      if CurrentContext^.Command = cIO then begin
        In_Stack(Waits, Processor.Run);
        StateWaits := ssFully;
        ListBox2.Items.Add(CurrentContext^.Name);
        Processor.Run^.State := spWait;
        WriteToLog('������� ' + CurrentContext^.Name + ' ������� � ������� ���������');
        ALabel[1,Processor.Run^.PID].Caption := '��������� = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := '������� ������� = '  + CommandToStr(CurrentContext^.Command);
        //��������� ��������
        Processor.State := spEmpty;
        Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := '������� = -';
        Label7.Caption := '����������� -  �� -';
      end;
      //���� ������� ���, �� ����������� �������
      if CurrentContext^.Command = cNONE then begin
        Processor.Run^.State := spNone;
        WriteToLog('������� ' + CurrentContext^.Name + ' ��������');
        ALabel[1,Processor.Run^.PID].Caption := '��������� = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := '������� ������� = '  + CommandToStr(CurrentContext^.Command);
        //��������� ��������
        Processor.State := spEmpty;
        Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := '������� = -';
        Label7.Caption := '����������� -  �� -';
      end;
    end;
  end
  else begin
    //���� ��������� ������ �����-�� �������
    CurrentContext := ContextProcessByID(Processor.Run^.PID);
    //���� �� ������ ������ �������, �� ���������� �� ����������� �� ����� ��� ���������� �������
    if CurrentContext^.Command = cPROCESSOR then begin
      CurrentContext^.CurrentRun := CurrentContext^.CurrentRun + 1;
      //���� ������� ��������� �����
      if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
        //�� ��������� ������� � ������ �������
        In_Stack(Readys, Processor.Run);
        StateReadys := ssFully;
        ListBox1.Items.Add(CurrentContext^.Name);
        WriteToLog('������� ' + CurrentContext^.Name + ' ������� � ������� �������');
        Processor.Run^.State := spReady;
        ALabel[1,Processor.Run^.PID].Caption := '��������� = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := '������� ������� = -';
        //��������� ��������
        //�� �������� ���������� ������� ��������� ������� �� ������� �������, ��
        //��� ������ ����������� ������ ����������, ������� ��� �� ��������� ������
        Processor.State := spEmpty;
        Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := '������� = -';
        Label7.Caption := '����������� -  �� -';
      end
      else begin
        //���� ���, �� ������� ���������� �����
        if CurrentContext^.CurrentRun mod Processor.Run^.Kvant = 0 then begin
          Label7.Caption := '����������� ' + IntToStr(CurrentContext^.CurrentRun) + ' �� ' + IntToStr(CurrentContext^.CountRun);
        end;
      end;
    end
    else begin
    end;
  end;
end;

//����������� ��������� �������� �� �������������� ����� ��������
function TForm1.ContextProcessByID(ID: Integer): PContext;
var
  i: Integer;
begin
   for i := 0 to PageControl1.PageCount-1 do begin
     if Process[i].Descriptor.PID = ID then begin
       Result := Process[i].Context;
       exit;
     end;
   end;
   Result := nil;
end;

//������������� ��������� �����/������
procedure TForm1.Timer2Timer(Sender: TObject);
var
  CurrentContext: PContext;
begin
  //���� ���������� ����� �� ������, �� �������� ��� ������
  if IODevice.State = spEmpty then begin
    //���� ������ ��������� �������� �����/������ ����, �� ������ �� ������
    if StateWaits = ssEmpty then exit;
    //������� ��������� ������� �� ������� ���������
    Out_Stack(Waits, IODevice.Run);
    IODevice.State := spBusy;
    CurrentContext := ContextProcessByID(IODevice.Run^.PID);
    ListBox2.Items.Delete(0);
    IODevice.Run.State := spRun;
    ALabel[1,IODevice.Run^.PID].Caption := '��������� = ' + StateToStr(IODevice.Run^.State);
    ALabel[3,IODevice.Run^.PID].Caption := '������� ������� = ' + CommandToStr(CurrentContext^.Command);
    WriteToLog('������� ' + CurrentContext^.Name + ' ������������ �������� �����/������');
    if ListBox2.Items.Count = 0 then StateWaits := ssEmpty;
  end
  else begin
    //���� ���������� ������ �����-�� �������
    CurrentContext := ContextProcessByID(IODevice.Run^.PID);
    //���� �� ������ ������ �������, �� ���������� �� ����������� �� ����� ��� ���������� �������
    if CurrentContext^.Command = cIO then begin
      CurrentContext^.CurrentRun := CurrentContext^.CurrentRun + 1;
      //���� ������� ��������� �����
      if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
        //�� ��������� ������� � ������ �������
        In_Stack(Readys, IODevice.Run);
        StateReadys := ssFully;
        ListBox1.Items.Add(CurrentContext^.Name);
        WriteToLog('������� ' + CurrentContext^.Name + ' ������� � ������� �������');
        IODevice.Run^.State := spReady;
        ALabel[1,IODevice.Run^.PID].Caption := '��������� = ' + StateToStr(IODevice.Run^.State);
        ALabel[3,IODevice.Run^.PID].Caption := '������� ������� = -';
        //���������� �������� � ����� �������� ��������� �������
        IODevice.State := spEmpty;
        WriteToLog('���������� �����/������ ��������');
      end;
    end;
  end;
end;

end.
