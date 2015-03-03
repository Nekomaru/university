unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    ArrayLabel: TLabel;
    ArrayEdit: TEdit;
    RunButton: TButton;
    ResultLabel: TLabel;
    procedure RunButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  StringList: TStringList;  //объект дл€ преобразовани€ строки в массив
  i: integer;               //итератор
  prevElement: integer;     //предыдущий элемент
  curElement: integer;      //текущий элемент
  elementCount: integer;    //кол-во элементов удовлетвор€ющих условию
begin
  //очищаем метку с результатом
  ResultLabel.Caption := '';

  //изначально условию удовлетвор€ют 0 элементов
  elementCount := 0;

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем раздел€ющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждего элемента массива, кроме 0
  for i := StringList.Count - 1 downto 1 do
  begin
    //сохран€ем предыдущий элемент
    curElement := StrToInt(StringList.Strings[i]);
    //сохран€ем текущий элемент
    prevElement := StrToInt(StringList.Strings[i - 1]);

    //если текущий элемент больше предыдущего
    if curElement > prevElement then
    begin
      //выводим индекс текущего элемента
      ResultLabel.Caption := ResultLabel.Caption + ' ' + IntToStr(i);
      //увеличиваем кол-во элементов удовлетвор€ющих условию
      elementCount := elementCount + 1;
    end;
  end;
  //выводим разделитель ';' и кол-во элементов удовлетвор€ющих условию
  ResultLabel.Caption := ResultLabel.Caption + '; ' + IntToStr(elementCount);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //»нициализируем поле ввода
  ArrayEdit.Text := '5 7 -12 22 44';
end;

end.
