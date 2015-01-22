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
  Process: array [0..9] of TProcess;        //Массив процессов
  Processor: TProcessor;                    //Модель процессора
  IODevice: TProcessor;                     //Модель устройства ввода/вывода
  Readys: PDescriptorStack;                 //Ссылка на очередь готовых
  Waits: PDescriptorStack;                  //Ссылка на очередь ожидающих
  StateReadys, StateWaits: TStateStack;     //Состояние очередей

implementation

{$R *.dfm}

//Создание процесса:
//ID - идентификационный номер процесса
//Name - название процесса
//Memory - количество памяти/, необходимое процессу
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
                                                        ParseInt(ListBox[PageControl1.PageCount-1].Items[0]));
    ALabel[0,PageControl1.PageCount-1].Caption := 'Квант = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant);
    ALabel[1,PageControl1.PageCount-1].Caption := 'Состояние = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State);
    ALabel[2,PageControl1.PageCount-1].Caption := 'Приоритет = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet);;
    ALabel[3,PageControl1.PageCount-1].Caption := 'Текущая команда = ' + CommandToStr(Process[PageControl1.PageCount-1].Context^.Command);
    WriteToLog('Запущен новый процесс с именем ' + Process[PageControl1.PageCount-1].Context^.Name +
               ' (Квант = ' + IntToStr(Process[PageControl1.PageCount-1].Descriptor.Kvant) +
               '; Состояние = ' + StateToStr(Process[PageControl1.PageCount-1].Descriptor.State) +
               '; Приоритет = ' + PriorToStr(Process[PageControl1.PageCount-1].Descriptor.Prioritet) + ')');
    Panel3.Enabled := True;
    //Помещаем процесс в стек готовых
    In_Stack(Readys, @Process[PageControl1.ActivePageIndex].Descriptor);
    StateReadys := ssFully;
    ListBox1.Items.Add(Process[PageControl1.ActivePageIndex].Context^.Name);
    WriteToLog('Процесс ' + Process[PageControl1.ActivePageIndex].Context^.Name + ' помещен в очередь готовых');
    //Включаем моделирование процеесора и устройств ввода/вывода
    if not Timer1.Enabled then Timer1.Enabled := True;
    if not Timer2.Enabled then Timer2.Enabled := True;
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
  GetMem(Readys, SizeOf(TDescriptorStack));
  StateReadys := ssEmpty;
  WriteToLog('Очередь готовых подготовлена');
  GetMem(Waits, SizeOf(TDescriptorStack));
  StateWaits := ssEmpty;
  WriteToLog('Очередь ожидающих подготовлена');
  GetMem(IODevice.Run, SizeOf(TDescriptor));
  IODevice.State := spEmpty;
  WriteToLog('Модель устройства ввода/вывода подготовлена');
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

//Уменьшение приоритета процеса, если это возможно
procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  if CheckPriorDown(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Prioritet := TPrioritetProcess(Byte(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) - 1);
    ALabel[2,PageControl1.ActivePageIndex].Caption := 'Приоритет = ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet);
    WriteToLog('Процессу ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' уменьшен приоритет до ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet));
  end
  else begin
    ShowMessage('Уменьшение приоритета невозможно!');
  end;
end;

//Увеличение приоритета процеса, если это возможно
procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  if CheckPriorUp(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) then begin
    Process[PageControl1.ActivePageIndex].Descriptor.Prioritet := TPrioritetProcess(Byte(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet) + 1);
    ALabel[2,PageControl1.ActivePageIndex].Caption := 'Приоритет = ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet);
    WriteToLog('Процессу ' + Process[PageControl1.ActivePageIndex].Context^.Name +
               ' увеличен приоритет до ' + PriorToStr(Process[PageControl1.ActivePageIndex].Descriptor.Prioritet));
  end
  else begin
    ShowMessage('Увеличение приоритета невозможно!');
  end;
end;

//Моделирование диспетчера
procedure TForm1.Timer1Timer(Sender: TObject);
var
  CurrentContext: PContext;
