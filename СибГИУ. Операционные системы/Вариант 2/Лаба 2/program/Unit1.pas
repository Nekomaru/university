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
    NewProcessPriorityLabel: TLabel;
    NewProcessPriorityComboBox: TComboBox;
    AwaitingForMemoryListBox: TListBox;
    AwaitingForMemoryLabel: TLabel;
    MemoryInfo: TGroupBox;
    MemoryTotalLabel: TLabel;
    FreeMemoryLabel: TLabel;
    PartitionCountLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WriteToLog(Text: String);
    procedure Timer1Timer(Sender: TObject);
    function ContextProcessByID(ID: Integer): PContext;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  MEMORY_TOTAL = 64 * 1024;             //����� ���-�� ������

var
  CurrentProcessContext: PContext;
  ProcessorTimeUnitLeft: Integer;
  IsIODeviceAvailable: Boolean;
  Form1: TForm1;
  TabSheet : array [0..9] of TTabSheet;
  ListBox: array [0..9] of TListBox;
  ALabel: array [0..3, 0..9] of TLabel;
  Process: array [0..9] of TProcess;        //������ ���������
  Processor: TProcessor;                    //������ ����������
  ReadyProcesses: TReadyQueue;
  PriorityValues: array [0..4] of TPrioritetProcess;
  WaitProcesses: TList;                     //������� ������ ���������
  FreeMemory: integer;                      //���-�� ��������� ������
  PartitionCount: integer;                  //���-�� ��������� ��������
  AwaitingForMemoryProcesses: TList;        //������ ��������� ��������� ������
procedure ReleaseProcessor();
procedure SwitchToNextCommandGroup();
procedure RefreshUI(Form: TForm1);
function IsCurrentProcessExecuted: boolean;
function IsCurrentCommandGroupExecuted: boolean;
procedure MakeWaitProcessesReady;
function IsProcessWithHighestPriorityExist: boolean;
procedure TryToLoadWaitingProcesses;

implementation

{$R *.dfm}
{$Optimization Off}

//�������� ��������:
//ID - ����������������� ����� ��������
//Name - �������� ��������
//Memory - ���������� ������/, ����������� ��������
function CreateProccess(ID: Integer;
    Name: String;
    Memory: Integer;
    FirstCommandGroupTimeUnitCount: Integer;
    FirstCommand: TCommand): TProcess;
