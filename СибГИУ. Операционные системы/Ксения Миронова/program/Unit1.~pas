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
    procedure Timer1Timer(Sender: TObject);
    function ContextProcessByID(ID: Integer): PContext;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CurrentProcessContext: PContext;
  ProcessorTimeUnitLeft: Integer;
  IsIODeviceAvailable: Boolean;
  Form1: TForm1;
  TabSheet : array [0..9] of TTabSheet;
  ListBox: array [0..9] of TListBox;
  ALabel: array [0..2, 0..9] of TLabel;
  Process: array [0..9] of TProcess;        //Массив процессов
  Processor: TProcessor;                    //Модель процессора
  ReadyProcesses: TReadyQueue;              //Очередь готовых процессов
  WaitProcesses: TList;              //Очередь ждущих процессов

procedure ReleaseProcessor();
procedure SwitchToNextCommandGroup();
procedure RefreshUI(Form: TForm1);
function IsCurrentProcessExecuted: boolean;
function IsCurrentCommandGroupExecuted: boolean;
procedure MakeWaitProcessesReady;

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
    Prioritet := ppNormal;
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
    ALabel[2,PageControl1.PageCount-1].Caption := 'Текущая команда = ';
    ALabel[2,PageControl1.PageCount-1].Top := 35;
    ALabel[2,PageControl1.PageCount-1].Left := 5;
    ALabel[2,PageControl1.PageCount-1].Parent := TabSheet[PageControl1.PageCount-1];
    PageControl1.ActivePageIndex := PageControl1.PageCount-1;
    PageControl1.ActivePage.Align := alClient;
    ListBox[PageControl1.PageCount-1].Align  := alBottom;
    ListBox[PageControl1.PageCount-1].Height := trunc(PageControl1.ActivePage.Height-55);
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
    ALabel[2,PageControl1.PageCount-1].Caption := 'Текущая команда = ' + CommandToStr(Process[PageControl1.PageCount-1].Context^.Command);
    WriteToLog('Запущен новый процесс с именем ' + Process[PageControl1.PageCount-1].Context^.Name +
               ' (Квант = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant) +
               '; Состояние = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State) +
               '; Приоритет = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet) + ')');
    Panel3.Enabled := True;
    //Помещаем процесс в стек готовых
    ReadyProcesses.Add(@Process[PageControl1.ActivePageIndex].Descriptor);
    WriteToLog('Процесс ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' помещен в очередь готовых');
    //Включаем моделирование процеесора и устройств ввода/вывода
    if not Timer1.Enabled then Timer1.Enabled := True;
  end;
end;

//Действия при активации формы
procedure TForm1.FormActivate(Sender: TObject);
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
end;

//Уменьшение кванта процессорного времени, если это возможно
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if CheckKvantDown(Process[PageControl1.ActivePageIndex].Descriptor.Kvant - 1) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Kvant := Process[PageControl1.ActivePageIndex].Descriptor.Kvant - 1;
    ALabel[0,PageControl1.ActivePageIndex].Caption := 'Квант = ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant);
    WriteToLog('Процессу ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' уменьшен квант процессорного времени до ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant));
  end
  else begin
    ShowMessage('Уменьшение кванта процессорного времени невозможно!');
  end;
end;

//Увеличение кванта процессорного времени, если это возможно
procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if CheckKvantUp(Process[PageControl1.ActivePageIndex].Descriptor.Kvant + 1) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Kvant := Process[PageControl1.ActivePageIndex].Descriptor.Kvant + 1;
    ALabel[0,PageControl1.ActivePageIndex].Caption := 'Квант = ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant);
    WriteToLog('Процессу ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' увеличен квант процессорного времени до ' + IntToStr(Process[PageControl1.ActivePageIndex].Descriptor.Kvant));
  end
  else begin
    ShowMessage('Увеличение кванта процессорного времени невозможно!');
  end;
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
  if CurrentProcessContext^.Command = cIO then
  begin
    //если устройство ввода/вывода не захвачено другими процессами
    if IsIODeviceAvailable then
    begin
      //захватываем его
      IsIODeviceAvailable := false;
      CurrentProcessContext^.IODeviceCapturedByMe := true;
      WriteToLog(Format('%s захватил устройство ввода/вывода', [CurrentProcessContext^.Name]));
    end else if not CurrentProcessContext^.IODeviceCapturedByMe then
    begin
      //иначе снимаем процесс с выполнения
      ReleaseProcessor;
      //и помещаем процесс в очередь ждущих процессов
      WaitProcesses.Add(Processor.Run);
      WriteToLog(Format('%s помещен в очередь ждущих процессов', [CurrentProcessContext^.Name]));
      RefreshUI(Form1);
      Exit;
    end
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
    if ProcessorTimeUnitLeft = 0 then
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

//проверяем выполнился ли процесс процесс
function IsCurrentProcessExecuted: boolean;
var
  NextCommand: TCommand;
begin
  //получаем тим комманд следующей группы
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
end;

//освобождает процессор
procedure ReleaseProcessor();
begin
  Processor.State := spEmpty;
  Processor.Run^.State := spReady;
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

  Form.ListBox2.Clear;
  for i := 0 to WaitProcesses.Count - 1 do
  begin
    CurrentDescriptor := WaitProcesses[i];
    CurrentContext := Form.ContextProcessByID(CurrentDescriptor^.PID);
    Form.ListBox2.Items.Add(CurrentContext^.Name);
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
