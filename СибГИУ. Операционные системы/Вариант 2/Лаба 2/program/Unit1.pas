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
  MEMORY_TOTAL = 64 * 1024;             //общее кол-во памяти

var
  CurrentProcessContext: PContext;
  ProcessorTimeUnitLeft: Integer;
  IsIODeviceAvailable: Boolean;
  Form1: TForm1;
  TabSheet : array [0..9] of TTabSheet;
  ListBox: array [0..9] of TListBox;
  ALabel: array [0..3, 0..9] of TLabel;
  Process: array [0..9] of TProcess;        //Массив процессов
  Processor: TProcessor;                    //Модель процессора
  ReadyProcesses: TReadyQueue;
  PriorityValues: array [0..4] of TPrioritetProcess;
  WaitProcesses: TList;                     //Очередь ждущих процессов
  FreeMemory: integer;                      //кол-во свободной памяти
  PartitionCount: integer;                  //кол-во созданных процесов
  AwaitingForMemoryProcesses: TList;        //Список процессов ожидающих память
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

//Создание процесса:
//ID - идентификационный номер процесса
//Name - название процесса
//Memory - количество памяти/, необходимое процессу
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

//Запись в лог
procedure TForm1.WriteToLog(Text: String);
begin
  Memo1.Lines.Add(Text);
end;