begin
  with Result.Descriptor do begin
    PID := ID;
    Kvant := 2;
    State := spNone;
    Prioritet := PriorityValues[Form1.NewProcessPriorityComboBox.ItemIndex];
  end;
  New(Result.Context);
  Result.Context^.PID := ID;
  Result.Context^.CommandLine := 1;
  Result.Context^.CountRun := FirstCommandGroupTimeUnitCount;
  Result.Context^.Command := FirstCommand;
  Result.Context^.CurrentRun := 0;
  Result.Context^.Name := Name;
  Result.Context^.Memory := Memory;
  Result.Context^.IODeviceCapturedByMe := false;
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
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[0]),
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[1]),
                                                        ParseCommand(ListBox[PageControl1.PageCount-1].Items[1]));
    ALabel[0,PageControl1.PageCount-1].Caption := '����� = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant);
    ALabel[1,PageControl1.PageCount-1].Caption := '��������� = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State);
    ALabel[2,PageControl1.PageCount-1].Caption := '��������� = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet);;
    ALabel[3,PageControl1.PageCount-1].Caption := '������� ������� = ' + CommandToStr(Process[PageControl1.PageCount-1].Context^.Command);
    WriteToLog('������� ����� ������� � ������ ' + Process[PageControl1.PageCount-1].Context^.Name +
               ' (����� = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant) +
               '; ��������� = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State) +
               '; ��������� = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet) + ')');
    Panel3.Enabled := True;

    if Process[PageControl1.ActivePageIndex].Context^.Memory <= FreeMemory then
    begin
      FreeMemory := FreeMemory - Process[PageControl1.ActivePageIndex].Context^.Memory;
      PartitionCount := PartitionCount + 1;
      //�������� ������� � ���� �������
      ReadyProcesses.Add(@Process[PageControl1.ActivePageIndex].Descriptor);
      WriteToLog('������� ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' ������� � ������� ��������');
    end
    else
    begin
      //����� ��������� ������� � ������� ��������� ������
      AwaitingForMemoryProcesses.Add(@Process[PageControl1.ActivePageIndex].Descriptor);
      WriteToLog('�� ���������� �����. ' +
        '������� � ������ ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' ������� � ������� ��������� ������');
    end;

    //�������� ������������� ���������� � ��������� �����/������
    if not Timer1.Enabled then Timer1.Enabled := True;
  end;
end;

//�������� ��� ��������� �����
procedure TForm1.FormActivate(Sender: TObject);
var
  i: integer;
begin
  WriteToLog('��������� ������������� ���������� ������������ ��������� ��������');
  GetMem(Processor.Run, SizeOf(TDescriptor));
  Processor.State := spEmpty;
  Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);
  Label6.Caption := '������� = ';
  WriteToLog('������ ���������� ������������');

  IsIODeviceAvailable := true;
  ReadyProcesses := TReadyQueue.Create;
  WriteToLog('������� ������� ��������� �������');

  WaitProcesses := TList.Create;
  WriteToLog('������� ��������� ��������� �������');

  //�������������� ������ �� ���������� ����������
  PriorityValues[0] := ppLowest;
  PriorityValues[1] := ppLow;
  PriorityValues[2] := ppNormal;
  PriorityValues[3] := ppHigh;
  PriorityValues[4] := ppHighest;

  //�������������� ���������� ������
  for i := 0 to High(PriorityValues) do
  begin
    NewProcessPriorityComboBox.Items.Add(PriorToStr(PriorityValues[i]));
  end;

  NewProcessPriorityComboBox.ItemIndex := 4;

  FreeMemory := MEMORY_TOTAL;
  PartitionCount := 0;

  AwaitingForMemoryProcesses := TList.Create;
end;

//������������� ���������� ���������
procedure TForm1.Timer1Timer(Sender: TObject);
var
  PickedProcessDescriptor: PDescriptor;
begin
  //���� ��������� �����������
  if Processor.State = spEmpty then
  begin
    //���� ������� ������� ��������� �����
    if ReadyProcesses.IsEmpty then
    begin
      //�� ������ �� ������
      Exit;
    end;

    //����� ������� �� ������� ������� ���������
    PickedProcessDescriptor :=  ReadyProcesses.PickProcess();

    //��������������� �������� ���������� ��������
    CurrentProcessContext := ContextProcessByID(PickedProcessDescriptor^.PID);

    //��������, ��� ������� �����������
    PickedProcessDescriptor.State := spRun;

    //��������, ��� ��������� ��������� � ������
    Processor.Run := PickedProcessDescriptor;
    Processor.State := spBusy;

    //�������������� ���������� � ���������� �������� ������ ��������
    ProcessorTimeUnitLeft := PickedProcessDescriptor^.Kvant;
  end;

  //��������� �����, ������� �������� ����������� �������� �� �������
  ProcessorTimeUnitLeft := ProcessorTimeUnitLeft - 1;

  //���� �������, ������� ����� ������ ��������� ������� �����/������
  if IsIODeviceAvailable then
    begin
      //����������� ���
      IsIODeviceAvailable := false;
      CurrentProcessContext^.IODeviceCapturedByMe := true;
      WriteToLog(Format('%s �������� ���������� �����/������', [CurrentProcessContext^.Name]));
    end else if not CurrentProcessContext^.IODeviceCapturedByMe then
    begin
      //����� ��������� �� ��������� �� ����� ������
      if ProcessorTimeUnitLeft = 0 then
      begin
        //������� ������� � ���������� ���� ���������
        ReleaseProcessor;
        ReadyProcesses.Add(Processor.Run);
        WriteToLog(Format('%s ������� � ������� �������', [CurrentProcessContext^.Name]));
      end;
      RefreshUI(Form1);
      Exit;
    end;

  //����������� ���-�� ����������� ������ �� �������
  CurrentProcessContext^.CurrentRun := CurrentProcessContext^.CurrentRun + 1;

  //���� ������� �������� ����������
  if IsCurrentProcessExecuted then
  begin
    //����������� ���������
    ReleaseProcessor;                       

    //���� ���� ��������� ��������� ���������� �����/������
    if CurrentProcessContext^.IODeviceCapturedByMe then
    begin
      //�� ����������� ���
      IsIODeviceAvailable := true;
      CurrentProcessContext^.IODeviceCapturedByMe := false;
      WriteToLog(Format('%s ��������� ���������� �����/������', [CurrentProcessContext^.Name]));
      //� ������ ��� ��������� �������� ��������
      MakeWaitProcessesReady;
    end;

    PartitionCount := PartitionCount - 1;
    FreeMemory := FreeMemory + CurrentProcessContext^.Memory;
    TryToLoadWaitingProcesses;

    WriteToLog(Format('%s ����������', [CurrentProcessContext^.Name]));
  end
  else
  begin
    //���� ������ ������ ���������
    if IsCurrentCommandGroupExecuted then
    begin
      //��������� �� ��������� ������
      SwitchToNextCommandGroup;

      //���� ���� ��������� ��������� ���������� �����/������ � ��������� ������
      //������ - ������� �� �����/������
      if (CurrentProcessContext^.IODeviceCapturedByMe)
        and (CurrentProcessContext^.Command <> cIO) then
      begin
        //�� ����������� ����������
        IsIODeviceAvailable := true;
        CurrentProcessContext^.IODeviceCapturedByMe := false;
        WriteToLog(Format('%s ��������� ���������� �����/������', [CurrentProcessContext^.Name]));
        //� ������ ��� ��������� �������� ��������
        MakeWaitProcessesReady;
      end;
    end;

    //���� ����� ������ �������� ���������
    if (ProcessorTimeUnitLeft = 0)
      or (IsProcessWithHighestPriorityExist) then
    begin
      //������� ������� � ����������
      ReleaseProcessor;
      ReadyProcesses.Add(Processor.Run);
      WriteToLog(Format('%s ������� � ������� �������', [CurrentProcessContext^.Name]));
    end;
  end;

  //��������� ���������
  RefreshUI(Form1);
end;

//��������� ���� �� � ������� ������� ��������� ������� � ����������� ���� ����������
//�������� ��������
function IsProcessWithHighestPriorityExist: boolean;
var
  CurrentProcessPriority: TPrioritetProcess;
  ProcessIndex: integer;
begin
  CurrentProcessPriority := Processor.Run^.Prioritet;
  for ProcessIndex := 0 to ReadyProcesses.Count - 1 do
  begin
    if PDescriptor(ReadyProcesses[ProcessIndex])^.Prioritet >
      CurrentProcessPriority then
    begin
      Result := true;
      Exit;
    end;
  end;

  Result := false;
end;

//��������� ���������� �� ������� �������
function IsCurrentProcessExecuted: boolean;
var
  NextCommand: TCommand;
begin
  //�������� ��� ������� ��������� ������
  NextCommand := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine + 1]);
  Result := (NextCommand = cNone)
    and (CurrentProcessContext^.CountRun = CurrentProcessContext^.CurrentRun);