begin
  //Если процессор свободен, занимаем его следующим из очереди готовых
  if Processor.State = spEmpty then begin
    if StateReadys = ssEmpty then exit;
    //Изымаем следующий процесс из очереди готовых
    Out_Stack(Readys, Processor.Run);
    Processor.State := spBusy;
    Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);
    CurrentContext := ContextProcessByID(Processor.Run^.PID);
    Label6.Caption := 'Процесс = ' + CurrentContext^.Name;
    ListBox1.Items.Delete(0);
    Processor.Run.State := spRun;
    ALabel[1,Processor.Run^.PID].Caption := 'Состояние = ' + StateToStr(Processor.Run^.State);
    ALabel[3,Processor.Run^.PID].Caption := 'Текущая команда = ' + CommandToStr(CurrentContext^.Command);
    WriteToLog('Процесс ' + CurrentContext^.Name + ' переведен в состояние ВЫПОЛНЕНИЕ');
    if ListBox1.Items.Count = 0 then StateReadys := ssEmpty;
    //Если предыдущая команда выполнена
    if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
      //Переходим на следующую команду
      CurrentContext^.CommandLine := CurrentContext^.CommandLine + 1;
      CurrentContext^.Command := ParseCommand(ListBox[Processor.Run^.PID].Items[CurrentContext^.CommandLine]);
      CurrentContext^.CountRun := ParseInt(ListBox[Processor.Run^.PID].Items[CurrentContext^.CommandLine]);
      CurrentContext^.CurrentRun := 0;
      Label7.Caption := 'Выполняется ' + IntToStr(CurrentContext^.CurrentRun) + ' из ' + IntToStr(CurrentContext^.CountRun);
      ALabel[1,Processor.Run^.PID].Caption := 'Состояние = ' + StateToStr(Processor.Run^.State);
      ALabel[3,Processor.Run^.PID].Caption := 'Текущая команда = ' + CommandToStr(CurrentContext^.Command);
      //Если команда ПРОЦЕССОР, то продолжаем работать,
      if CurrentContext^.Command = cPROCESSOR then begin
      end;
      //Если команда ВВОД/ВЫВОД, то перемещаем процесс в очередь ожидающих
      if CurrentContext^.Command = cIO then begin
        In_Stack(Waits, Processor.Run);
        StateWaits := ssFully;
        ListBox2.Items.Add(CurrentContext^.Name);
        Processor.Run^.State := spWait;
        WriteToLog('Процесс ' + CurrentContext^.Name + ' помещен в очередь ожидающих');
        ALabel[1,Processor.Run^.PID].Caption := 'Состояние = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := 'Текущая команда = '  + CommandToStr(CurrentContext^.Command);
        //Процессор свободен
        Processor.State := spEmpty;
        Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := 'Процесс = -';
        Label7.Caption := 'Выполняется -  из -';
      end;
      //Если команды нет, то заканчиваем процесс
      if CurrentContext^.Command = cNONE then begin
        Processor.Run^.State := spNone;
        WriteToLog('Процесс ' + CurrentContext^.Name + ' завершен');
        ALabel[1,Processor.Run^.PID].Caption := 'Состояние = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := 'Текущая команда = '  + CommandToStr(CurrentContext^.Command);
        //Процессор свободен
        Processor.State := spEmpty;
        Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := 'Процесс = -';
        Label7.Caption := 'Выполняется -  из -';
      end;
    end;
  end
  else begin
    //Если процессор занять какой-то работой
    CurrentContext := ContextProcessByID(Processor.Run^.PID);
    //Если он занять нужной работой, то определяем не закончилось ли время для выполнения команды
    if CurrentContext^.Command = cPROCESSOR then begin
      CurrentContext^.CurrentRun := CurrentContext^.CurrentRun + 1;
      //Если команда исчерпала время
      if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
        //То переводим процесс в очредь готовых
        In_Stack(Readys, Processor.Run);
        StateReadys := ssFully;
        ListBox1.Items.Add(CurrentContext^.Name);
        WriteToLog('Процесс ' + CurrentContext^.Name + ' помещен в очередь готовых');
        Processor.Run^.State := spReady;
        ALabel[1,Processor.Run^.PID].Caption := 'Состояние = ' + StateToStr(Processor.Run^.State);
        ALabel[3,Processor.Run^.PID].Caption := 'Текущая команда = -';
        //Процессор свободен
        //По правилам необходимо выбрать следующий процесс из очереди готовых, но
        //для лучшей иллюстрации работы процессора, сделаем это на следующем кванте
        Processor.State := spEmpty;
        Label5.Caption := 'Состояние = ' + StateProcessorToStr(Processor.State);
        Label6.Caption := 'Процесс = -';
        Label7.Caption := 'Выполняется -  из -';
      end
      else begin
        //Если нет, то смотрим отведенный квант
        if CurrentContext^.CurrentRun mod Processor.Run^.Kvant = 0 then begin
          Label7.Caption := 'Выполняется ' + IntToStr(CurrentContext^.CurrentRun) + ' из ' + IntToStr(CurrentContext^.CountRun);
        end;
      end;
    end
    else begin
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

//Моделирование устройств ввода/вывода
procedure TForm1.Timer2Timer(Sender: TObject);
var
  CurrentContext: PContext;
begin
  //Если устройство ничем не занято, то пытаемся его занять
  if IODevice.State = spEmpty then begin
    //Если список ожидающих операции ввода/вывода пуст, то ничего не делаем
    if StateWaits = ssEmpty then exit;
    //Изымаем следующий процесс из очереди ожидающих
    Out_Stack(Waits, IODevice.Run);
    IODevice.State := spBusy;
    CurrentContext := ContextProcessByID(IODevice.Run^.PID);
    ListBox2.Items.Delete(0);
    IODevice.Run.State := spRun;
    ALabel[1,IODevice.Run^.PID].Caption := 'Состояние = ' + StateToStr(IODevice.Run^.State);
    ALabel[3,IODevice.Run^.PID].Caption := 'Текущая команда = ' + CommandToStr(CurrentContext^.Command);
    WriteToLog('Процесс ' + CurrentContext^.Name + ' осуществляет операции ввода/вывода');
    if ListBox2.Items.Count = 0 then StateWaits := ssEmpty;
  end
  else begin
    //Если устройство занято какой-то работой
    CurrentContext := ContextProcessByID(IODevice.Run^.PID);
    //Если он занять нужной работой, то определяем не закончилось ли время для выполнения команды
    if CurrentContext^.Command = cIO then begin
      CurrentContext^.CurrentRun := CurrentContext^.CurrentRun + 1;
      //Если команда исчерпала время
      if CurrentContext^.CountRun = CurrentContext^.CurrentRun then begin
        //ТО переводим процесс в очредь готовых
        In_Stack(Readys, IODevice.Run);
        StateReadys := ssFully;
        ListBox1.Items.Add(CurrentContext^.Name);
        WriteToLog('Процесс ' + CurrentContext^.Name + ' помещен в очередь готовых');
        IODevice.Run^.State := spReady;
        ALabel[1,IODevice.Run^.PID].Caption := 'Состояние = ' + StateToStr(IODevice.Run^.State);
        ALabel[3,IODevice.Run^.PID].Caption := 'Текущая команда = -';
        //Устройство свободно и можно получать следующее задание
        IODevice.State := spEmpty;
        WriteToLog('Устройство ввода/вывода свободно');
      end;
    end;
  end;
end;

end.
