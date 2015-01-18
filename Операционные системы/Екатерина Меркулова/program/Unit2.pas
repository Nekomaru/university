unit Unit2;
{$Optimization off}
interface
uses
  SysUtils, Classes;

type
  //���-������������: ��� �������
  TCommand = (cNONE,
             cMEMORY,      //������
             cPROCESSOR,   //���������
             cIO);         //����/�����

  //���-������������: ��������� ����������
  TStateProcessor = (spEmpty,  //��������
                     spBusy);  //�����

 //���-������������: ��������� �����
  TStateStack = (ssEmpty,  //������
                 ssFully);  //�����

  //���-������������: ��������� ��������
  TStateProcess = ( spNone,   //��� ���������
                    spRun,    //����������
                    spReady,  //����������
                    spWait);  //��������

  //���-������������: ��������� ��������
  TPrioritetProcess = (ppLowest,  //����� ������
                       ppLow,     //������
                       ppNormal,  //����������
                       ppHigh,    //�������
                       ppHighest);//����� �������

  //���-������: ���������� ��������
  TDescriptor = record
    PID: Integer;                 //������������� ��������
    Kvant: Integer;               //����� ��������
    State: TStateProcess;         //��������� ��������
    Prioritet: TPrioritetProcess; //��������� ��������
  end;

  PContext = ^TContext;
  //���-������: �������� ��������
  TContext = record
    PID: Integer;                         //������������� ��������
    Name: String[15];                     //��� ��������
    CommandLine: Integer;                 //������� ������
    Command: TCommand;                    //����� �������
    CountRun: Integer;                    //������� ���� ��������� �������
    CurrentRun: Integer;                  //������� ���������� �������
    Memory: Integer;                      //��������� ��� �������� ���������� ������
  end;

  //���-������: �������
  TProcess = record
    Descriptor: TDescriptor;      //���������� ��������
    Context: PContext;           //������ �� �������� ��������
  end;

  PDescriptor = ^TDescriptor;
  //���-����: ������� ������������
  PDescriptorStack = ^TDescriptorStack;
  TDescriptorStack = record
    Descriptor: PDescriptor;       //���������� ��������
    Next: PDescriptorStack;        //��������� ������� �����
  end;

  //���-������: ���������
  TProcessor = record
    Run: PDescriptor;                           //������ �� ������������� �������
    State: TStateProcessor;                      //��������� ����������
  end;

	TReadyQueue = class(TList)
	public
		function PickProcess: PDescriptor;
		function IsEmpty: boolean;
	end;

  //��������� ��������� � ����
  procedure In_Stack(var First: PDescriptorStack; AValue: PDescriptor);
  //��������� ���������� �� �����
  procedure Out_Stack(var First: PDescriptorStack; Var processDescriptor: PDescriptor);
  //�������������� ��������� �������� � ������ ������
  function StateToStr(AState: TStateProcess): String;
  //�������������� ��������� ���������� � ������ ������
  function StateProcessorToStr(AState: TStateProcessor): String;
  //�������������� ���������� �������� � ������ ������
  function PriorToStr(APrior: TPrioritetProcess): String;
  //�������������� ������� �������� � ������ ������
  function CommandToStr(ACommand: TCommand): String;
  //�������� ����������� ���������� ������ �������
  function CheckKvantDown(AKvant: Integer): Boolean;
  //�������� ����������� ���������� ������ �������
  function CheckKvantUp(AKvant: Integer): Boolean;
  //�������� ����������� ���������� ����������
  function CheckPriorDown(APrior: TPrioritetProcess): Boolean;
  //�������� ����������� ���������� ����������
  function CheckPriorUp(APrior: TPrioritetProcess): Boolean;
  //���������� ������ �� ������ ������
  function ParseInt(Text: String): Integer;
  //���������� ������� �� ������ ������
  function ParseCommand(Text: String): TCommand;