end;

//��������� ����������� �� ������� ������ ������
function IsCurrentCommandGroupExecuted: boolean;
begin
  Result := CurrentProcessContext^.CountRun = CurrentProcessContext^.CurrentRun;
end;

//����������� �������� �� ��������� ������ ������
procedure SwitchToNextCommandGroup();
begin
  CurrentProcessContext^.CommandLine := CurrentProcessContext^.CommandLine + 1;
  CurrentProcessContext^.Command := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine]);
  CurrentProcessContext^.CountRun := ParseInt(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine]);
  CurrentProcessContext^.CurrentRun := 0;
  ALabel[3, CurrentProcessContext^.PID].Caption :=
      '������� ������� = ' + CommandToStr(CurrentProcessContext^.Command);
end;

//����������� ���������
procedure ReleaseProcessor();
begin
  Processor.State := spEmpty;
  Processor.Run^.State := spReady;
  ALabel[1, Processor.Run^.PID].Caption :=
        '��������� = ' + StateToStr(Processor.Run^.State);
end;

//��������� ���������
procedure RefreshUI(Form: TForm1);
var
  CurrentDescriptor: PDescriptor;
  CurrentContext: PContext;
  i: integer;
begin
  Form.Label5.Caption := '��������� = ' + StateProcessorToStr(Processor.State);

  if Processor.State = spEmpty then
  begin
    Form.Label7.Caption := '�����������: - �� -';
    Form.Label6.Caption := '�������: -';
  end
  else
  begin
    Form.Label7.Caption := Format('�����������: %d �� %d',
      [CurrentProcessContext^.CurrentRun,
      CurrentProcessContext^.CountRun]);
    Form.Label6.Caption := Format('�������: %s', [CurrentProcessContext^.Name]);
  end;

  Form.ListBox1.Clear;
  for i := 0 to ReadyProcesses.Count - 1 do
  begin
    CurrentDescriptor := ReadyProcesses[i];
    CurrentContext := Form.ContextProcessByID(CurrentDescriptor^.PID);
    Form.ListBox1.Items.Add(CurrentContext^.Name);
  end;

  Form.AwaitingForMemoryListBox.Clear;
  for i := 0 to AwaitingForMemoryProcesses.Count - 1 do
  begin
    CurrentDescriptor := AwaitingForMemoryProcesses[i];
    CurrentContext := Form.ContextProcessByID(CurrentDescriptor^.PID);
    Form.AwaitingForMemoryListBox.Items.Add(CurrentContext^.Name);
  end;

  Form.MemoryTotalLabel.Caption := Format('����� ������: %d ����', [MEMORY_TOTAL]);
  Form.FreeMemoryLabel.Caption := Format('�������� ������: %d ����', [FreeMemory]);
  Form.PartitionCountLabel.Caption := Format('�������� �������: %d', [PartitionCount]);
