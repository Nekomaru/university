unit Unit2;

interface
uses
  SysUtils;

type
  //Тип-перечисление: Тип команды
  TCommand = (cNONE,
             cMEMORY,      //Память
             cPROCESSOR,   //Процессор
             cIO);         //Ввод/вывод

  //Тип-перечисление: Состояние процессора
  TStateProcessor = (spEmpty,  //Свободен
                     spBusy);  //Занят

 //Тип-перечисление: Состояние стека
  TStateStack = (ssEmpty,  //Пустой
                 ssFully);  //Занят

  //Тип-перечисление: Состояние процесса
  TStateProcess = ( spNone,   //Нет состояния
                    spRun,    //Выполнение
                    spReady,  //Готовность
                    spWait);  //Ожидание

  //Тип-перечисление: Приоритет процесса
  TPrioritetProcess = (ppLowest,  //Очень низкий
                       ppLow,     //Низкий
                       ppNormal,  //Нормальный
                       ppHigh,    //Высокий
                       ppHighest);//Очень высокий

  //Тип-запись: Дескриптор процесса
  TDescriptor = record
    PID: Integer;                 //Идентификатор процесса
    Kvant: Integer;               //Квант процесса
    State: TStateProcess;         //Состояние процесса
    Prioritet: TPrioritetProcess; //Приоритет процесса
  end;

  PContext = ^TContext;
  //Тип-запись: Контекст процесса
  TContext = record
    PID: Integer;                 //Идентификатор процесса
    Name: String[15];             //Имя процесса
    CommandLine: Integer;         //Счётчик команд
    Command: TCommand;            //Какая команда
    CountRun: Integer;            //Сколько надо выполнять команду
    CurrentRun: Integer;          //Счётчик выполнения команды
    Memory: Integer;              //Требуемое для процесса количество памяти
  end;

  //Тип-запись: Процесс
  TProcess = record
    Descriptor: TDescriptor;      //Дескриптор процесса
    Context: PContext;           //Ссылка на контекст процесса
  end;

  PDescriptor = ^TDescriptor;
  //Тип-стек: Очередь дескриптеров
  PDescriptorStack = ^TDescriptorStack;
  TDescriptorStack = record
    Descriptor: PDescriptor;       //Дескриптор процесса
    Next: PDescriptorStack;        //Следующий элемент стека
  end;

  //Тип-запись: Процессор
  TProcessor = record
    Run: PDescriptor;                           //Ссылка на выполняющийся процесс
    State: TStateProcessor;                      //Состояние процессора
  end;

  //Процедура помещения в стек
  procedure In_Stack(var First: PDescriptorStack; AValue: PDescriptor);
  //Процедура извлечения из стека
  procedure Out_Stack(var First: PDescriptorStack; Var AValue: PDescriptor);
  //Преобразования состояния процесса в строку текста
  function StateToStr(AState: TStateProcess): String;
  //Преобразования состояния процессора в строку текста
  function StateProcessorToStr(AState: TStateProcessor): String;
  //Преобразования приоритета процесса в строку текста
  function PriorToStr(APrior: TPrioritetProcess): String;
  //Преобразования команды процесса в строку текста
  function CommandToStr(ACommand: TCommand): String;
  //Проверка возможности уменьшения кванта времени
  function CheckKvantDown(AKvant: Integer): Boolean;
  //Проверка возможности увеличения кванта времени
  function CheckKvantUp(AKvant: Integer): Boolean;
  //Проверка возможности уменьшения приоритета
  function CheckPriorDown(APrior: TPrioritetProcess): Boolean;
  //Проверка возможности увеличения приоритета
  function CheckPriorUp(APrior: TPrioritetProcess): Boolean;
  //Извлечение данных из строки текста
  function ParseInt(Text: String): Integer;
  //Извлечение команды из строки текста
  function ParseCommand(Text: String): TCommand;

implementation

  procedure In_Stack(var First: PDescriptorStack; AValue: PDescriptor);
  var
    Temp: PDescriptorStack;
  begin
    New(Temp);
    Temp^.Descriptor := AValue;
    Temp^.Next := First;
    First := Temp; 
  end;

  procedure Out_Stack(var First: PDescriptorStack; Var AValue: PDescriptor);
  var
    Temp: PDescriptorStack;
  begin
    Temp := First;
    First := First^.Next;
    AValue := Temp^.Descriptor;
    Dispose(Temp);
  end;

  function ParseInt(Text: String): Integer;
  var
    temp: Integer;
  begin
    temp := pos('-', Text);
    if temp = 0 then begin
      Result := 0;
      exit;
    end;
    temp := StrToInt(copy(Text, temp + 1, Length(Text) - temp));
    Result := temp;
  end;

  function ParseCommand(Text: String): TCommand;
  var
    temp: Integer;
    tempStr: String;
  begin
    temp := pos('-', Text);
    if temp = 0 then begin
      Result := cNONE;
      exit;
    end;
    tempStr := copy(Text, 1, temp-1);
    Result := cNONE;
    if tempStr = 'ПАМЯТЬ' then Result := cMEMORY;
    if tempStr = 'ПРОЦЕССОР' then Result := cPROCESSOR;
    if tempStr = 'ВВОД\ВЫВОД' then Result := cIO;
  end;

  function CheckPriorDown(APrior: TPrioritetProcess): Boolean;
  begin
    Result := Aprior <> ppLowest;
  end;

  function CheckPriorUp(APrior: TPrioritetProcess): Boolean;
  begin
    Result := Aprior <> ppHighest;
  end;

  function CheckKvantDown(AKvant: Integer): Boolean;
  begin
    Result := AKvant > 0;
  end;

  function CheckKvantUp(AKvant: Integer): Boolean;
  begin
    Result := AKvant < 10;
  end;

  function StateProcessorToStr(AState: TStateProcessor): String;
  begin
    case AState of
    spEmpty:  Result := 'Свободен';
    spBusy:   Result := 'Занят';
    end;
  end;

  function CommandToStr(ACommand: TCommand): String;
  begin
    case ACommand of
    cNONE:      Result := 'Остановлен';
    cMEMORY:    Result := 'Запуск';
    cPROCESSOR: Result := 'Выполнение';
    cIO:        Result := 'Ввод/вывод';
    end;
  end;

  function StateToStr(AState: TStateProcess): String;
  begin
    case AState of
    spNone:  Result := 'Остановлен';
    spRun:   Result := 'Выплняется';
    spReady: Result := 'Готов';
    spWait:  Result := 'Ожидает';
    end;
  end;

  function PriorToStr(APrior: TPrioritetProcess): String;
  begin
    case APrior of
    ppLowest:  Result := 'Очень низкий';
    ppLow:     Result := 'Низкий';
    ppNormal:  Result := 'Нормальный';
    ppHigh:    Result := 'Высокий';
    ppHighest: Result := 'Очень высокий';
    end;
  end;
end.
 