//Обработка кнопки запуска процесса
procedure TForm1.Button1Click(Sender: TObject);
begin
  if PageControl1.PageCount = 10 then begin
    ShowMessage('Больше процессов нельзя!');
    exit;
  end;
  if OpenDialog1.Execute then begin
    //Готовим внешний вид новой вкладки
    TabSheet[PageControl1.PageCount] := TTabSheet.Create(Self);
    TabSheet[PageControl1.PageCount].Caption := 'Процесс' + IntToStr(PageControl1.PageCount + 1);
    TabSheet[PageControl1.PageCount].PageControl := PageControl1;
    ListBox[PageControl1.PageCount-1] := TListBox.Create(Self);
    ListBox[PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[0,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[0,PageControl1.PageCount-1].Caption := 'Квант = ';
    ALabel[0,PageControl1.PageCount-1].Top := 5;
    ALabel[0,PageControl1.PageCount-1].Left := 5;
    ALabel[0,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[1,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[1,PageControl1.PageCount-1].Caption := 'Состояние = ';
    ALabel[1,PageControl1.PageCount-1].Top := 20;
    ALabel[1,PageControl1.PageCount-1].Left := 5;
    ALabel[1,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[2,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[2,PageControl1.PageCount-1].Caption := 'Приоритет = ';
    ALabel[2,PageControl1.PageCount-1].Top := 35;
    ALabel[2,PageControl1.PageCount-1].Left := 5;
    ALabel[2,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    ALabel[3,PageControl1.PageCount-1] := TLabel.Create(Self);
    ALabel[3,PageControl1.PageCount-1].Caption := 'Текущая команда = ';
    ALabel[3,PageControl1.PageCount-1].Top := 50;
    ALabel[3,PageControl1.PageCount-1].Left := 5;
    ALabel[3,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    PageControl1.ActivePageIndex := PageControl1.PageCount-1;
    PageControl1.ActivePage.Align := alClient;
    ListBox[PageControl1.PageCount-1].Align  := alBottom;
    ListBox[PageControl1.PageCount-1].Height := trunc(PageControl1.ActivePage.Height-70);
    ListBox[PageControl1.PageCount-1].Items.LoadFromFile(OpenDialog1.FileName);
    ListBox[PageControl1.PageCount-1].ItemIndex := -1;
    //Создание процесса
    Process[PageControl1.PageCount-1] := CreateProccess(PageControl1.PageCount-1,
                                                        TabSheet[PageControl1.PageCount-1].Caption,
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[0]),
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[1]),
                                                        ParseCommand(ListBox[PageControl1.PageCount-1].Items[1]));
    ALabel[0,PageControl1.PageCount-1].Caption := 'Квант = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant);
    ALabel[1,PageControl1.PageCount-1].Caption := 'Состояние = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State);
    ALabel[2,PageControl1.PageCount-1].Caption := 'Приоритет = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet);;
    ALabel[3,PageControl1.PageCount-1].Caption := 'Текущая команда = ' + CommandToStr(Process[PageControl1.PageCount-1].Context^.Command);
    WriteToLog('Запущен новый процесс с именем ' + Process[PageControl1.PageCount-1].Context^.Name +
               ' (Квант = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant) +
               '; Состояние = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State) +
               '; Приоритет = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet) + ')');
    Panel3.Enabled := True;

    if Process[PageControl1.ActivePageIndex].Context^.Memory <= FreeMemory then
    begin
      FreeMemory := FreeMemory - Process[PageControl1.ActivePageIndex].Context^.Memory;
      PartitionCount := PartitionCount + 1;
      //помещаем процесс в стек готовых
      ReadyProcesses.Add(@Process[PageControl1.ActivePageIndex].Descriptor);
      WriteToLog('Процесс ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' помещен в очередь активных');
    end
    else
    begin
      //иначе добавляем процесс в очередь ожидающих память
      AwaitingForMemoryProcesses.Add(@Process[PageControl1.ActivePageIndex].Descriptor);
      WriteToLog('Не достаточно места. ' +
        'Процесс с именем ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' помещен в очередь ожидающих память');
    end;

    //Включаем моделирование процеесора и устройств ввода/вывода
    if not Timer1.Enabled then Timer1.Enabled := True;
  end;
end;

//Действия при активации формы
procedure TForm1.FormActivate(Sender: TObject);
var
  i: integer;
begin
  WriteToLog('Программа моделирования алгоритмов планирования процессов запущена');
  GetMem(Processor.Run, SizeOf(TDescriptor));
  Processor.State := spEmpty;
  Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);
  Label6.Caption := 'Процесс = ';
  WriteToLog('Модель процессора подготовлена');

  IsIODeviceAvailable := true;
  ReadyProcesses := TReadyQueue.Create;
  WriteToLog('Очередь готовых процессов создана');

  WaitProcesses := TList.Create;
  WriteToLog('Очередь ожидающих процессов создана');

  //инициализируем массив со значениями приоритета
  PriorityValues[0] := ppLowest;
  PriorityValues[1] := ppLow;
  PriorityValues[2] := ppNormal;
  PriorityValues[3] := ppHigh;
  PriorityValues[4] := ppHighest;

  //инициализируем выпадающий список
  for i := 0 to High(PriorityValues) do
  begin
    NewProcessPriorityComboBox.Items.Add(PriorToStr(PriorityValues[i]));
  end;

  NewProcessPriorityComboBox.ItemIndex := 4;

  FreeMemory := MEMORY_TOTAL;
  PartitionCount := 0;

  AwaitingForMemoryProcesses := TList.Create;
end;

//моделирование диспетчера процессов
procedure TForm1.Timer1Timer(Sender: TObject);
var
  PickedProcessDescriptor: PDescriptor;
begin
  //если процессор простаивает
  if Processor.State = spEmpty then
  begin
    //если очередь готовых процессов пуста
    if ReadyProcesses.IsEmpty then
    begin
      //то ничего не делаем
      Exit;
    end;

    //берем процесс из очереди готовых процессов
    PickedProcessDescriptor :=  ReadyProcesses.PickProcess();

    //восстанавливаем контекст выбранного процесса
    CurrentProcessContext := ContextProcessByID(PickedProcessDescriptor^.PID);

    //помечаем, что процесс выполняется
    PickedProcessDescriptor.State := spRun;

    //помечаем, что процессор находится в работе
    Processor.Run := PickedProcessDescriptor;
    Processor.State := spBusy;

    //инициализируем переменную с оставшимся временем работы процесса
    ProcessorTimeUnitLeft := PickedProcessDescriptor^.Kvant;
  end;

  //уменьшаем время, которое осталось выполняться процессу на единицу
  ProcessorTimeUnitLeft := ProcessorTimeUnitLeft - 1;

  //если команду, которую нужно сейчас выполнить команда ввода/вывода
  if IsIODeviceAvailable then
    begin
      //захватываем его
      IsIODeviceAvailable := false;
      CurrentProcessContext^.IODeviceCapturedByMe := true;
      WriteToLog(Format('%s захватил устройство ввода/вывода', [CurrentProcessContext^.Name]));
    end else if not CurrentProcessContext^.IODeviceCapturedByMe then
    begin
      //иначе проверяем не кончилось ли время работы
      if ProcessorTimeUnitLeft = 0 then
      begin
        //снимаем процесс с выполнения если кончилось
        ReleaseProcessor;
        ReadyProcesses.Add(Processor.Run);
        WriteToLog(Format('%s помещен в очередь готовых', [CurrentProcessContext^.Name]));
      end;
      RefreshUI(Form1);
      Exit;
    end;

  //увеличиваем кол-во выполненных команд на единицу
  CurrentProcessContext^.CurrentRun := CurrentProcessContext^.CurrentRun + 1;

  //если процесс полность выполнился
  if IsCurrentProcessExecuted then
  begin
    //освобождаем процессор
    ReleaseProcessor;                       

    //если этим процессом захвачено устройство ввода/вывода
    if CurrentProcessContext^.IODeviceCapturedByMe then
    begin
      //то освобождаем его
      IsIODeviceAvailable := true;
      CurrentProcessContext^.IODeviceCapturedByMe := false;
      WriteToLog(Format('%s освободил устройство ввода/вывода', [CurrentProcessContext^.Name]));
      //и делаем все ожидающие процессы готовыми
      MakeWaitProcessesReady;
    end;

    PartitionCount := PartitionCount - 1;
    FreeMemory := FreeMemory + CurrentProcessContext^.Memory;
    TryToLoadWaitingProcesses;

    WriteToLog(Format('%s выполнился', [CurrentProcessContext^.Name]));
  end
  else
  begin
    //если группа команд выполнена
    if IsCurrentCommandGroupExecuted then
    begin
      //переходим на следующую группу
      SwitchToNextCommandGroup;

      //если этим процессом захвачено устройство ввода/вывода и следующая группа
      //команд - команды не ввода/вывода
      if (CurrentProcessContext^.IODeviceCapturedByMe)
        and (CurrentProcessContext^.Command <> cIO) then
      begin
        //то освобождаем устройство
        IsIODeviceAvailable := true;
        CurrentProcessContext^.IODeviceCapturedByMe := false;
        WriteToLog(Format('%s освободил устройство ввода/вывода', [CurrentProcessContext^.Name]));
        //и делаем все ожидающие процессы готовыми
        MakeWaitProcessesReady;
      end;
    end;

    //если время работы процесса кончилось
    if (ProcessorTimeUnitLeft = 0)
      or (IsProcessWithHighestPriorityExist) then
    begin
      //снимаем процесс с выполнения
      ReleaseProcessor;
      ReadyProcesses.Add(Processor.Run);
      WriteToLog(Format('%s помещен в очередь готовых', [CurrentProcessContext^.Name]));
    end;
  end;

  //обновляем интерфейс
  RefreshUI(Form1);
end;

//проверяет есть ли в очереди готовых процессов процесс с приоритетом выше приоритета
//текущего процесса
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

//проверяем выполнился ли процесс процесс
function IsCurrentProcessExecuted: boolean;
var
  NextCommand: TCommand;
begin
  //получаем тип комманд следующей группы
  NextCommand := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine + 1]);
  Result := (NextCommand = cNone)
    and (CurrentProcessContext^.CountRun = CurrentProcessContext^.CurrentRun);
end;

//проверяет выполнилась ли текущая группа команд
function IsCurrentCommandGroupExecuted: boolean;
begin
  Result := CurrentProcessContext^.CountRun = CurrentProcessContext^.CurrentRun;
end;

//настраивает контекст на следующую группу команд
procedure SwitchToNextCommandGroup();
begin
  CurrentProcessContext^.CommandLine := CurrentProcessContext^.CommandLine + 1;
  CurrentProcessContext^.Command := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine]);
  CurrentProcessContext^.CountRun := ParseInt(ListBox[Processor.Run^.PID].Items[CurrentProcessContext^.CommandLine]);
  CurrentProcessContext^.CurrentRun := 0;
  ALabel[3, CurrentProcessContext^.PID].Caption :=
      'Текущая команда = ' + CommandToStr(CurrentProcessContext^.Command);
end;

//освобождает процессор
procedure ReleaseProcessor();
begin
  Processor.State := spEmpty;
  Processor.Run^.State := spReady;
  ALabel[1, Processor.Run^.PID].Caption :=
        'Состояние = ' + StateToStr(Processor.Run^.State);
end;

//обновляет интерфейс
procedure RefreshUI(Form: TForm1);
var
  CurrentDescriptor: PDescriptor;
  CurrentContext: PContext;
  i: integer;
begin
  Form.Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);

  if Processor.State = spEmpty then
  begin
    Form.Label7.Caption := 'Выполняется: - из -';
    Form.Label6.Caption := 'Процесс: -';
  end
  else
  begin
    Form.Label7.Caption := Format('Выполняется: %d из %d',
      [CurrentProcessContext^.CurrentRun,
      CurrentProcessContext^.CountRun]);
    Form.Label6.Caption := Format('Процесс: %s', [CurrentProcessContext^.Name]);
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

  Form.MemoryTotalLabel.Caption := Format('Всего памяти: %d байт', [MEMORY_TOTAL]);
  Form.FreeMemoryLabel.Caption := Format('Свободно памяти: %d байт', [FreeMemory]);
  Form.PartitionCountLabel.Caption := Format('Разделов создано: %d', [PartitionCount]);
end;

//делает все ожидающие процессы готовыми
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

//Определение контекста процесса по идентификатору этого процесса
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