end;

//������ ��� ��������� �������� ��������
procedure MakeWaitProcessesReady;
var
  CurrentWaitProcessDescriptor: PDescriptor;
  i: integer;
begin
  for i := 0 to WaitProcesses.Count - 1 do
  begin
    CurrentWaitProcessDescriptor := WaitProcesses[i];
    ReadyProcesses.Add(CurrentWaitProcessDescriptor);
  end;

  WaitProcesses.Clear;
end;

procedure TryToLoadWaitingProcesses;
var
  i: integer;
  ProcessDescriptor: PDescriptor;
  ProcessContext: PContext;
begin
  for i := 0 to AwaitingForMemoryProcesses.Count - 1 do
  begin
      ProcessDescriptor := PDescriptor(AwaitingForMemoryProcesses[i]);
      ProcessContext := Form1.ContextProcessByID(ProcessDescriptor^.PID);
      if ProcessContext^.Memory <= FreeMemory then
      begin
        FreeMemory := FreeMemory - ProcessContext^.Memory;
        PartitionCount := PartitionCount + 1;
        //???????? ??????? ? ???? ???????
        ReadyProcesses.Add(ProcessDescriptor);
        Form1.WriteToLog('??????? ' + ProcessContext^.Name + ' ??????? ? ??????? ???????');
        AwaitingForMemoryProcesses.Remove(ProcessDescriptor);
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
end.