implementation

	function TReadyQueue.PickProcess: PDescriptor;
	var
		CurrentDescriptor: PDescriptor;
		CurrentDescriptorWithMaxPriority: PDescriptor;
		i: integer;
	begin
		CurrentDescriptorWithMaxPriority := Self[0];
		for i := 1 to Count - 1 do
		begin
			CurrentDescriptor := Self[i];
			if CurrentDescriptor^.Prioritet > CurrentDescriptorWithMaxPriority^.Prioritet then
			begin
				CurrentDescriptorWithMaxPriority := CurrentDescriptor;
			end;
		end;
		
    Remove(CurrentDescriptorWithMaxPriority);
		Result := CurrentDescriptorWithMaxPriority;
	end;
	
	function TReadyQueue.IsEmpty: boolean;
	begin
		Result := Count = 0;
	end;
	
  procedure In_Stack(var First: PDescriptorStack; AValue: PDescriptor);
  var
    Temp: PDescriptorStack;
  begin
    New(Temp);
    Temp^.Descriptor := AValue;
    Temp^.Next := First;
    First := Temp; 
  end;

  procedure Out_Stack(var First: PDescriptorStack; Var processDescriptor: PDescriptor);
  var
    Temp: PDescriptorStack;
    currentDescriptorListElement: PDescriptorStack;
    preDescriptorListElement: PDescriptorStack;
    curDescriptListElWithMaxPrior: PDescriptorStack;
    preDescriptListElWithMaxPrior: PDescriptorStack;
    preProcessDescriptor: PDescriptor;
    b: boolean;
  begin

    if First^.Next = nil then
    begin
      processDescriptor := First^.Descriptor;
      First := nil;
      exit;
    end;

    currentDescriptorListElement := First;
    preDescriptorListElement := First;
    curDescriptListElWithMaxPrior := First;
    preDescriptListElWithMaxPrior := nil;
    while currentDescriptorListElement^.Next <> nil do
    begin
      currentDescriptorListElement := currentDescriptorListElement^.Next;
      if currentDescriptorListElement^.Descriptor^.Prioritet >
        curDescriptListElWithMaxPrior^.Descriptor^.Prioritet then
      begin
        curDescriptListElWithMaxPrior := currentDescriptorListElement;
        preDescriptListElWithMaxPrior := preDescriptorListElement;
      end;
        preDescriptorListElement := preDescriptorListElement^.Next;
    end;
    if preDescriptListElWithMaxPrior <> nil then
    begin
      preDescriptListElWithMaxPrior^.Next := curDescriptListElWithMaxPrior^.Next
    end
    else
    begin
      First := curDescriptListElWithMaxPrior^.Next
    end;
    curDescriptListElWithMaxPrior^.Next := nil;
    processDescriptor := curDescriptListElWithMaxPrior^.Descriptor;
    b := true;
{    Temp := First;
    First := First^.Next;
    AValue := Temp^.Descriptor;
    Dispose(Temp);}
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
    if tempStr = '������' then Result := cMEMORY;
    if tempStr = '���������' then Result := cPROCESSOR;
    if tempStr = '����\�����' then Result := cIO;
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
    spEmpty:  Result := '��������';
    spBusy:   Result := '�����';
    end;
  end;

  function CommandToStr(ACommand: TCommand): String;
  begin
    case ACommand of
    cNONE:      Result := '����������';
    cMEMORY:    Result := '������';
    cPROCESSOR: Result := '����������';
    cIO:        Result := '����/�����';
    end;
  end;

  function StateToStr(AState: TStateProcess): String;
  begin
    case AState of
    spNone:  Result := '����������';
    spRun:   Result := '����������';
    spReady: Result := '�����';
    spWait:  Result := '�������';
    end;
  end;

  function PriorToStr(APrior: TPrioritetProcess): String;
  begin
    case APrior of
    ppLowest:  Result := '����� ������';
    ppLow:     Result := '������';
    ppNormal:  Result := '����������';
    ppHigh:    Result := '�������';
    ppHighest: Result := '����� �������';
    end;
  end;
end.
 
